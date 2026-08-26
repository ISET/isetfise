%% fise_imageHarmonics1d
%
% Create the 1D image harmonic examples.
%


%%
ieInit;
fise_plotDefaults;

%%
x = linspace(0,1,512);
[X,Y] = meshgrid(x,x);

%% optics-harmonics-2d
ieFigure;
tiledlayout(1,4);

nexttile;
fx = 2; fy = 0;
img = 1 + sin(2*pi*fx*X + 2*pi*fy*Y);
imagesc(x,x,img); colormap(gray);
axis off image tight

nexttile;
fx = 0; fy = 3;
img = 1 + sin(2*pi*fx*X + 2*pi*fy*Y);
imagesc(x,x,img); colormap(gray);
axis off image tight


nexttile;
fx = 2; fy = -4;
img = 1 + sin(2*pi*fx*X + 2*pi*fy*Y);
imagesc(x,x,img); colormap(gray);
axis off image tight

nexttile;
fx = 2; fy = 1;
img = 1 + sin(2*pi*fx*X + 2*pi*fy*Y);
imagesc(x,x,img); colormap(gray);
axis off image tight

%{
fname = fullfile(fiseRootPath,'chapters','images','optics','optics-harmonics.png');
exportgraphics(gcf,fname);
%}

%% optics-harmonics-1d

ieFigure;
tiledlayout(3,4);
fy = 0;
for cx = [1 0.5 0.1]
    for fx = [1 2 4 8]
        nexttile
        img = (1 + cx*sin(2*pi*fx*X + 2*pi*fy*Y))*128;
        image(x,x,img); colormap(gray);
        axis off image tight
    end
end

%{
fname = fullfile(fiseRootPath,'chapters','images','optics','optics-harmonics-1d.png');
exportgraphics(gcf,fname);
%}

%%
