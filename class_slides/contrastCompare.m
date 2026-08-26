%% Make contrast sweep images (JPEG related)
%
% Description
%  The purpose is to show that contrast is harder to discriminate at high
%  than low spatial frequencies.  This is why we allocate fewer bits to high
%  than low frequency contrast in JPEG quantization.
%
% Wandell

%% Contrast levels
contrast = 0.05:0.025:0.8;

%% Low frequency contrast sweep

parms = harmonicP;

parms.freq = 1;
parms.ph  = 1;
parms.ang = pi/2;
parms.row = 64;
parms.col = 256;
parms.GaborFlag = 0;

% Build up the image, adding terms with increasing contrast
img1 = [];
for c = contrast
    parms.contrast = c;
    img1 = cat(1, img1, imageHarmonic(parms));
end
img1 = ieScale(img1,255);
f = ieNewGraphWin; 
image(img1); colormap(gray(255))
truesize(f); axis off

%% High frequency version
parms.freq = 8;
img2 = [];
for c = contrast
    parms.contrast = c;
    img2 = cat(1, img2, imageHarmonic(parms));
end
img2 = ieScale(img2,255);

f = ieNewGraphWin; 
image(img2); colormap(gray(255))
truesize(f); axis off
%% Put them in the same image, separated by blank

blank = 128*ones(size(img1));
img = cat(2,img1,blank);
img = cat(2,img,img2);

f = ieNewGraphWin; 
image(img); 
colormap(gray(255))
truesize(f); axis off

%% Place them side-by-side with a gray in between
x  = 1:size(img,1);
y1 = img1(:,1);
y2 = img2(:,1);
ieNewGraphWin([],'wide'); 
p = plot(x,y1,'r'); p.LineWidth = 2;
hold on;
p = plot(x,y2,'b'); 


%% END