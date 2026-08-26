%%  Using ISETCam
%
% This script is a VERY brief introduction to ISETCam.
%
% The most important part of this script is teaching you how to search
% for functions and explanations about using ISETCam.  The script
% contains some basic examples, but MANY many more examples can be
% found in the tutorials and scripts.
%
% Wandell, October 1, 2018
%
% See also
%  Any of the tutorials t_<> or scripts s_<>
%

%% Initialize ISET variables and structures
%%
% ISETCam helps you compute basic quantities related to imaging.  The vast
% majority of the ISETCam code consists of functions that compute different
% quantities. A second important part of ISETCam are the methods for
% visualizing the computations and parameters.  The visualization code is
% also very helpful when you are trying to debug your own functions and
% scripts.
%

% To help you manage your calculations, ISETCam mains a global structure
% that stores different types of (scenes, optical images) data and makes it
% easy to render the data in the ISETCam windows.
%
% The ieInit function sets up the global structure, closes windows and can
% clear your variables. The exact behavior of ieInit depends on how you set
% your ISET preferences. 

% Here is how your preferences are set
getpref('ISET')   % Current status

% To clear workspace variables on ieInit, do this
setpref('ISET','initclear',true);    

% To preserve workspace variables on ieInit, do this
setpref('ISET','initclear',false);   

ieInit;

%% Using ISETCam to visualize defocus of diffraction limited optics
%%
% Create a scene comprising a multispectral line, with equal photons
scene = sceneCreate('line ep',128);    % A thin line, equal photon radiance at each wavelength
scene = sceneSet(scene,'fov', 0.5);    % Small field of view (deg)
sceneWindow(scene);                    % Save it in the database and show

% Plot the scene data
scenePlot(scene,'radiance hline',[64 64]);
set(gca,'xlim',[-1 1]);  % Plot radiance at central 1 mm

% Type doc scenePlot to see other plotting options
%% Simulate the line passing through diffraction-limited optics
%%
oi = oiCreate;               % Default optics is diffraction limited
oi = oiCompute(oi,scene);
oiWindow(oi);

% Plot the line spread as a function of wavelength
oiPlot(oi,'irradiance hline',[80 80]);
set(gca,'xlim',[-10 10]);  % Plot radiance at central 10 um
%% Now change the f-number of the optics and do it again
%%
oi = oiSet(oi,'optics fnumber',12);
oi = oiCompute(oi,scene);
oiWindow(oi);

oiPlot(oi,'irradiance hline',[80 80]);
set(gca,'xlim',[-10 10]);  % Plot radiance at central 1 mm

%%