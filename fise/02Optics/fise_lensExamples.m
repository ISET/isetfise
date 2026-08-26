%% Lens ray tracing illustrated
%
%  Create a point source
%  Read in a lens file
%  Create a film
%  Visualize Ray trace the point through the lens to the film
%  Create an optical image of the ray trace
%
%  Requires isetlens toolbox
%

%%
ieInit

%% Make a set  of points far away

% position - relative to center of final lens surface
%   Image is formed on the positive side
%   Objects are on the negative side
%   distances are 'mm' 

% clear point
% 
% % A little bit off axis.  Far away. Units are mm, I think.
% pZ_far = -1e4;
% pX = 30;
% pY = 30;
% point{1} = [-pX -pY  pZ_far];   % Top right is -,-  
% point{2} = [ pX,-pY, pZ_far]/2; % Top left is +, - 
% point{3} = [ pX, pY, pZ_far]/4; % Bottom left is +,+ 
% point{4} = [-pX  pY, pZ_far]/6; % Bottom right -,+

% point = psCreate(pX,pY,pZ);

%% Read a lens file and create a lens

lenses = lensC.list;
% lensFileName = lenses(33).name;  % Tessar, short focal length for plottings
% lensFileName = lenses(23).name;  % Petzval, short focal length for plottings
% lensFileName = lenses(25).name;  % Petzval, longer focal length for plottings
lensFileName = lenses(8).name;  % Double Gauss, 
% lensFileName = lenses(15).name;  % Fish eye

% Small number of samples
nSamples = 501;   % Number of ray samples that we trace

% We select the size of the middle aperture radius. 
thisLens = lensC('fileName', lensFileName, 'aperture sample',[nSamples,nSamples]);
thisLens.scale(5);

diameter = 8;   % mm
thisLens.set('Middle aperture diameter',diameter);

% This is the sketch of all the lens elements. Notice that the back of the
% lens is at 0 and the object space is negative and the sensor plane is
% positive.
thisLens.draw; title(''); grid on;

%{
% Bug in 2024b
fname = fullfile(fiseRootPath,'chapters','images','optics','09-morelens','double-gauss.svg');
exportgraphics(gcf,fname,'ContentType','vector');
%}

%% Create a film (sensor)

% wavelength samples
wave = thisLens.get('wave');

% In focus for dgauss.50mm is about 38.5 mm
% A film size of 5 mm seems OK for this demo.
fSize = [1 1];
fRes =  [300 300];
film = filmC('position', [0 0 54], ...  
    'size', fSize, ...
    'resolution',fRes,...
    'wave', wave);

%% Ray trace the points to the film

% Create a point spread function camera
infinite_point{1} = [0 0 -1e5];
camera = psfCameraC('lens',thisLens,'film',film,'pointsource',infinite_point);

% Find the focus distance
fDistance = camera.autofocus(550,'nm');

% set the film at focus
camera.set('film position',[0 0 fDistance]);

%camera.set('pointsource', point);
% camera.rays=point

%% Estimate the PSF and show the ray trace
nLines = 100;  % Do not draw the rays
jitter = true;
camera.estimatePSF('n lines',nLines, 'jitter flag',jitter);
set(gca,'xlim',[-50 40],'ylim',[-15 15])

%% Show the point spread in the optical image window
oi = camera.oiCreate;
oi = oiCrop(oi,[125 125 50 50]);
% oiWindow(oi);

rgb = oiGet(oi,'rgb');
ieFigure;
% oiPlot(oi,'irradiance image with grid')
oiPlot(oi,'irradiance image wave',[], 550, 15);
% oiSet(oi,'gamma',0.7);

%% Now the Tessar example

lensFileName = lenses(34).name;  % 
nSamples = 501;   % Number of ray samples that we trace

% We select the size of the middle aperture radius. 
thisLens = lensC('fileName', lensFileName, 'aperture sample',[nSamples,nSamples]);
thisLens.scale(5);

% diameter = 8;   % mm
% thisLens.set('Middle aperture diameter',diameter);

% This is the sketch of all the lens elements. Notice that the back of the
% lens is at 0 and the object space is negative and the sensor plane is
% positive.
thisLens.draw; title(''); grid on;

%{
% Bug in 2024b
fname = fullfile(fiseRootPath,'chapters','images','optics','09-morelens','tessar.svg');
exportgraphics(gcf,fname,'ContentType','vector');
%}

