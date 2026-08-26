% This script is for sensor noise model evaluation. 
% 
% Check this script out when you analyzed the captured images for noise
% analysis. The script shows how to set parameter values accordingly.
%
% Parameters to add to the sensor model are:
%   (1) Dark current rate
%   (2) DSNU
%   (3) PRNU
%   (4) Read noise
% 
% Reminder:
%   
%% Init
ieInit;

%% Start with creating an uniform scene
scene = sceneCreate('uniform ee');

% Adjust the illuminant of the scene with our lamp SPD
lightName = 'D65.mat';
sceneBright = sceneAdjustIlluminant(scene, lightName);

% Adjust the luminance of the scene for dark scene
sceneDark = sceneAdjustLuminance(scene, 0); % Use a very dark 

%% Create an optical image object.
% Assuming diffraction limite optics with cos4th off axis method.

oi = oiCreate;
oi = oiSet(oi, 'optics off axis method', 'cos4th');

% Calculate oi 
oi = oiCompute(sceneBright, oi);

%% Use sensorIMX363 for creating sensor base model
% 
sensor = sensorCreate('IMX363');

%% Set Dark current
% Check current darck current rate
curDCR = sensorGet(sensor, 'pixel dark voltage');

darkCurRate = 0; % In volts
sensor = sensorSet(sensor, 'pixel dark voltage', darkCurRate);

%% Set DSNU
curDSNU = sensorGet(sensor, 'dsnu level');

DSNU = 0; % Standard deviation in volts
sensor = sensorSet(sensor, 'dsnu level', DSNU);

%% Set PRNU
curPRNU = sensorGet(sensor, 'prnu level');

PRNU = 0; % Standard deviation in percent
sensor = sensorSet(sensor, 'prnu level', PRNU); 

%% Set read noise
curRN = sensorGet(sensor, 'pixel read noise volts');

readNoise = 0;
sensor = sensorSet(sensor, 'pixel read noise volts', readNoise); % In volts

%%
% Calculate sensor data
sensor = sensorCompute(sensor, oi);