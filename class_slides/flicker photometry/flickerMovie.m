% Flicker photometry movie
% tutorialInitPath
%
chdir(fullfile(psych221RootPath,'teaching slides','flicker photometry'))

%%
A = ones(1,1,3);
A(1,1,1) = .7;
A(1,1,2) = .5;
A(1,1,3) = .5;
stim1 = imresize(A,[128,128]);

B = ones(1,1,3);
B(1,1,1) = .5;
B(1,1,2) = .5;
B(1,1,3) = .7;
stim2 = imresize(B,[128,128]);

%%
for ii=1:2:50
    M(ii)   = im2frame(stim1);
    M(ii+1) = im2frame(stim2);
end

%% Write the movies to an avi file
disp('Saving two movies')
movie2avi(M,'fpSlow.avi','fps',10,'Compression','None');
movie2avi(M,'fpFast.avi','fps',30,'Compression','None');

%% Show the movies
% h = figure(1);
% movie(h,M,2, 20);

!fpSlow.avi

!fpFast.avi
