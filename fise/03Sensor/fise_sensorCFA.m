%% fise_sensorCFA
%
%
% Make a plot of a spectral channel
%

sensor = sensorCreate('imX363');

% sensorPlot(sensor,'ir filter');

%%
[~,hdl] = sensorPlot(sensor,'spectral qe');
ax = iePlotShadeBackground(hdl.CurrentAxes);
set(ax.Children,'LineWidth',2);

%%
sensorPlot(sensor,'cfa image');

% sensorPlot(sensor,'cfa full');

%%
% This is
[~,hdl] = sensorPlot(sensor,'pd spectral qe');
ax = iePlotShadeBackground(hdl.CurrentAxes);
set(ax.Children,'LineWidth',2);


