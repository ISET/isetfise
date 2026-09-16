%% Creating curves that I use for figures in FISE


%% Sinusoid
%
% 100 samples per cycle
% 

nCycles = 5;
x = linspace(0, 2*pi*nCycles, 100*nCycles);
y = sin(x);
figure; plot(x, y, 'LineWidth', 2, 'Color','k');
axis off;
print('sine_wave.svg', '-dsvg');

%% Gabor
% See also
%  function [hFig, x, y] = fise_gaborWaveletSVG(varargin)


nCycles = 5;
nSD = 3.5; % 3.5 SDs ensures the envelope tapers smoothly to zero at edges
x = linspace(-nSD, nSD, 1000);

envelope = exp(-0.5 * x.^2);
carrier  = cos(2 * pi * (nCycles / (2 * nSD)) * x); % even-symmetric (cosine)
% carrier = sin(2 * pi * (nCycles / (2 * nSD)) * x); % odd-symmetric (sine)

y = envelope .* carrier;

ieFigure;
plot(x, y, 'LineWidth', 2, 'Color', 'k');
axis off;
% set(gcf, 'Color', 'none'); % Transparent background for Affinity
print('gabor_wavelet.svg', '-dsvg');

%% Wobbling sinusoid
%
% Notice that the FFT amplitude is reduced - and spread - by the
% wobbling phase
%

[~, ~, y1, phase1] = fise_sinusoidVaryingSVG('type','phaseMod',...
    'phaseMod',pi, ...
    'filename','sinusoid_varying.svg');
[~, ~, y2, phase2] = fise_sinusoidVaryingSVG('type','phaseMod',...
    'phaseMod',0, ...
    'filename','sinusoid_not_varying.svg');

y1 = abs(fft(y1)); mx = max(y1);
y2 = abs(fft(y2)); mx = max(max(y2),mx); 

ieFigure;
plot(y1/mx); hold on;
plot(y2/mx,'k');
set(gca,'xlim',[0 20]);
grid on;
xlabel('Frequency'); ylabel('Normalized amplitude');

%%
