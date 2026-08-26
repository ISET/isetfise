% Contrast reversing gratings
%
% Show the class what contrast-reversing spatial frequency gratings
% look like.  Goes with Robson slide in Human Pattern Vision section.
%
% I chose some different frequencies for the slide.  They were
% computed this way.

%%
% chdir('/Users/wandell/Documents/MATLAB/teach/psych221/slides/contrastThreshold');
ieNewGraphWin; axis image; colormap(gray(256));

%%  Build the stimulus
fx = 6;        % Spatial frequency (cycles/image)
ft = (1:5:15); % Temporal frequency

% Points in space and time
x = (0:255)/256; t= (0:127)/128;

% Mean level of the image
M = 0.5;

%% Contrast reversing grating
for tt=1:numel(ft)
    a = sin(2*pi*ft(tt)*t);
    v = VideoWriter(sprintf('contrastReversing-%dx-%dt',fx,ft(tt)),'MPEG-4');
    v.FrameRate = 16;
    open(v);
    for ii=1:numel(a)
        stim = repmat(M*(1 + a(ii)*sin(2*pi*fx*x)),256,1);
        writeVideo(v,stim);
    end
    close(v);
end

%% Make a moving grating

a = [0.1,0.2,0.4];
for aa = a
    ph = linspace(0,1,128)*2*pi*4;
    v = VideoWriter(sprintf('moving-%dx-%.1f',fx,aa),'MPEG-4');
    v.FrameRate = 16;
    open(v);
    for ii=1:numel(ph)
        stim = repmat(M*(1 + aa*sin(2*pi*fx*x + ph(ii))),256,1);
        writeVideo(v,stim);
    end
    close(v);
end