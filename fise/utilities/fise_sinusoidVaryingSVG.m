function [hFig, x, y, phase] = fise_sinusoidVaryingSVG(varargin)
% SINUSOIDVARYINGSVG Generate and export a frequency/phase-modulated sinusoid to SVG.
%
% Optional Name-Value Pairs:
%   'type'       - 'chirp' (linearly varying frequency) or 'phaseMod' (default: 'chirp')
%
%   For 'chirp':
%   'fStart'     - Starting frequency (cycles across domain, default: 2)
%   'fEnd'       - Ending frequency (cycles across domain, default: 8)
%
%   For 'phaseMod':
%   'fCarrier'   - Nominal carrier frequency (default: 8)
%   'fMod'       - Slow modulation rate (cycles across domain, default: 1)
%   'phaseMod'   - Amplitude of phase variation in radians (default: pi/2)
%
%   General:
%   'initialPhase' - Constant phase offset in radians (default: 0)
%   'lineWidth'    - Line width for plot (default: 2)
%   'color'        - Line color (default: 'k')
%   'filename'     - Output SVG path (default: 'sinusoid_varying.svg')
%   'nSamples'     - Number of sample points (default: 1500)

p = inputParser;
p.addParameter('type', 'chirp', @(s) ismember(s, {'chirp', 'phaseMod'}));
p.addParameter('fStart', 2, @isnumeric);
p.addParameter('fEnd', 8, @isnumeric);
p.addParameter('fCarrier', 8, @isnumeric);
p.addParameter('fMod', 1, @isnumeric);
p.addParameter('phaseMod', pi/2, @isnumeric);
p.addParameter('initialPhase', 0, @isnumeric);
p.addParameter('lineWidth', 2, @isnumeric);
p.addParameter('color', 'k');
p.addParameter('filename', 'sinusoid_varying.svg', @ischar);
p.addParameter('nSamples', 1500, @isnumeric);

p.parse(varargin{:});

x = linspace(0, 1, p.Results.nSamples);

switch p.Results.type
    case 'chirp'
        f0 = p.Results.fStart;
        f1 = p.Results.fEnd;
        phase = 2 * pi * (f0 * x + 0.5 * (f1 - f0) * x.^2) + p.Results.initialPhase;
    case 'phaseMod'
        fc = p.Results.fCarrier;
        fm = p.Results.fMod;
        dPhi = p.Results.phaseMod;
        phase = 2 * pi * fc * x + dPhi * sin(2 * pi * fm * x) + p.Results.initialPhase;
end

y = sin(phase);

% Plot and export
hFig = ieFigure;
plot(x, y, 'LineWidth', p.Results.lineWidth, 'Color', p.Results.color);
axis off;

if ~isempty(p.Results.filename)
    print(hFig, p.Results.filename, '-dsvg');
end

end