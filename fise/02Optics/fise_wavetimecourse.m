function fise_wavetimecourse(varargin)
%
% Simulation of two quasi-monochromatic waves at 500 nm with random drift
% based on finite coherence time / length.
%
% See also
%
%  fise_wavetimecourse('ncycles',60);


%% Parse inputs
varargin = ieParamFormat(varargin);
p = inputParser;
p.addParameter('ncycles',120,@isscalar);
p.parse(varargin{:});

nTotalCycles = p.Results.ncycles;


%% Physical and Simulation Parameters
lambda0 = 500e-9;              % Central wavelength: 500 nm [meters]
c = 3e8;                       % Speed of light [m/s]
nu0 = c / lambda0;             % Optical carrier frequency (~6e14 Hz)
T0 = 1 / nu0;                  % Carrier period (~1.67 femtoseconds)

% Model a narrowband thermal/filtered source (e.g., delta_lambda ~ 25 nm)
% Coherence time is set to ~20 optical cycles to visualize drifting envelopes
nCoherenceCycles = 20;
tau_c = nCoherenceCycles * T0; % Coherence time [seconds]

% Time vector spanning 120 cycles (several coherence lengths)

tTotal = nTotalCycles * T0;
dt = T0 / 40;                  % 40 samples per cycle to resolve the wave smoothly
t = 0:dt:tTotal;
N = length(t);

%% Generate Slow Drifting Envelopes via Low-Pass Filtered Gaussian Noise
% The envelope bandwidth is delta_nu ~ 1 / tau_c
fs = 1 / dt;
fCutoff = 1 / tau_c;
[bFilt, aFilt] = butter(2, fCutoff / (fs / 2));

% Wave 1: Complex Gaussian envelope (in-phase and quadrature components)
inPhase1 = filter(bFilt, aFilt, randn(1, N));
quad1    = filter(bFilt, aFilt, randn(1, N));
env1     = inPhase1 + 1i * quad1;
env1     = env1 / rms(env1);   % Normalize envelope power

% Wave 2: Independent complex Gaussian envelope
inPhase2 = filter(bFilt, aFilt, randn(1, N));
quad2    = filter(bFilt, aFilt, randn(1, N));
env2     = inPhase2 + 1i * quad2;
env2     = env2 / rms(env2);

% Extract time-varying amplitudes and phases
A1 = abs(env1);
phi1 = unwrap(angle(env1));

A2 = abs(env2);
phi2 = unwrap(angle(env2));

% Construct the real electric field waveforms
E1 = A1 .* cos(2 * pi * nu0 * t + phi1);
E2 = A2 .* cos(2 * pi * nu0 * t + phi2);

%% Plot the Waveforms
t_fs = t * 1e15; % Convert time axis to femtoseconds (fs)

ieFigure

% Wave 1 Plot
subplot(2, 1, 1);
plot(t_fs, E1, 'Color', [0, 0.45, 0.74], 'LineWidth', 0.9); hold on;
plot(t_fs,  A1, '--k', 'LineWidth', 1.2);
plot(t_fs, -A1, '--k', 'LineWidth', 1.2);
ylabel('Electric Field E_1(t) (a.u.)');
title('One Source');
xlim([0, t_fs(end)]);
grid on;
legend('E_1(t)', 'Envelope \pm a_1(t)', 'Location', 'northeast');

% Wave 2 Plot
subplot(2, 1, 2);
plot(t_fs, E2, 'Color', [0.85, 0.33, 0.1], 'LineWidth', 0.9); hold on;
plot(t_fs,  A2, '--k', 'LineWidth', 1.2);
plot(t_fs, -A2, '--k', 'LineWidth', 1.2);
xlabel('Time (femtoseconds, 10^{-15} s)');
ylabel('Electric Field E_2(t) (a.u.)');
title('Independent Source');
xlim([0, t_fs(end)]);
grid on;
legend('E_2(t)', 'Envelope \pm a_2(t)', 'Location', 'northeast');

end
