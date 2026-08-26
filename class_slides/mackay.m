% These are nice patterns for illustrating radial aliasing 
%
% They are often used in measuring camera resolution.  Mackay patterns, I
% think they are called.  Also zone plate is related.
%
% Try for large radialValues.  I think you can also see some motion in the
% static image (for large radialValue).
% 
% Wandell, 2019

%% Example parameters

% radialValue = 32;
radialValue = 64;

% nSamples = -128:127;
% nSamples = -256:255;
nSamples = -512:511;

%% Build 

[x, y] = meshgrid(nSamples, nSamples);
% x(:,129) = eps*ones(256,1);
theta = cos(atan(y./x)*2*radialValue);
theta = ieScale(theta,0,1);

%% Show

ieNewGraphWin;
imshow(256*theta,gray(256)); 
truesize;

%% END