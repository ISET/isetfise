%% Create 3D harmonics for waves and wavefronts
%
%  Show a single wave, as if it were an individual ray.
%  Show a collection of rays traveling in parallel to show the plane wave
%  Show a shift in the phase across the rays to indicate a direction change
%


% Choose three periods to illustrate
nPeriods = 3;
nSamples = 256;
x = linspace(0,nPeriods*(2*pi),nSamples);
edit 