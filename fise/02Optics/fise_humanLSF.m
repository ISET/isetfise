%% fise_humanLSF
% Illustrate the human line spread function at different wavelengths. The purpose 
% is to show the very large longitudinal chromatic aberration of the human eye, 
% and to illustrate the linespread.
% 
% This script requires ISETBio on your path so that we can access the human 
% Lens object.
% 
% We use the wavefront human optics model from Larry Thibos' average subject.  
% 
% See also:
% 
% s_humanLSF, t_humanLineSpreadOI
%% Initialize ISETCam/ISETBio

ieInit;
xticks = -50:25:50;
yticks = xticks;
names   = {'EE','425 nm','525 nm','625 nm'};

%% Create a broadband line

imSize = 512;
scene{1} = sceneCreate('lineee',imSize);  % Equal energy SPD for a thin line
scene{1} = sceneSet(scene{1},'fov',0.5);  % Small field of view
% sceneWindow;
%% Make scenes for several different wavelengths

scene{2} = sceneInterpolateW(scene{1},425);
scene{3} = sceneInterpolateW(scene{1},525);
scene{4} = sceneInterpolateW(scene{1},625);
%% Run the optical calculation for each of the lines

rgb     = cell(4,1);
support = cell(4,1);
lPlot   = cell(4,1);

for ii=1:4
    oi = oiCreate('human');
    oi = oiCompute(oi,scene{ii});
    oi = oiSet(oi,'name',names{ii});
    rgb{ii} = oiGet(oi,'rgb');  % Store the image
    support{ii} = oiGet(oi,'spatial support linear','um');
    lPlot{ii} = oiPlot(oi,'illuminance hline',[1 320],'nofigure');
end

%% Show the linespreads in a single figure

figHandle = ieFigure; %#ok<NASGU>
tiledlayout(2,2);

for ii=1:4
    nexttile;
    imagesc(gca,support{ii}.x,support{ii}.y,rgb{ii});
    grid on; axis xy;
    set(gca,'GridColor',[1 1 1],'GridLineWidth',1.2);
    set(gca,'xtick',xticks,'ytick',yticks);
    xlabel('um'); ylabel('um'); hold on;
    data = interp1(lPlot{ii}.pos,lPlot{ii}.data,support{ii}.x);
    plot(gca,support{ii}.x,50*data/max(data(:)),'w--'); hold on;
    subtitle(names{ii})
end

%{
% Export the figure to a PNG file
drawnow; % Ensure the figure is rendered before exporting
filename = fullfile(fiseBookPath,'chapters','images','optics','linespread.png');
exportgraphics(figHandle, filename, 'Resolution', 300);
%}
%%
imSize = 512;
scene{1} = sceneCreate('point array',imSize,256);
scene{1} = sceneSet(scene{1},'fov',0.5);  % Small field of view
% sceneWindow(scene{1});
%% Make scenes for several different wavelengths

scene{2} = sceneInterpolateW(scene{1},425);
scene{3} = sceneInterpolateW(scene{1},525);
scene{4} = sceneInterpolateW(scene{1},625);
%% Run the optical calculation for each of the lines

rgb     = cell(4,1);
support = cell(4,1);
lPlot   = cell(4,1);
names   = {'EE','425','525','625'};

for ii=1:4
    oi = oiCreate('human');
    oi = oiCompute(oi,scene{ii});
    oi = oiSet(oi,'name',names{ii});
    rgb{ii} = oiGet(oi,'rgb');  % Store the image
    support{ii} = oiGet(oi,'spatial support linear','um');
end

%% Show the point spreads in a single figure

figHandle = ieFigure;
tiledlayout(2,2);

for ii=1:4
    nexttile;
    imagesc(gca,support{ii}.x,support{ii}.y,rgb{ii});
    grid on; axis xy;
    set(gca,'GridColor',[1 1 1],'GridLineWidth',1.2);
    set(gca,'xtick',xticks,'ytick',yticks);
    xlabel('um'); ylabel('um'); hold on;
    subtitle(names{ii})
end

%{
% Export the figure to a PNG file
drawnow; % Ensure the figure is rendered before exporting
filename = fullfile(fiseBookPath,'chapters','images','optics','pointspread.png');
exportgraphics(figHandle, filename, 'Resolution', 300);
%}
%% 
%