%% fise_cieStandards
%
% Plot the CIE XYZ color-matching functions (1931 2-deg, 1964 10-deg, and
% 2012/2015 physiologically-based 2-deg) and the CIE 2006 (Stockman &
% Sharpe 2000) LMS cone fundamentals (energy basis) from ISETCam.
%
% Description:
%   Generates publication-quality figures for the CIE Standards section of
%   FISE Chapter 5 (Wavelength Encoding):
%     1. CIE 1931 2-deg XYZ ('XYZ')
%     2. CIE 1964 10-deg XYZ ('cmf_CIE1964_10deg_energy')
%     3. CIE 2012 (TR 170-2:2015) 2-deg physiologically-based XYZ
%        ('cmf_CIE2012_2deg_energy')
%     4. CIE 2006 (Stockman & Sharpe 2000) 2-deg and 10-deg LMS cone
%        fundamentals ('cones_CIE2006_2deg_energy',
%        'cones_CIE2006_10deg_energy')
%
% Outputs:
%   Saves PNG figures at 300 DPI in
%   fiseBookPath/chapters/images/human/05-wavelength-encoding/matching/
%   when exportPlots is true.
%
% Dependencies:
%   - ISETCam (ieInit, ieReadSpectra, ieFigure, fise_plotDefaults)
%   - isetfise (fiseBookPath)
%
% See also:
%   fise_cmfStilesBurch, data_humanStandards, ieReadSpectra, fise_plotDefaults

%% Initialize
ieInit;
fise_plotDefaults;

exportPlots = true;
imgDir = fullfile(fiseBookPath, 'chapters', 'images', 'human', ...
    '05-wavelength-encoding', 'matching');

% Publication-grade line colors (high legibility on white background)
triColors = [ ...
    0.85 0.15 0.20;  % X or L (long-wavelength / red-like)
    0.15 0.65 0.25;  % Y or M (middle-wavelength / green-like)
    0.15 0.38 0.85]; % Z or S (short-wavelength / blue-like)

wave = 390:1:730;

%% 1. CIE 1931 2-deg XYZ color-matching functions
xyz1931 = ieReadSpectra('XYZ', wave);

hdl1931 = localPlotCurves(wave, xyz1931, triColors, ...
    {'\it x\rm\bf\color[rgb]{0.85,0.15,0.20}', ...
     '\it y\rm\bf\color[rgb]{0.15,0.65,0.25}', ...
     '\it z\rm\bf\color[rgb]{0.15,0.38,0.85}'}, ...
    {'$\bar{x}(\lambda)$', '$\bar{y}(\lambda)$', '$\bar{z}(\lambda)$'}, ...
    'Tristimulus value', [0 2.2], 0:0.5:2.0);

if exportPlots
    out1931 = fullfile(imgDir, 'cmf-CIE1931-2deg-XYZ.png');
    exportgraphics(hdl1931, out1931, 'Resolution', 300);
    fprintf('Exported figure to %s\n', out1931);
end

%% 2. CIE 1964 10-deg XYZ color-matching functions
xyz1964 = ieReadSpectra('cmf_CIE1964_10deg_energy', wave);

hdl1964 = localPlotCurves(wave, xyz1964, triColors, ...
    {}, ...
    {'$\bar{x}_{10}(\lambda)$', '$\bar{y}_{10}(\lambda)$', '$\bar{z}_{10}(\lambda)$'}, ...
    'Tristimulus value', [0 2.2], 0:0.5:2.0);

if exportPlots
    out1964 = fullfile(imgDir, 'cmf-CIE1964-10deg-XYZ.png');
    exportgraphics(hdl1964, out1964, 'Resolution', 300);
    fprintf('Exported figure to %s\n', out1964);
end

%% 3. CIE 2012 (2015) 2-deg physiologically-based XYZ CMFs
xyz2012 = ieReadSpectra('cmf_CIE2012_2deg_energy', wave);

