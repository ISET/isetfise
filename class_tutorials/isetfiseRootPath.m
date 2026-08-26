function rootPath=psych221RootPath()
% Return the path to the root iset directory
%
% This function must reside in the directory at the base of the teach/
% psych221 directory structure.  It is used to determine the location
% of various sub-directories.
% 
% Example:
%   fullfile(psych221RootPath,'data')

rootPath = which('psych221RootPath');

rootPath=fileparts(rootPath);

end
