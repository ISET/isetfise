%% Graph of the XYZ functions

%%
wave = 400:700;
XYZ = vcReadSpectra('XYZ',wave);

vcNewGraphWin;
p = plot(wave,XYZ(:,1),'r-',wave,XYZ(:,2),'g-',wave,XYZ(:,3),'b-');
for ii=1:3
    p(ii).LineWidth = 2;
end

grid on;
xlabel('Wavelength (nm)')
legend({'x-bar','y-bar','z-bar'})

%%