hdl2012 = localPlotCurves(wave, xyz2012, triColors, ...
    {}, ...
    {'$\bar{x}_{\mathrm{F}}(\lambda)$', ...
     '$\bar{y}_{\mathrm{F}}(\lambda)$', ...
     '$\bar{z}_{\mathrm{F}}(\lambda)$'}, ...
    'Tristimulus value', [0 2.2], 0:0.5:2.0);

if exportPlots
    out2012 = fullfile(imgDir, 'cmf-CIE2012-2deg-XYZ.png');
    exportgraphics(hdl2012, out2012, 'Resolution', 300);
    fprintf('Exported figure to %s\n', out2012);
end

%% 4. CIE 2006 (Stockman & Sharpe 2000) 2-deg LMS cone fundamentals (energy)
cones2 = ieReadSpectra('cones_CIE2006_2deg_energy', wave);

hdlCones2 = localPlotCurves(wave, cones2, triColors, ...
    {}, ...
    {'$l_{2}(\lambda)$ (L-cone)', ...
     '$m_{2}(\lambda)$ (M-cone)', ...
     '$s_{2}(\lambda)$ (S-cone)'}, ...
    'Normalized sensitivity (energy)', [0 1.08], 0:0.2:1.0);

if exportPlots
    outCones2 = fullfile(imgDir, 'cones-CIE2006-2deg-energy.png');
    exportgraphics(hdlCones2, outCones2, 'Resolution', 300);
    fprintf('Exported figure to %s\n', outCones2);
end

%% 5. CIE 2006 (Stockman & Sharpe 2000) 10-deg LMS cone fundamentals (energy)
cones10 = ieReadSpectra('cones_CIE2006_10deg_energy', wave);

hdlCones10 = localPlotCurves(wave, cones10, triColors, ...
    {}, ...
    {'$l_{10}(\lambda)$ (L-cone)', ...
     '$m_{10}(\lambda)$ (M-cone)', ...
     '$s_{10}(\lambda)$ (S-cone)'}, ...
    'Normalized sensitivity (energy)', [0 1.08], 0:0.2:1.0);

if exportPlots
    outCones10 = fullfile(imgDir, 'cones-CIE2006-10deg-energy.png');
    exportgraphics(hdlCones10, outCones10, 'Resolution', 300);
    fprintf('Exported figure to %s\n', outCones10);
end

%% Helper function for consistent figure styling
function hdl = localPlotCurves(wave, data, colors, ~, legendLabels, yLabelStr, yLimVec, yTickVec)
    hdl = ieFigure([], 'default');
    set(hdl, 'Units', 'pixels', 'Position', [100 100 760 520]);

    ax = gca;
    hold(ax, 'on');

    h1 = plot(ax, wave, data(:, 1), '-', 'Color', colors(1, :), 'LineWidth', 2.4);
    h2 = plot(ax, wave, data(:, 2), '-', 'Color', colors(2, :), 'LineWidth', 2.4);
    h3 = plot(ax, wave, data(:, 3), '-', 'Color', colors(3, :), 'LineWidth', 2.4);

    hold(ax, 'off');

    xlim(ax, [390 730]);
    ylim(ax, yLimVec);
    xticks(ax, 400:50:700);
    yticks(ax, yTickVec);
    grid(ax, 'on');
    ax.GridAlpha = 0.2;
    ax.GridColor = [0.3 0.3 0.3];
    ax.Box = 'off';
    ax.TickDir = 'out';
    ax.LineWidth = 1.2;
    ax.FontName = 'Georgia';
    ax.FontSize = 16;

    xlabel(ax, 'Wavelength (nm)', 'FontName', 'Georgia', 'FontSize', 18, ...
        'Color', [0.2 0.2 0.2]);
    ylabel(ax, yLabelStr, 'FontName', 'Georgia', 'FontSize', 18, ...
        'Color', [0.2 0.2 0.2]);

    lgd = legend(ax, [h1, h2, h3], legendLabels, ...
        'Interpreter', 'latex', 'Location', 'northeast');
    lgd.FontSize = 15;
    lgd.Box = 'off';
end

