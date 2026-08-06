%% Sensor fundamentals
% We learn a great deal about image quality and noise limits by counting the 
% (*Poisson*) arrival of photons at each pixel and measuring the responses to 
% gratings. Because ISET uses physical units throughout, we can  calculate the 
% number of incident photons, or stored electrons, at each pixel in the sensor.  
% We can then look more broadly across the optics-sensor and ask how well the 
% sensor encodes images at different spatial frequencies (MTF).
% 
% In this script, we 
%% 
% * Show the Poisson distribution and its noise characteristics
% * Explore how pixel size impacts the sensor resolution. 
% * Create an MTF graph to analyze the resolution
%% 
% *See also:* 
% 
% s_sensorSNR, s_sensorStackedPixels
%% Standard initialization

ieInit;
%% Measure the variation in sensor electrons (shot noise)
% We start with a low intensity uniform scene with equal energy at every wavelength.  
% 10 $cd/m^2$ is pretty dark.  But you can experiment by changing the the number 
% of candelas below and rerunning this section.

uscene  = sceneCreate('uniform equal energy');
candelas = 10;                         % Units are cd/m^2
uscene  = sceneAdjustLuminance(uscene,candelas);
uscene  = sceneSet(uscene,'fov',10); % The scene extends a 10 degree field of view
%
uscene = sceneAdjustIlluminant(uscene,'D65.mat') 
% sceneWindow(uscene);
%% 
% Calculate the optical image for a diffraction limited optics. This represents 
% the irradiance that arrives at the sensor after passing through the optics.

oi = oiCreate('diffraction limited');
oi = oiSet(oi,'optics off axis method','skip');   % We won't add any vignetting to the optics
oi = oiCompute(oi,uscene); % Pass the scene through the optics

% oiWindow(oi);
% A monochrome sensor with a field of view that is smaller than the scene

msensor = sensorCreate('monochrome');
msensor = sensorSetSizeToFOV(msensor,5,oi);

% Set the exposure duration to be short (1ms). You can experiment with this
% if you'd like.
msensor = sensorSet(msensor,'exp time',0.01);    % Units are in seconds

% Set the sensor to have no noise, quantization, or clipping
msensor = sensorSet(msensor,'noise flag',-1);  % No noise or quantization
msensor = sensorCompute(msensor,oi);

% Add photon noise.  Normally this happens within sensorCompute, but we are
% explicitly controlling it here in this tutorial.
msensor = sensorSet(msensor,'noise flag',1);   % Add only photon noise
msensor = sensorAddNoise(msensor);
% sensorWindow(msensor);
% A histogram of the electron count across the pixels.  
% Given that the scene is uniform, and how we have controlled the noise, this 
% produces the shot noise distribution (variation in electrons due to photon noise)

e = sensorGet(msensor,'electrons');
r = range(e(:));
nBins = min(r,50);  % Makes a nice plot

ieNewGraphWin;
h = histogram(e(:),nBins); % try "hist" for older versions of MATLAB
xlabel('Number of electrons');
ylabel('Number of pixels');
mn = double(mean(e(:)));
txt = sprintf('Mean %.1f\nVar %.1f',mn,var(e(:)));
text(mn,max(h.Values)/3,0,txt,'HorizontalAlignment','center','FontSize',20,'Color',[1 1 1])
%% Experiments with spatial resolution
% We consider the effect of pixel size on the sensor MTF in the following sections.  
% Let's start fresh.

ieInit
%% List of parameters
% The slanted bar scene is often used to assess spatial resolution.  We can 
% compute the modulation transfer function (MTF) from the sensor and image processing 
% response to the slanted bar.

dyeSizeMicrons = 512;            % Microns
clear psSize;                    % Pixel size (width)
pSize = [2 3 5 8];               % Different pixel sizes in microns

sceneBar = sceneCreate('slanted bar', 512);

