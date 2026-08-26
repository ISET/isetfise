function summary = fise_convertMlxToM(rootDir, varargin)
% Convert Live Scripts (.mlx) to MATLAB scripts (.m) under a root directory.
%
%   summary = fise_convertMlxToM(rootDir)
%   summary = fise_convertMlxToM(rootDir, 'OverwritePolicy', 'ifNewer')
%   summary = fise_convertMlxToM(rootDir, 'MoveMlxTo', '/path/to/archive')
%
% Parameters
%   rootDir          : Root folder to scan recursively for .mlx files.
%                      Defaults to the repository code/ directory.
%   OverwritePolicy  : 'ifNewer' (default), 'always', or 'never'.
%   MoveMlxTo        : Optional folder where original .mlx files are moved
%                      after conversion. Empty by default (no move).
%   PreserveTree     : If true, preserve folder structure when moving .mlx.
%                      Default true.
%   Verbose          : Print progress messages. Default true.
%
% Return
%   summary : Struct containing counts and per-file status.

if notDefined('rootDir') || isempty(rootDir)
    utilityDir = fileparts(mfilename('fullpath'));
    rootDir = fullfile(fileparts(utilityDir));
end

ip = inputParser;
ip.addParameter('OverwritePolicy', 'ifNewer', ...
    @(x) any(strcmpi(x, {'ifNewer','always','never'})));
ip.addParameter('MoveMlxTo', '', @ischar);
ip.addParameter('PreserveTree', true, @islogical);
ip.addParameter('Verbose', true, @islogical);
ip.parse(varargin{:});

overwritePolicy = lower(ip.Results.OverwritePolicy);
moveMlxTo = ip.Results.MoveMlxTo;
preserveTree = ip.Results.PreserveTree;
verbose = ip.Results.Verbose;

if ~isfolder(rootDir)
    error('Root directory does not exist: %s', rootDir);
end

if ~isempty(moveMlxTo) && ~isfolder(moveMlxTo)
    mkdir(moveMlxTo);
end

mlxFiles = dir(fullfile(rootDir, '**', '*.mlx'));

summary = struct();
summary.rootDir = rootDir;
summary.total = numel(mlxFiles);
summary.converted = 0;
summary.skipped = 0;
summary.failed = 0;
summary.moved = 0;
summary.moveFailed = 0;
summary.files = repmat(struct( ...
    'mlxPath', '', ...
    'mPath', '', ...
    'action', '', ...
    'moveAction', '', ...
    'message', ''), [summary.total, 1]);

for ii = 1:numel(mlxFiles)
    mlxPath = fullfile(mlxFiles(ii).folder, mlxFiles(ii).name);
    [~, baseName] = fileparts(mlxFiles(ii).name);
    mPath = fullfile(mlxFiles(ii).folder, [baseName '.m']);

    summary.files(ii).mlxPath = mlxPath;
    summary.files(ii).mPath = mPath;

    doConvert = true;
    if exist(mPath, 'file')
        switch overwritePolicy
            case 'always'
                doConvert = true;
            case 'never'
                doConvert = false;
            case 'ifnewer'
                mInfo = dir(mPath);
                doConvert = mlxFiles(ii).datenum > mInfo.datenum;
        end
    end

    if doConvert
        try
            matlab.internal.liveeditor.openAndConvert(mlxPath, mPath);
            summary.converted = summary.converted + 1;
            summary.files(ii).action = 'converted';
            if verbose
                fprintf('CONVERTED: %s -> %s\n', mlxPath, mPath);
            end
        catch ME
            summary.failed = summary.failed + 1;
            summary.files(ii).action = 'failed';
            summary.files(ii).message = ME.message;
            if verbose
                fprintf(2, 'FAILED: %s (%s)\n', mlxPath, ME.message);
            end
            continue
        end
    else
        summary.skipped = summary.skipped + 1;
        summary.files(ii).action = 'skipped';
        if verbose
            fprintf('SKIPPED: %s\n', mPath);
        end
    end

    if ~isempty(moveMlxTo)
        try
            relPath = erase(mlxPath, [rootDir filesep]);
            if preserveTree
                targetPath = fullfile(moveMlxTo, relPath);
                targetDir = fileparts(targetPath);
                if ~isfolder(targetDir)
                    mkdir(targetDir);
                end
            else
                targetPath = fullfile(moveMlxTo, mlxFiles(ii).name);
            end
            movefile(mlxPath, targetPath, 'f');
            summary.moved = summary.moved + 1;
            summary.files(ii).moveAction = 'moved';
            if verbose
                fprintf('MOVED: %s -> %s\n', mlxPath, targetPath);
            end
        catch ME
            summary.moveFailed = summary.moveFailed + 1;
            summary.files(ii).moveAction = 'moveFailed';
            summary.files(ii).message = ME.message;
            if verbose
                fprintf(2, 'MOVE FAILED: %s (%s)\n', mlxPath, ME.message);
            end
        end
    end
end

if verbose
    fprintf(['\nSummary: total=%d converted=%d skipped=%d failed=%d', ...
        ' moved=%d moveFailed=%d\n'], ...
        summary.total, summary.converted, summary.skipped, ...
        summary.failed, summary.moved, summary.moveFailed);
end

end
