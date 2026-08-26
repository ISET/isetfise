%% fise_gaborMTF

ieInit;

%% 

params = harmonicP('Gabor Flag',0.2,'frequency',3,'image size',256);
scene = sceneCreate('harmonic',params);
sceneWindow(scene);
