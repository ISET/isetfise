%% Point spread function (PSF) activation on the human cone mosaic
%
% This script simulates how point sources of light create activation
% patterns on the human cone photoreceptor mosaic, demonstrating both
% spatial and chromatic effects of the eye's optical system.
%
% Description:
%   Creates visualizations of point spread function (PSF) responses on the
%   cone mosaic under different conditions. The script has two main
%   sections:
%
%   1. Field Height Variation: Computes PSF activation patterns at
%      different retinal eccentricities (0, 3, 6, and 12 degrees) using
%      wavefront data from Polans2015 to show how optical quality varies
%      across the visual field.
%
%   2. Chromatic Aberration: Demonstrates wavelength-dependent PSF changes
%      at a fixed eccentricity (3 degrees) by computing activation patterns
%      for monochromatic point sources at different wavelengths (550nm and
%      450nm), illustrating the eye's chromatic aberration.
%
% Outputs:
%   - SVG files showing cone activation maps for different eccentricities
%   - SVG files showing cone activation maps for different wavelengths
%   - All output files saved to: 
%     fiseRootPath/chapters/images/human/02-spatial-encoding/
%
% Dependencies:
%   - ISETBio toolbox
%   - fiseRootPath.m
%   - oiPosition function (for Polans2015 wavefront data)
%
% See also:
%   cMosaic, oiPosition, sceneCreate, oiCompute
%
% Copyright Imageval Consulting, LLC 2025 

%%
ieInit;
figsave = true;
activationMap = colormap('hot');
close(gcf);

%% PSF:  Field height section
%
% I have noticed that in the periphery the spot sometimes ends up on a
% S-cone and very little response is visible.  A panel-tabset flipping
% through the eccentricities is pretty compelling.

% I need to figure out how to load a wvf for different eccentricities.

scene = sceneCreate('point array',256,96);
scene = sceneSet(scene,'h fov',0.3);

% I need to figure out how to load a wvf for different eccentricities.
eccDegs = [12 0; 6 0; 3 0; 0 0];
for ii=1:size(eccDegs,1)
    [oi, psf, support, zCoeffs, subjID] = oiPosition('Polans2015','position',eccDegs(ii,:));
    oi = oiCompute(oi,scene,'crop',false);
    % oiWindow(oi);

    cm = cMosaic('eccentricityDegs',eccDegs(ii,:),'sizeDegs',[0.4 0.4]);

    allE = cm.compute(oi);
    cm.plot('excitations', allE, 'label cones',false,...
        'domain','degrees', ...
        'plot title','Activation map',...
        'cones line width',1, ...
        'activation color map',activationMap);

    % This should work some day.
    % exportgraphics(gcf, fname, 'ContentType', 'vector');
    fname = sprintf('conePSF-%d-deg.svg',eccDegs(ii,1));
    fname = fullfile(fiseRootPath,'chapters','images','human','02-spatial-encoding',fname);
    if figsave, print(gcf,fname,'-dsvg'); end
end

%% Chromatic aberration section
%

ieInit;

figsave = true;
activationMap = hot(256); close(gcf);

% Let's check just outside the fovea
eccDegs = [3 0];
hfov = 0.5;

%% sceneCreate('pointArray',sz,spacing,spectralType);
scene = sceneCreate('point array',256,96);
scene = sceneSet(scene,'h fov',hfov);
wave = sceneGet(scene,'wave');

% Make the scene monochromatic
monoWave = 550;
illEnergy = zeros(numel(wave),1);
illEnergy(wave==monoWave) = 1;
scene = sceneAdjustIlluminant(scene,illEnergy);
scene = sceneSet(scene,'mean luminance',100);
% sceneWindow(scene);

% Extract the oi for that wavelength
oi = oiPosition('Polans2015','position',eccDegs,'wave',monoWave);
oi = oiCompute(oi,scene,"crop",false);
% oiWindow(oi);

%% Default cone mosaic

cm = cMosaic('eccentricityDegs',eccDegs,'sizeDegs',[hfov hfov]*1.2);
allE = cm.compute(oi);
allE = ieClip(allE, 0,7000);

% Looking for another plotting method.  Asked NC.
cm.plot('excitations', allE, 'label cones',false,...
    'plot title','Activation map','cones line width',0.5, ...
    'activation color map',activationMap);

fname = fullfile(fiseRootPath,'chapters','images','human','02-spatial-encoding','conePSF-550.svg');

% This should work some day.
% exportgraphics(gcf, fname, 'ContentType', 'vector');
if figsave, print(gcf,fname,'-dsvg'); end

%% How about changing the point spectral power distribution?

scene = sceneCreate('point array',256,96);
scene = sceneSet(scene,'h fov',hfov);

wave = sceneGet(scene,'wave');
monoWave = 450;
illEnergy = zeros(numel(wave),1);
illEnergy(wave==monoWave) = 1;

scene = sceneAdjustIlluminant(scene,illEnergy);
scene = sceneSet(scene,'mean luminance',100);

% sceneWindow(scene);

oi = oiPosition('Polans2015','position',eccDegs,'wave',monoWave);
oi = oiCompute(oi,scene,"crop",true);
% oiWindow(oi);

%%
% cm = cMosaic;
allE = cm.compute(oi);
allE = ieClip(allE, 0,7000);

cm.plot('excitations', allE, 'label cones',false,...
    'plot title','Activation map','cones line width',0.5, ...
    'activation color map',activationMap);

fname = fullfile(fiseRootPath,'chapters','images','human','02-spatial-encoding','conePSF-480.svg');

% This should work some day.
% exportgraphics(gcf, fname, 'ContentType', 'vector');
if figsave, print(gcf,fname,'-dsvg'); end

%% END