% Let's set a few scene parameters.
sceneBar = sceneAdjustLuminance(sceneBar,10);    % Candelas/m2
sceneBar = sceneSet(sceneBar,'distance',1);      % Distance of the scene in meters
sceneBar = sceneSet(sceneBar,'fov',5);           % Field of view in degrees
% sceneWindow(sceneBar);
%% Create an optical image with some default optics.
% Now, compute the optical image from this scene and the current optical image 
% properties

oi = oiCreate('diffraction limited');
fNumber = 12;
oi = oiSet(oi,'optics fnumber',fNumber);

oi = oiCompute(oi,sceneBar);
oiWindow(oi);
%% Create a monochrome image sensor array

sensor = sensorCreate('monochrome');                %Initialize
sensor = sensorSet(sensor,'autoExposure',1); % Set to auto exposure
ip = ipCreate;
%% Compute the MTF as we change the pixel size
% We are now ready to set sensor and pixel parameters to produce a variety of 
% captured images.  Set the image processing properties for the monochrome imager. 
% The default image processor does not sensor convert or illuminant balance, so 
% it is appropriate.

% Loop over different pixel sizes
mtfData = cell(1,length(pSize));
for ii=1:length(pSize)
    
    % Adjust the pixel size (meters) on the sensor
    sensor = sensorSet(sensor,'pixel size constant fill factor',[pSize(ii) pSize(ii)]*1e-6);
    
    %Adjust the sensor row and column size so that the sensor has a constant
    %field of view.
    sensor = sensorSetSizeToFOV(sensor,5,oi);
    sensor = sensorCompute(sensor,oi);
    ip = ipCompute(ip,sensor); % Image processing pipeline
    
    mtfData{ii} = ieISO12233(ip,sensor,'none');    
end
%% Plot all the mtfData 
% We compute the _mtfData_ cell array contains all the information plotted in 
% this figure.  We graph the results, comparing the different pixel size MTFs.

ieNewGraphWin;
c = {'r','g','b','c','m','y','k'};
for ii=1:length(mtfData)
    h = plot(mtfData{ii}.freq,mtfData{ii}.mtf,['-',c{ii}],'LineWidth',2);
    hold on
    newText = sprintf('%.0f um\n',pSize(ii));   
    nfreq = mtfData{ii}.nyquistf;
    l = line([nfreq ,nfreq],[0.1,0],'color',c{ii});
    l.LineWidth = 2;
    text((nfreq-10),0.12,newText,'color',c{ii});
end

xlabel('lines/mm'); ylabel('Relative amplitude');
title('MTF for different pixel sizes');
hold off; grid on
%% Show a visual example of the effect of pixel size
% We find it useful to look at images to understand what the changes in MTF 
% means. Furthermore, using the whole calculation lets you notice other perceptual 
% effects that are not obvious from one type of engineering metric.  In this case, 
% the color artifacts may seem surprising.

sceneFO = sceneCreate('freq orient',512);
fov   = sceneGet(sceneFO,'fov');
oi    = oiCreate('diffraction limited');
oi    = oiCompute(oi,sceneFO);
ip    = ipCreate;

% Let's try it with an RGB sensor this time.
sensor = sensorCreate;

for ii=1:length(pSize)
    
    % Adjust the pixel size (meters)
    sensor = sensorSet(sensor,'pixel size constant fill factor',[pSize(ii) pSize(ii)]*1e-6);
    sensor = sensorSetSizeToFOV(sensor,fov,oi);
    sensor = sensorCompute(sensor,oi);
    sensorWindow(sensor);
    ip = ipCompute(ip,sensor);
    ip = ipSet(ip,'name',sprintf('pSize %.2f',pSize(ii)));
    ipWindow(ip);
end
%% The IP window
% We suggest you bring the sensorWindow to the front and look at the visual 
% representation as you choose different pixel sizes; select different pixel sizes 
% by using the menu at the top of the window (either the drop down or the arrows).  
% You will see that when the pixels undersample the original image (i.e., when 
% the pixels are big) the errors that appear in the simple rendering are color 
% artifacts.  
% 
% You might think a bit about why undersampling with big pixels, and then interpolating 
% the data into the final processed, leads to these large color artifacts.
% 
% 
% 
%