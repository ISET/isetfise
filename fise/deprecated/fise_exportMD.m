function output = fise_exportMD(livescript_path, output_path)
% Export a live script to Markdown.
%
% Synopsis
%    output = fise_exportMD(livescript_path, markdown_path)
%
% Inputs
%    livescript_path
%
% Optional
%    output_path  (defaults to livescript_path with md extension)
%
% Return
%    output_path 
%
% Brief
%    Convert a livescript to Markdown, possibly setting some
%    parameters in the style on the way.  The md file can be read by
%    Quarto, edited, and rendered into the FISE book.  
%    
%    Math renders correctly.  Images seem to be placed reasonably and
%    can be controlled in Quarto, I think.
%
% TODO:
%   Remove double blank lines, making them a single blank line.
%   Check if we want to add style_tag parameters (see code).
%  
% See also
%   export

% Examples:
%{
liveScript = which('fise_diffraction.mlx');
p = fileparts(liveScript);
mdOutput = fullfile(p,'fise_diffraction.md');
output = fise_exportMD(liveScript,mdOutput);
disp(output)

% Also works
output = fise_exportMD(liveScript);
disp(output)

%}

%%
if notDefined('output_path')
    [p,name,~] = fileparts(livescript_path);
    output_path = fullfile(p,[name,'.md']);
end

%% HTML is not an export option
output = export(livescript_path, output_path, ...
    Format="markdown", ...
    AcceptHTML=true);
% EmbedImages=false, ...

end

%{
% To modify the Markdown file and add a style_tag line, you can do
% this:

txt = fileread(output_path);

% Add custom styles at the top.
style_tag = ['<style>', ...
    'body { font-family: Georgia; font-size: 12px; }', ...
    'img { max-width: 600px; height: auto; }', ...
    '</style>'];

% Insert style tag after <head>
txt = regexprep(txt, '<head>', ['<head>' style_tag]);

% Write modified Markdown

fid = fopen(output_path, 'w');
fprintf(fid, '%s', txt);
fclose(fid);

end
%}