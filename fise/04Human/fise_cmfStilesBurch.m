%% fise_cmfStilesBurch
%
% Plot the Stiles & Burch 2-degree (1955) and 10-degree (1959) RGB
% color-matching functions (energy basis) from ISETCam's human standards.
%
% Description:
%   Loads 'cmf_SB1955_2deg_energy' and 'cmf_SB1959_10deg_energy' via
%   ieReadSpectra and produces publication-quality plots of the RGB
%   color-matching functions measured with monochromatic primaries at
%   645.2 nm, 526.3 nm, and 444.4 nm (15,500, 19,000, and 22,500 cm^-1).
%   Both figures use identical axis limits so they can be compared
%   directly in a Quarto panel-tabset without axis jumping.
%
% Outputs:
%   Saves 'cmf-SB1959-10deg-energy.png' and 'cmf-SB1955-2deg-energy.png'
%   in fiseBookPath/chapters/images/human/05-wavelength-encoding/matching/
%   when exportPlots is true.
%
% Dependencies:
%   - ISETCam (ieInit, ieReadSpectra, ieFigure, fise_plotDefaults)
%   - isetfise (fiseBookPath)
%
% See also:
%   fise_cieStandards, data_humanStandards, ieReadSpectra, fise_plotDefaults

%% Initialize
ieInit;
fise_plotDefaults;

exportPlots = true;
imgDir = fullfile(fiseBookPath, 'chapters', 'images', 'human', ...
    '05-wavelength-encoding', 'matching');

% Publication-grade RGB line colors with high legibility on white
rgbColors = [ ...
    0.85 0.15 0.20;  % Red primary CMF r(lambda)
    0.15 0.65 0.25;  % Green primary CMF g(lambda)
    0.15 0.38 0.85]; % Blue primary CMF b(lambda)

% Primary wavelengths (nm) corresponding to 15500, 19000, 22500 cm^-1
primaryWave = 1e7 ./ [15500, 19000, 22500]; % [645.16, 526.32, 444.44] nm

%% 1. Stiles & Burch (1959) 10-deg energy CMFs
[cmf10, wave10] = ieReadSpectra('cmf_SB1959_10deg_energy');

hdl10 = localPlotRGB(wave10, cmf10, rgbColors, ...
    {'\it r\rm_{10}(\lambda)  (645.2 nm)', ...
     '\it g\rm_{10}(\lambda)  (526.3 nm)', ...
     '\it b\rm_{10}(\lambda)  (444.4 nm)'});

if exportPlots
    outFile10 = fullfile(imgDir, 'cmf-SB1959-10deg-energy.png');
    exportgraphics(hdl10, outFile10, 'Resolution', 300);
    fprintf('Exported figure to %s\n', outFile10);
end

%% 2. Stiles & Burch (1955) 2-deg energy CMFs
[cmf2, wave2] = ieReadSpectra('cmf_SB1955_2deg_energy');

hdl2 = localPlotRGB(wave2, cmf2, rgbColors, ...
    {'\it r\rm_{2}(\lambda)  (645.2 nm)', ...
     '\it g\rm_{2}(\lambda)  (526.3 nm)', ...
     '\it b\rm_{2}(\lambda)  (444.4 nm)'});

if exportPlots
    outFile2 = fullfile(imgDir, 'cmf-SB1955-2deg-energy.png');
    exportgraphics(hdl2, outFile2, 'Resolution', 300);
    fprintf('Exported figure to %s\n', outFile2);
end

%% Helper function for consistent figure styling
function hdl = localPlotRGB(wave, cmf, rgbColors, legendLabels)
    hdl = ieFigure([], 'default');
    set(hdl, 'Units', 'pixels', 'Position', [100 100 760 520]);

    ax = gca;
    hold(ax, 'on');

    % Zero reference line to highlight the negative lobe of r(lambda)
    yline(ax, 0, '--', 'Color', [0.45 0.45 0.45], 'LineWidth', 1.2, ...
        'HandleVisibility', 'off');

    % Plot R, G, B color-matching functions
    hR = plot(ax, wave, cmf(:, 1), '-', 'Color', rgbColors(1, :), 'LineWidth', 2.4);
    hG = plot(ax, wave, cmf(:, 2), '-', 'Color', rgbColors(2, :), 'LineWidth', 2.4);
    hB = plot(ax, wave, cmf(:, 3), '-', 'Color', rgbColors(3, :), 'LineWidth', 2.4);

    hold(ax, 'off');

    % Axes formatting (shared across 2-deg and 10-deg plots)
    xlim(ax, [390 730]);
    ylim(ax, [-0.6 3.4]);
    xticks(ax, 400:50:700);
    yticks(ax, -0.5:0.5:3.5);
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
    ylabel(ax, 'Relative primary energy', 'FontName', 'Georgia', 'FontSize', 18, ...
        'Color', [0.2 0.2 0.2]);

    lgd = legend(ax, [hR, hG, hB], legendLabels, 'Location', 'northwest');
    lgd.FontName = 'Georgia';
    lgd.FontSize = 14;
    lgd.Box = 'off';
end
