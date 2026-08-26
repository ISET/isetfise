% Graph of human pupil size as a function of luminance level
%
%

%%

lumSteps = logspace(-6,6,20);
[d1,a] = humanPupilSize(lumSteps,'ms');
[d2,a] = humanPupilSize(lumSteps,'dg');

%%
ieNewGraphWin
p = semilogx(lumSteps,d1,'r-',lumSteps,d2,'k--');
for ii=1:2, p(ii).LineWidth = 2; end
grid on
xlabel('Luminance (cd/m2)')
ylabel('Diameter (mm)')
legend({'Moon-Spencer, 1944','DeGroot and Gebhard, 1952'})

%% END