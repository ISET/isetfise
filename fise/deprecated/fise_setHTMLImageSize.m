function fise_setHTMLImageSize(inputFile, outputFile, widthPx)
% Adjusts the image sizes
%
% Could be updated based on the image tag.
%

% Example:
%{
fise_setHTMLImageSize('fise_opticsPSF.html', 'fise_opticsPSF.html', 600)
%}

% Read the entire HTML file into a string
htmlText = fileread(inputFile);

% Find all <img ...> tags
expr = '<img[^>]*>';
imgTags = regexp(htmlText, expr, 'match');

% Loop through each tag and replace it with a modified version
for i = 1:length(imgTags)
    oldTag = imgTags{i};

    % Remove existing width/height
    cleanedTag = regexprep(oldTag, 'width\s*=\s*"\d+"', '');
    cleanedTag = regexprep(cleanedTag, 'height\s*=\s*"\d+"', '');

    % Add new width (preserving aspect ratio)
    % If it already has other attributes, just insert width
    newTag = regexprep(cleanedTag, '>$', sprintf(' width="%d">', widthPx));

    % Replace old with new in the HTML
    htmlText = strrep(htmlText, oldTag, newTag);
end

% Write out the modified HTML
fid = fopen(outputFile, 'w');
fwrite(fid, htmlText);
fclose(fid);

fprintf('Updated HTML written to %s with width=%d (aspect ratio preserved).\n', outputFile, widthPx);
end


