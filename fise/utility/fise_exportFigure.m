function fise_exportFigure(figHandle, filename, varargin)
% Export a figure as PNG and insert in Live Script
%
%   fise_exportFigure(figHandle, filename)
%   fise_exportFigure(figHandle, filename, 'Resolution', 150, 'Width', 600, 'Height', 400)
%
%   - figHandle: handle to the figure (use gcf for current figure)
%   - filename: name of the PNG file to save (e.g., 'fig1.png')
%   - Optional parameters:
%       'Resolution': DPI setting for PNG (default 150)
%       'Width', 'Height': pixel dimensions of the figure window

% Parse input
p = inputParser;
addRequired(p, 'figHandle');
addRequired(p, 'filename', @ischar);
addParameter(p, 'Resolution', 150, @isnumeric);
addParameter(p, 'Width', [], @isnumeric);
addParameter(p, 'Height', [], @isnumeric);
parse(p, figHandle, filename, varargin{:});

% Optionally set figure size in pixels
if ~isempty(p.Results.Width) && ~isempty(p.Results.Height)
    set(figHandle, 'Units', 'pixels');
    figHandle.Position(3:4) = [p.Results.Width, p.Results.Height];
end

% Export to PNG
switch class(figHandle)
    case {'sceneWindow_App','oiWindow_App'}
        exportapp(figHandle.figure1, filename);
    otherwise
        exportgraphics(figHandle, filename, 'Resolution', p.Results.Resolution);
end
fprintf('Exported figure to %s at %d DPI\n', filename, p.Results.Resolution);

% Insert image into Live Script (only works interactively)
if usejava('desktop') && ~isdeployed
    imshow(filename);  % This line embeds the image reference
else
    fprintf('Non-interactive mode: saved image but did not insert into Live Script.\n');
end

end
