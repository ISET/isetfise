%% Spatial Coherence Length and the 1/f Spectrum Falloff
% This script illustrates how a finite spatial coherence length creates the
% empirical 1/f^\alpha contrast falloff across viewing distances.
%
% In natural scenes, the contrast modulation and phase of texture patterns 
% rarely hold over an infinite extent. Instead, patterns maintain consistent
% frequency and phase over a characteristic number of cycles (N_c around 3 to 5).
% Consequently, the spatial coherence length in space is inversely related to
% spatial frequency:
%
% $$L_c(f) = \frac{N_c}{f}$$
%
% When an observer views a surface pattern from varying distances:
%
% * *Close distance (d = 0.25)*: The field of view captures only a few
%   cycles (~N_c). The pattern is coherent across the aperture,
%   concentrating its contrast into a sharp, high-amplitude Fourier peak.
% * *Far distance (d = 1.00)*: The field of view captures many cycles
%   (>> N_c). Random phase drift across the broader aperture disperses
%   spectral energy across adjacent frequencies, reducing the measured peak
%   amplitude.
%
% By Parseval's theorem, preserving constant physical surface contrast means that
% spectral broadening directly reduces peak Fourier amplitude, yielding the
% empirical power-law falloff:
%
% $$A(f) = \frac{C}{f^\alpha}$$
%
% *Note on 1D vs. 2D scaling*: In a 1D aperture of width W, summing
% M independent random-phase patches yields coherent amplitude \sqrt{M},
% giving 1D amplitude falloff:
%
% $$A_{\rm 1D}(f) \propto \frac{\sqrt{f}}{f} = \frac{1}{f^{0.5}}$$
%
% (\alpha between 0.5 and 0.7). In 2D, area scaling (W^2) yields M \propto f^2,
% giving 2D amplitude falloff:
%
% $$A_{\rm 2D}(f) \propto \frac{\sqrt{f^2}}{f^2} = \frac{1}{f^{1.0}}$$
%
% (\alpha = 1.0), which corresponds to the classic 2D power spectrum P(f) \propto 1/f^2.
%
% See also: |iePublish|, |gaborWaveletSVG|, |ieFigure|


%% 1. Control flags and parameters
saveSVG = false;  % Set to true when ready to export SVGs for Affinity Designer

% Random draw control
rng(10); % Seed 10 gives clean waveforms and a clear monotonic drop

% Coherence parameters
nCyclesCoherent = 5;    % Coherence length in cycles (3 to 5)
alpha           = 0.5;  % Falloff exponent: A(f) = C / f^alpha

% Carrier frequency across the full physical domain (far view, d = 1.0)
fCarrier = 10;

% Bandwidth for constant-Q coherence: sigma_f = fCarrier / nCyclesCoherent
sigma_f = fCarrier / nCyclesCoherent;

% Viewing distances (relative to full extent)
distances  = [0.25, 0.50, 1.00];
distColors = [
    0.90 0.45 0.10;   % Close (d = 0.25)
    0.20 0.60 0.80;   % Medium (d = 0.50)
    0.20 0.20 0.20    % Far (d = 1.00)
];

nSamples = 4000;


%% 2. Generate surface pattern with constant-Q spatial coherence
whiteNoise = randn(1, nSamples);
W = fft(whiteNoise);
f = [0:(nSamples/2), -(nSamples/2 - 1):-1];

% Gaussian bandpass filter centered at +/- fCarrier with bandwidth sigma_f
H = exp(-0.5 * ((abs(f) - fCarrier) / sigma_f).^2);
yFull = real(ifft(W .* H));
yFull = yFull / std(yFull); % Constant physical surface contrast

%% 3. Extract waveforms at each viewing distance (fixed FOV)
nDist     = length(distances);
waveforms = cell(nDist, 1);
spectra   = cell(nDist, 1);
peakFreq  = zeros(nDist, 1);
peakAmp   = zeros(nDist, 1);

freqAxis = linspace(0, nSamples/2, nSamples/2 + 1);

