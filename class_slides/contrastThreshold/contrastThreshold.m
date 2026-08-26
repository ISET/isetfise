% Demonstration of a brief psychophysical experiment using two-interval
% forced choice
%
% Wandell

%% Make the spatial pattern

% Spatial samples and frequency
nSamples = 255;
f = 6;

X = (0:(nSamples-1))/nSamples; 
s1 = sin(2*pi*f*X);
s1 = repmat(s1,nSamples,1);
g  = fspecial('gaussian',nSamples,ceil(nSamples/16)); 
g  = ieScale(g,1); 

s1 = s1.*g;
stim = zeros(size(s1,1),size(s1,2),3);
for ii=1:3
    stim(:,:,ii) = s1; 
end

%% Make a blank frame
blank = ones(nSamples,nSamples,3)*0.5;
MBlank = im2frame(blank);

%% Dark fixation point
fixation = blank;
fixPointSamples = round((nSamples/2-3):(nSamples/2+3));
[x,y] = meshgrid(fixPointSamples,fixPointSamples);
fixation(x(:),y(:),:) = .2;

%% Light between trials
betweenTrial = blank;
betweenTrial(x(:),y(:),:) = .7;

%% Make the contrast levels

nTrials = 15;
trialType = (rand(1,nTrials) > 0.5);
contrast = logspace(-2,-.6,10);
cLevel = contrast(round(rand(1,nTrials)*(length(contrast)-1)) + 1);
%% Show the fixation point

v = VideoWriter('grating2IFC');
v.FrameRate = 8;
open(v);

%% Make the movie
h = ieNewGraphWin;
set(h,'Color',[.5 .5 .5]);
imshow(fixation);
frame = getframe(gcf);
writeVideo(v,frame);
nFrames = 5;
for ii = 1:nTrials
    imshow(betweenTrial);  
    frame = getframe(gcf); writeVideo(v,frame);
    switch trialType(ii)
        case 0
            imshow(fixation);  
            for ff=1:nFrames
                frame = getframe(gcf); writeVideo(v,frame);
            end
            imshow(blank);
            for ff=1:nFrames
                frame = getframe(gcf); writeVideo(v,frame);
            end
            imshow(fixation);
            for ff=1:nFrames
                frame = getframe(gcf); writeVideo(v,frame);
            end
            img = (stim*cLevel(ii)/2) + .5;
            imshow(img); 
            for ff=1:nFrames
                frame = getframe(gcf); writeVideo(v,frame);
            end
        case 1
            imshow(fixation);
            for ff=1:nFrames
                frame = getframe(gcf); writeVideo(v,frame);
            end
            img = (stim*cLevel(ii)/2) + .5;
            imshow(img);
            for ff=1:nFrames
                frame = getframe(gcf); writeVideo(v,frame);
            end
            imshow(fixation);
            for ff=1:nFrames
                frame = getframe(gcf); writeVideo(v,frame);
            end
            imshow(blank);
            for ff=1:nFrames
                frame = getframe(gcf); writeVideo(v,frame);
            end   
    end
end
close(v);

%% Make the movie
clear M
M(1) = im2frame(fixation);
M = addToMovie(M,fixation,4);
for ii = 1:nTrials
    imshow(betweenTrial);  M = addToMovie(M,betweenTrial,15);
    pause(1.5);
    switch trialType(ii)
        case 0
            imshow(fixation);  M = addToMovie(M,fixation,5);
            beep; pause(0.3)
            imshow(blank);     M = addToMovie(M,blank,10);
            pause(1)
            imshow(fixation);  M = addToMovie(M,fixation,5);
            beep; pause(0.3)
            img = (stim*cLevel(ii)/2) + .5;
            imshow(img); M = addToMovie(M,img,10);
            pause(1)
        case 1
            imshow(fixation); M = addToMovie(M,fixation,5);
            beep; pause(0.3)
            img = (stim*cLevel(ii)/2) + .5;
            imshow(img); M = addToMovie(M,img,10);
            pause(1)
            imshow(fixation);  M = addToMovie(M,fixation,5);
            beep; pause(0.3)
            imshow(blank); M = addToMovie(M,blank,10);
            pause(1)
    end
end

%
imshow(betweenTrial);  
M = addToMovie(M,betweenTrial,15);

%% Write the movie to a file
v = VideoWriter('grating2IFC');
% v.FrameRate = 8;

open(v);
writeVideo(v,M);
close(v);
% movie2avi(M,,'fps',8,'compression','None');

% movie(M,1,8)
%% END

A = rand(300);
v = VideoWriter('newfile.avi');
open(v)
writeVideo(v,A)
close(v)



