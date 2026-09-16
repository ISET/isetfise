function [hFig, x, y] = fise_gaborWaveletSVG(varargin)
% GABORWAVELETSVG Create and export a 1D Gabor wavelet to an SVG file.
%
% Optional Name-Value Pairs:
%   'nCycles'      - Number of carrier cycles across the window (default: 5)
%   'phase'        - Phase in radians: 0 for cos (even), -pi/2 for sin (odd) (default: 0)
%   'nSD'          - Half-width of window in standard deviations (default: 3.5)
%   'showEnvelope' - Plot the Gaussian envelope as a dashed line (default: false)
%   'lineWidth'    - Line width for the curve (default: 2)
%   'color'        - Color of the wavelet (default: 'k')
%   'filename'     - Output SVG path/name (default: 'gabor_wavelet.svg')
%   'nSamples'     - Number of sampling points (default: 1000)

p = inputParser;
p.addParameter('nCycles', 5, @isnumeric);
p.addParameter('phase', 0, @isnumeric);
p.addParameter('nSD', 3.5, @isnumeric);
p.addParameter('showEnvelope', false, @islogical);
p.addParameter('lineWidth', 2, @isnumeric);
p.addParameter('color', 'k');
p.addParameter('filename', 'gabor_wavelet.svg', @ischar);
p.addParameter('nSamples', 1000, @isnumeric);
p.parse(varargin{:});

nCycles      = p.Results.nCycles;
phase        = p.Results.phase;
nSD          = p.Results.nSD;
showEnvelope = p.Results.showEnvelope;
lw           = p.Results.lineWidth;
c            = p.Results.color;
filename     = p.Results.filename;
nSamples     = p.Results.nSamples;

% Domain centered at 0, spanning [-nSD*sigma, +nSD*sigma]
x = linspace(-nSD, nSD, nSamples);

% Gaussian envelope and sinusoidal carrier
env     = exp(-0.5 * x.^2);
carrier = cos(2 * pi * (nCycles / (2 * nSD)) * x + phase);
y       = env .* carrier;

% Plot
hFig = figure('Color', 'w');
hold on;
if showEnvelope
    plot(x,  env, '--', 'Color', [0.6 0.6 0.6], 'LineWidth', 1);
    plot(x, -env, '--', 'Color', [0.6 0.6 0.6], 'LineWidth', 1);
end
plot(x, y, 'LineWidth', lw, 'Color', c);
hold off;

axis off;

if ~isempty(filename)
    print(hFig, filename, '-dsvg');
end
