%% Linear optics 
% Many optical applications work at a scale where the image formation process 
% is very linear.  Understanding linearity is important for understanding such 
% conventional imaging systems.  The principles show up in many places and guide 
% how we think about many optics principles. 
% 
% This script explores general linearity of image formation.  To make the calculations 
% a bit more interesting, we consider a simple camera that does not even have 
% a lens.  There is a sensor whose aperture is covered by some scratchy glass.  
% Here is a picture of the rig.  
% 
% 
% 
% 
% 
% 
% 
% For the stimulus, we first consider a linear array of LEDs light sources.  
% Each LED is a small point source.  It emits light in many directions, passing 
% through the scratchy glass and ultimately forming a reasonably meaningless image 
% at the sensor.  We can control the intensity of the LEDs separately.
% 
% *The question is this:*  What can we learn from the sensor response about 
% the intensity of the different point sources?  Even with this 'lensless' system.
% The lights and the sensor

% Let's start with just 10 LEDs in a line.
% We initalize their intensity randomly, between 0 and 1.
ledIntensities = rand(10,1);
nPnts = numel(ledIntensities);

% Here is an image of the LEDs
ieFigure;
imagesc(ledIntensities); 
colormap("gray"); axis image; axis off;
% The sensor image for each LED
% The image on the sensor will be a noisy mess, nothing recognizable.  The expected 
% sensor response will pretty much be random noise, reflecting the scratches and 
% absence of any focus.  The image from each of the different LEDs will also be 
% different because they are coming from a different position in space.
% 
% We call the image from each of the LEDs their Point Spread Function (PSF).  
% There is a different PSF for each position.  We specify the PSF assuming we 
% have an LED of 'unit' intensity.  

% Suppose the sensor has 64 rows and 64 columns
row = 64; col = 64;
PSF = zeros(row,col,nPnts);
for ii=1:nPnts
    PSF(:,:,ii) = rand(row,col,1);
end

ieFigure;
tiledlayout(2,2);
% Here is a sample of some of the PSFs.  
for ii = randi(nPnts,[1,4])
    nexttile;
    imagesc(squeeze(PSF(:,:,ii))); 
    colormap("gray"); axis image; axis off;    
end
% The whole image
% Here are two important facts.  
%% 
% * If we scale the intensity of an LED, the image is just a scaled version 
% of its PSF. 
% * The image formed by turning on two LEDs is equal to the sum of the images 
% when we turn each one separately.  
%% 
% Thus, we can calculate the expected image by adding up the individual PSFs, 
% weighted by the led intensities.  It is convenient to calculate this sum using 
% a matrix.  We 'vectorize' the PSFs, placing each PSF in the column of a matrix.

% Vectorizing the PSFs
vPSF = reshape(PSF,row*col,nPnts);

% Then we multiply each column by the intensity of its LED.
sensor = vPSF*ledIntensities(:);

% Here is what the image looks like.  (We have to reshape to see it as an
% image)
ieFigure;
imagesc(reshape(sensor,row,col)); 
colormap("gray"); axis off; axis image;
% Estimate the input image from the output image.  
% The equation for the sensor image is linear.  We vectorize the PSFs, placing 
% them in the columns.  We multiply the columns by the led intensities.
% 
% $$sensor = vPSF * ledIntensities$$
% 
% To estimate the led intensities from the sensor response, we only need to 
% invert the equation.  The estimated LED intensities are returned this way.

% This is Matlab's way of solving the linear equation.  It is equivalent to
% a pseudoinverse, which would like like this:
%
%      estLED = inv(vO'*vO)*(vO') sensor
%
ieFigure;
tiledlayout(1,2);
nexttile
imagesc(ledIntensities); 
colormap(gray); axis image; axis off; subtitle('Input')

nexttile
estLEDintensities = vPSF\sensor;
imagesc(estLEDintensities); 
colormap(gray); axis image; axis off; subtitle('Estimated')
% How did we do?
% We can plot the estimated LED intensities and the true intensities

ieNewGraphWin;
plot(ledIntensities(:),estLEDintensities(:),'o');
xlabel('True intensities');
ylabel('Estimated intensities')
grid on; axis equal; identityLine;
%% 
% 
% Let's scale it up
% Suppose we have more LEDs so we can make a pattern.  Say 256.  Would the method 
% still work?  Let's create a pattern of LEDs that form an image of an X.  We 
% will make each of the intensities in the lines a little random, just to keep 
% life interesting.

% The spatial array of the LEDs
row = 16; col = 16;
ledIntensities = zeros(row,col);
nPnts = numel(ledIntensities);

% Make an X with random intensities
for ii=1:row, ledIntensities(ii,ii) = rand(1); end
for ii=1:row, ledIntensities((row+1)-ii,ii)= rand(1); end
imagesc(ledIntensities); colormap("gray"); axis off; axis image;
%% We have more points, so we need more PSFs.  
% The recovery works best (surprisingly?) when the PSFs are random vectors.  
% If you make them more correlated, say by using this code snippet instead,
%%
% 
%       thisGaussian = fspecial("gaussian",[row,col],spread(ii));
%       img(:) = 0;
%       img(ii) = 1;
%       PSF(:,:,ii) = conv2(img,thisGaussian,'same');
%
%% 
% the sensitivity to noise and recovery becomes worse.

% Create some example PSFs
PSF = zeros(row,col,nPnts);
img = zeros(row,col);

spread = randi(row/8,[row,col]);
for ii=1:nPnts
    PSF(:,:,ii) = rand(row,col,1);  
end

% Here are a few of the PSFs.  Random, again.
for ii=1:(row+2):nPnts
    imagesc(PSF(:,:,ii)); 
    colormap("gray"); axis image; axis off;
    pause(0.1);
end
% Form the image 
% The image looks like complete noise, of course.

vPSF = reshape(PSF,row*col,nPnts);

% Then we multiply each column by the intensity of its LED.  We have to
% vectorize the LED intensities.
sensor = vPSF*ledIntensities(:);
%% 
% A good place to experiment with added noise.  You will see that a small amount 
% of noise (1 percent) has a big effect when the calculation is done this way.
%%
% 
%   noiseLevel = 0.001;
%   sensor = sensor + max(sensor(:))*noiseLevel*randn(size(sensor));
%   fprintf('Adding sensor noise at level %.3f\n',noiseLevel);
%

% The sensor image.
imagesc(reshape(sensor,row,col)); 
colormap("gray"); axis off; axis image;
%% The LED estimate
% We can still estimate the original - though this is not a great way to do 
% the inverse estimate.  There are better ones.

estLEDintensities = vPSF\sensor;

ieFigure;
tiledlayout(1,2);
nexttile;
imagesc(ledIntensities); colormap(gray); axis image; axis off; subtitle('Input')
nexttile;
imagesc(reshape(estLEDintensities,row,col)); colormap(gray); axis image; axis off;subtitle('Estimated')
% How did we do?
% A scatter plot of the estimated LED intensities and the true intensities falls 
% along the identity line.  That's good!  

ieNewGraphWin;
plot(ledIntensities(:),estLEDintensities(:),'o');
xlabel('True intensities');
ylabel('Estimated intensities')
grid on; axis equal; identityLine;
%% 
% Even though the image at the sensor looks like noise, we can recover the original 
% image from it.  We just need to now each of the point spread functions of the 
% LEDS.
% 
% To see how this approach breaks, try adding some noise to the image.
% 
% 
% 
%