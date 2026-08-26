%  slidesEpipolar
%
% These images were rendered with s_translateChessSet on Dec. 2, 2024
% Using iset3d-tiny
%

load('epipolarImages.mat','lum');

%% Have a look at the luminance images face on

hcViewer(lum.^0.5)

%% The motion is right/left.  
% 
% This reveals the epipolar geometry, but I need
% a better explanation.  The x-axis is the column and the y-axis is
% which lum image the row is drawn from.
tst = permute(lum,[2 3 1]);
tst = pagetranspose(tst);
hcViewer(tst.^0.5);
ylabel('Image');
xlabel('Column');
axis on;

%%  Have a look at a cross-section one colun at a time

% Because of the direction of motion, the columns are just a scan of the
% original image
tst = permute(lum,[1 3 2]);
hcViewer(tst.^0.5);

%%
