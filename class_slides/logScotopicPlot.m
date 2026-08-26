% Log plot of the scotopic spectral sensitivity curve
%
% Wandell

%% ISETCam data
fullName = fullfile(isetRootPath,'data','human','scotopicLuminosity.mat');
wave = 400:1:700;
data = vcReadSpectra(fullName,wave);

%% Linear scale

ieNewGraphWin;
p = plot(wave,data,'k-');
p.LineWidth = 2;
xlabel('Wavelength (nm)');
ylabel('Relative sensitivity');
grid on;

%% Semi log axis version

ieNewGraphWin;
p = semilogy(wave,data,'k-');
p.LineWidth = 2;
xlabel('Wavelength (nm)');
ylabel('Relative sensitivity');
grid on;

%% END