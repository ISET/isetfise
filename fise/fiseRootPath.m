function rootPath=fiseRootPath()
% Return the path to the root FISE-git directory
%
% This function resides in the **code** subdirectory the FISE-git
% repository. It is used to determine the location of the main
% FISE-git directory on the user's machine.
%
% Example:
%   fiseRootPath
%   fullfile(fiseRootPath,'chapters','images')

rootPath=which('fiseRootPath');

% The file is in /code.  We return one directory up.
rootPath = fileparts(fileparts(rootPath));


end
