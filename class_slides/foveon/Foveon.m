%% Convert Foveon grabit data

%
% These data are in isetwork/foveon
% Maybe in the Psych 221 02 sensor directory
%{
w = 370:730;

d = load('FoveonFilteredBlue');
wave = d.Data001(:,1);
blue = d.Data001(:,2);
blue = max(blue,0);
blue = interp1(wave,blue,w);
vcNewGraphWin; plot(w,blue);

d = load('FoveonFilteredGreen');
wave = d.Data002(:,1);
green = d.Data002(:,2);
green = max(green,0);
green = interp1(wave,green,w);
vcNewGraphWin;
plot(w,green);


d = load('FoveonFilteredRed');
w = 370:730;
wave = d.Data003(:,1);
red = d.Data003(:,2);
red = max(red,0);
red = interp1(wave,red,w);
vcNewGraphWin;
plot(w,red);

%% Save to iset data

inData.wavelength = w;
inData.data = [red(:),green(:),blue(:)];
inData.filterNames = {'r','g','b'};
inData.comment = 'Foveon spectral responses with IR filter in place.  From grabit';
fname = fullfile(isetRootPath,'data','sensor','colorfilters','Foveon.mat');
ieSaveColorFilter(inData,fname);

%%  Have a look

foveonFilters = ieReadColorFilter(w,fname);
vcNewGraphWin; plot(w,foveonFilters);
%}

%% Estimate the probability of absorption for different wavelengths as a function of depth

% From 400 to 700, the a(lambda) gets smaller and smaller.  I made it
% drop off linearly
wave = 400:20:700;
nWave = length(wave);
A = (nWave:-1:1)/(nWave/2);
A = A.^1.5;
ieNewGraphWin; p = plot(wave,A);
set(p,'Linewidth',2);
set(gca,'fontsize',20)
xlabel('Wavelength (nm)','fontsize',20); ylabel('Relative sensitivity','fontsize',20)
grid on

%%
depth = 0:0.1:4;
p = zeros(nWave,length(depth));
for ii=1:nWave
    p(ii,:) = A(ii) .* exp(-A(ii) .* depth);
end
s = sum(p,2);
p = diag(1./s)*p;
% imagesc(p)
vcNewGraphWin;
mesh(depth,wave,p)
xlabel('Depth (um)'); ylabel('Wavelength (nm)'); zlabel('Relative sensitivity')

% set(gca,'zscale','log');

%% Now add up the curves over different depth ranges
ieNewGraphWin;
top = sum(p(:,1:3),2);
mid = sum(p(:,4:10),2);
bot = sum(p(:,11:end),2);
plot(wave,top,'b-',wave,mid,'g-',wave,bot,'r-','Linewidth',2)
xlabel('Wavelength (nm)','fontsize',20); ylabel('Relative sensitivity','fontsize',20)
grid on
%%






