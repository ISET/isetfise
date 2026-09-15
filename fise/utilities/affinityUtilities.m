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

%%