for ii = 1:nDist
    d = distances(ii);
    
    % Central window on the surface intercepted by the eye's field of view
    nWin = round(nSamples * d);
    startIdx = round((nSamples - nWin)/2) + 1;
    idx = startIdx : (startIdx + nWin - 1);
    yw = yFull(idx);
    
    % Resample across the fixed angular field of view
    yFOV = interp1(linspace(0, 1, length(yw)), yw, linspace(0, 1, nSamples));
    
    % Crucial: Normalizing to unit RMS contrast (physical contrast is distance-invariant)
    yFOV = yFOV / std(yFOV);
    waveforms{ii} = yFOV;
    
    % One-sided Fourier amplitude spectrum
    Y = abs(fft(yFOV)) / nSamples;
    Y_onesided = 2 * Y(1:nSamples/2 + 1);
    spectra{ii} = Y_onesided;
    
    % Find carrier peak (excluding DC bin)
    [peakAmp(ii), maxIdx] = max(Y_onesided(2:40));
    peakFreq(ii) = freqAxis(maxIdx + 1);
end

%% 4. Plot 1: Spatial waveforms across viewing distances
hWave = ieFigure;
hold on;
labels = {
    sprintf('Distance d = 0.25 (Close: %d cycles in FOV ~ N_c, coherent)', round(fCarrier*distances(1))), ...
    sprintf('Distance d = 0.50 (Medium: %d cycles in FOV)', round(fCarrier*distances(2))), ...
    sprintf('Distance d = 1.00 (Far: %d cycles in FOV >> N_c, incoherent)', round(fCarrier*distances(3)))
};

for ii = 1:nDist
    offset = (nDist - ii) * 2.8;
    plot(linspace(0, 1, nSamples), waveforms{ii} + offset, ...
        'Color', distColors(ii, :), 'LineWidth', 1.8);
    text(0.02, offset + 1.4, labels{ii}, ...
        'FontSize', 11, 'FontWeight', 'bold', 'Color', distColors(ii, :));
end
hold off;
ylim([-2.0, (nDist - 1) * 2.8 + 2.2]);
xlim([0, 1]);
xlabel('Visual Angle across Field of View (normalized)');
ylabel('Normalized Contrast');
title(sprintf('Captured Waveforms across Viewing Distances (Coherence N_c = %d cycles)', nCyclesCoherent));
set(gca, 'YTick', []);

if saveSVG
    print(hWave, 'coherence_waveforms_multi_distance.svg', '-dsvg');
end

%% 5. Plot 2: Fourier spectra & 1/f^alpha falloff in visual angle
hSpec = ieFigure;
hold on;
legEntries = cell(nDist, 1);
for ii = 1:nDist
    plot(freqAxis, spectra{ii}, 'Color', distColors(ii, :), 'LineWidth', 2);
    legEntries{ii} = sprintf('d = %.2f (peak = %.2f at %.1f cpd)', ...
        distances(ii), peakAmp(ii), peakFreq(ii));
end

% Overlay the 1/f^alpha reference curve anchored at the closest peak:
% A(f) = A_1 * (f_1 / f)^alpha
fFit = linspace(peakFreq(1), 2 * fCarrier, 200);
curve1overF = peakAmp(1) * (peakFreq(1) ./ fFit).^alpha;

plot(fFit, curve1overF, 'k--', 'LineWidth', 1.5);
if alpha == 1
    legEntries{end+1} = 'Theoretical 1/f envelope (C/f)';
else
    legEntries{end+1} = sprintf('Theoretical 1/f^\\alpha envelope (\\alpha = %.2f)', alpha);
end

hold off;
xlim([0, 2 * fCarrier]); % x-axis limit set to 2x carrier frequency
ylim([0, max(peakAmp) * 1.25]);
xlabel('Spatial Frequency in Visual Angle (cycles / FOV)');
ylabel('Fourier Contrast Amplitude');
title(sprintf('Diminishing Peak Amplitude (N_c = %d cycles, \\alpha = %.2f)', nCyclesCoherent, alpha));
legend(legEntries, 'Location', 'northeast');
grid on;

if saveSVG
    print(hSpec, 'coherence_spectra_multi_distance.svg', '-dsvg');
end


%% 6. Print summary table to console
fprintf('\n--- Coherence (N_c = %d cycles) & 1/f Summary ---\n', nCyclesCoherent);
for ii = 1:nDist
    fprintf('Distance: %.2f | Peak Frequency: %4.1f cyc/FOV | Peak Amplitude: %5.3f\n', ...
        distances(ii), peakFreq(ii), peakAmp(ii));
end
fprintf('---------------------------------------------------\n');
