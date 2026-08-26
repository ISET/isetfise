function bookPath = fiseBookPath()
% Return the path to the FISE-2025-Quarto book repository
%
% The fise/ scripts live in isetfise, but several of them export figures
% directly into the book's chapters/images/ tree. The book repository is
% expected at ~/Documents/FISE-2025-Quarto on every machine that runs these
% scripts, regardless of where isetfise itself is checked out, so figure
% export keeps working across machines with different home directories.
%
% Example:
%   fiseBookPath
%   fullfile(fiseBookPath, 'chapters', 'images')

if ispc
    homeDir = getenv('USERPROFILE');
else
    homeDir = getenv('HOME');
end

bookPath = fullfile(homeDir, 'Documents', 'FISE-2025-Quarto');

if ~isfolder(bookPath)
    error('fiseBookPath:notFound', ...
        ['Expected the FISE book at %s, but it does not exist.\n', ...
         'Clone it there, or update fiseBookPath.m for this machine.'], ...
        bookPath);
end

end