%%
% wavelength samples
wave = thisLens.get('wave');

% In focus for dgauss.50mm is about 38.5 mm
% A film size of 5 mm seems OK for this demo.
fSize = [1 1];
fRes =  [300 300];
film = filmC('position', [0 0 54], ...  
    'size', fSize, ...
    'resolution',fRes,...
    'wave', wave);

%% Ray trace the points to the film

% Create a point spread function camera
infinite_point{1} = [0 0 -1e5];
camera = psfCameraC('lens',thisLens,'film',film,'pointsource',infinite_point);

% Find the focus distance
fDistance = camera.autofocus(550,'nm');

% set the film at focus
camera.set('film position',[0 0 fDistance]);

%%
nLines = 100;  % Do not draw the rays
jitter = true;
camera.estimatePSF('n lines',nLines, 'jitter flag',jitter);
set(gca,'xlim',[-20 15],'ylim',[-5 5])


%% Fisheye
%
lensFileName = lenses(18).name;  % 

nSamples = 501;   % Number of ray samples that we trace

% We select the size of the middle aperture radius. 
thisLens = lensC('fileName', lensFileName, 'aperture sample',[nSamples,nSamples]);
thisLens.scale(5);

% diameter = 8;   % mm
% thisLens.set('Middle aperture diameter',diameter);

% This is the sketch of all the lens elements. Notice that the back of the
% lens is at 0 and the object space is negative and the sensor plane is
% positive.
thisLens.draw; title(''); grid on;

% {
% Bug in 2024b
fname = fullfile(fiseRootPath,'chapters','images','optics','09-morelens','fisheye.svg');
exportgraphics(gcf,fname,'ContentType','vector');
%}

%%
% wavelength samples
wave = thisLens.get('wave');

% In focus for dgauss.50mm is about 38.5 mm
% A film size of 5 mm seems OK for this demo.
fSize = [1 1];
fRes =  [300 300];
film = filmC('position', [0 0 54], ...  
    'size', fSize, ...
    'resolution',fRes,...
    'wave', wave);

%% Ray trace the points to the film

% Create a point spread function camera
infinite_point{1} = [0 0 -1e5];
camera = psfCameraC('lens',thisLens,'film',film,'pointsource',infinite_point);

% Find the focus distance
fDistance = camera.autofocus(550,'nm');

% set the film at focus
camera.set('film position',[0 0 fDistance]);

%%
nLines = 100;  % Do not draw the rays
jitter = true;
camera.estimatePSF('n lines',nLines, 'jitter flag',jitter);
% set(gca,'xlim',[-100 50],'ylim',[-15 30])
%}

%% Petzval - isetlens doesn't match wikipedia well
%{
lensFileName = lenses(26).name;  % 

nSamples = 501;   % Number of ray samples that we trace

% We select the size of the middle aperture radius. 
thisLens = lensC('fileName', lensFileName, 'aperture sample',[nSamples,nSamples]);
thisLens.scale(5);

% diameter = 8;   % mm
% thisLens.set('Middle aperture diameter',diameter);

% This is the sketch of all the lens elements. Notice that the back of the
% lens is at 0 and the object space is negative and the sensor plane is
% positive.
thisLens.draw; title(''); grid on;

%{
% Bug in 2024b
fname = fullfile(fiseRootPath,'chapters','images','optics','09-morelens','petzval.svg');
exportgraphics(gcf,fname,'ContentType','vector');
%}

%%
% wavelength samples
wave = thisLens.get('wave');

% In focus for dgauss.50mm is about 38.5 mm
% A film size of 5 mm seems OK for this demo.
fSize = [1 1];
fRes =  [300 300];
film = filmC('position', [0 0 54], ...  
    'size', fSize, ...
    'resolution',fRes,...
    'wave', wave);

%% Ray trace the points to the film

% Create a point spread function camera
infinite_point{1} = [0 0 -1e5];
camera = psfCameraC('lens',thisLens,'film',film,'pointsource',infinite_point);

% Find the focus distance
fDistance = camera.autofocus(550,'nm');

% set the film at focus
camera.set('film position',[0 0 fDistance]);

%%
nLines = 100;  % Do not draw the rays
jitter = true;
camera.estimatePSF('n lines',nLines, 'jitter flag',jitter);
set(gca,'xlim',[-50 15],'ylim',[-15 15])
%}
%% END