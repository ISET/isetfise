%% Calculate MTF for rectangular mosaic responses with eye movements
%
% This us a starter script that illustrates how to compute the cone mosaic
% response to a slanted bar target.
%
% The idea of the project is to use the ISETBio methods to control the eye
% movement patterns, the properties of the cone mosaic, and to calculate
% the effective MTF with different types of eye movements, cone sizes, and
% mixtures of cone types.
%
% Use the ieISO12233 method to calculate the MTF
%
% Wandell,20191110
%
% See also:  ieISO12233, emCreate
%

%%
ieInit

%%  The slanted bar scene
scene = sceneCreate('slanted edge');
sceneWindow(scene);

%%  A standard human eye ball
oi = oiCreate;
oi = oiCompute(oi,scene);
oiWindow(oi);

%% Rectangular mosaic - only one cone type

nEyeMovements = 50;
cones = coneMosaic;
cones.spatialDensity = [0,1,0,0];   % Only L cones
cones.integrationTime = 0.001;      % One ms integration time
cones.emGenSequence(nEyeMovements,'rSeed',[]); % Randomize eye movements

%% 
cones.compute(oi);

%% Not needed, but nice to see
% cones.window;

%%  Get the mean absorptions across time
absorptions = cones.absorptions;
edgeImage   = absorptions(:,:,1);

% ISO12233 requires cropping the image so that the dge is taller than wide
% This is a specific way to find the rect for the image
rect = ISOFindSlantedBar(edgeImage);
% ieNewGraphWin; imagesc(edgeImage); colormap(gray); axis image
% h = drawrectangle('Position',rect);

% Now the whole set of eye movements
edgeImage = mean(absorptions,3);
edgeImage = imcrop(edgeImage,rect);
% ieNewGraphWin; imagesc(edgeImage); axis image; colormap(gray);

%% Call the ISO routine
deltaX = cones.patternSampleSize(1)*1e3;
mtf = ISO12233(edgeImage,deltaX,[],'none');

%% Here is a plot only up to the Nyquist sampling frequency
ieNewGraphWin;
keep = mtf.freq < mtf.nyquistf;

mmPerDeg = 0.2852; 
cpd = mtf.freq*mmPerDeg;
% Approximate (assuming a small FOV and an focal length of 16.32 mm)
plot(cpd,mtf.mtf,'k-','Linewidth',2);
xlabel('Spatial Frequency (cycles/deg)');
ylabel('Contrast Reduction (SFR)');
grid on;
axis([0 60 0 1])


%%

%%



