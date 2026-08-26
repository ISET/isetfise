% "Sunglass" test harness
% loosely based off a 2021 project to model EnChroma glasses


clear
close all
ieInit;
wavelength = 400:10:700;

% Create a scene from RGBs
% To evaluate performance with certain colors, we should
% create a "test chart" of those colors
% maybe sceneReflectanceChart using all of our patches?

%% The basic method for creating a scene and computing the OI

% Just like ISETCam.  Create a scene that is about 4 deg.
scene = sceneCreate('macbeth d65');
scene = sceneSet(scene,'fov',2);

%%
oi = oiCreate('wvf human');
oi = oiCompute(oi,scene);
oiWindow(oi);

%%  Now, create a cone mosaic

thisMosaic = coneMosaic;
thisMosaic.setSizeToFOV(2);

thisMosaic.compute(oi);
thisMosaic.window;

%% Extra

%{
% See t_cMosaicBasic.mlx for a tutorial on the fancier kind of cone mosaics

cm = cMosaic(...
    'sizeDegs', [4 4], ...         % SIZE: 1.0 degs (x) 0.5 degs (y)
    'positionDegs', [0 0], ... % ECC: (0,0)
    'eccVaryingConeBlur', true ...
    );
cm.visualize();
cm.compute(oi);
%}
%% Code illustrating how to apply a color filter to the image

% This is a better way to create the MCC image
%{
 scene = sceneCreate('macbeth d65');
 scene = sceneSet(scene,'fov',2);
%}

%%
fname = 'macbeth.tif';
scene = sceneFromFile(fname, 'rgb', 100, 'CRT-Dell.mat');
sceneWindow(scene);

imgXYZ   = sceneGet(scene,'xyz');
whiteXYZ = sceneGet(scene,'illuminant xyz');
vcNewGraphWin;

% preview the scene the way the human eye might see it
% by rendering it through LMS cone responses
% 
for cbType = 1:3
    lms =  xyz2lms(imgXYZ, cbType, 'Brettel', whiteXYZ);
    cbXYZ = imageLinearTransform(lms, colorTransformMatrix('lms2xyz'));
    subplot(3,1,cbType), imagesc(xyz2srgb(cbXYZ)); 
    axis image; 
    axis off
end
theOI = oiCreate('wvf human');
theOI = oiCompute(theOI, scene);

% visualize the resulting optical image
oiWindow(theOI);

%% EnChroma transmittance
%To be replaced by our filter of choice!
load('EnchromaInput','EnchromaInput');
load('EnchromaThroughLens','EnchromGrabThroughLens');
enchromIn = interp1(EnchromaInput(:,1), EnchromaInput(:,2),wavelength);
ieNewGraphWin;
plot(EnchromaInput(:,1),EnchromaInput(:,2));
enchromOut = interp1(EnchromGrabThroughLens(:,1), EnchromGrabThroughLens(:,2),wavelength);
ieNewGraphWin;
plot(EnchromGrabThroughLens(:,1),EnchromGrabThroughLens(:,2));
%Plot the transmittance
transmittance = enchromOut./enchromIn;
transmittance = min(transmittance,1);
transmittance = max(transmittance,0);
ieNewGraphWin;
plot(wavelength,transmittance,'-o');
grid on;
xlabel('Wave (nm)');
ylabel('Transmittance');

%% Retina image with EnChroma glasses
Photons = oiGet(theOI,'photons');
[Photons, row, col] = RGB2XWFormat(Photons);
Photons = Photons*diag(transmittance);
Photons = XW2RGBFormat(Photons, row, col);
oi = oiSet(theOI,'photons',Photons);
imgXYZ_EnChroma = oiGet(oi,'xyz');
vcAddAndSelectObject(oi); 
oiWindow;
vcNewGraphWin;
for cbType = 1:3
    lms =  xyz2lms(imgXYZ_EnChroma, cbType, 'Brettel', whiteXYZ);
    cbXYZ = imageLinearTransform(lms, colorTransformMatrix('lms2xyz'));
    subplot(3,1,cbType), imagesc(xyz2srgb(cbXYZ)); 
    axis image; 
    axis off
end

%% So we now have a visual window into what our colors look like
% What we haven't done is...
% Any math to evaluate potential filters based on a set of criteria
% for discernability and distraction (etc.)

% A "trivial" example would be finding a filter that minimized the contrast
% between the blue lines and blue court while not making it too hard to see
% other important features (green court vs. blue court might be one, but
% that might be okay to sacrifice since they are separated by a white line.
% But certainly the white lines need to say high contrast.

