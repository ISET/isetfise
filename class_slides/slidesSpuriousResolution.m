% Principles of spurious resolution illustrated by some computations.
%
% Needs more work and explanation
%
% Wandell, 2019

%%
method = 'gaussian';
% method = 'averaging'

x = [0.01:.005:1]; 
f = 5;
h = sin(2*pi*f*x);

clf;
clear sig
clear kernel

%% Plot the signal
plot(x,h);

% Reference for choosing the box for averaging around the signal frequency.
nSampPerFreq = round(length(x)/f);

% For square averaging
switch lower(method)
    case 'averaging'
        kSize = [-4:2:4] + nSampPerFreq;
    case 'gaussian'
        kSize =  round(nSampPerFreq/5:2:nSampPerFreq/2.5);
end

nSize = length(kSize);

%%
clf
for ii = 1:nSize
    
    switch lower(method)
        case 'averaging'
            kernel{ii} = ones(1,kSize(ii))/kSize(ii);            
        case 'gaussian'
            kernel{ii} = fspecial('gaussian',[1,length(h)],kSize(ii));
    end
    % Averaging kernel
 
    sig(:,ii) = imfilter(h,kernel{ii},'circular');

end

%% Show the spurious resolution
mx = max(sig(:));
for ii=1:nSize
    subplot(nSize,1,ii)
    plot(x,sig(:,ii)); set(gca,'ylim',[-mx mx])
    grid on
end

%% Examine the magnitude and phase of the convolution kernel.
clf
whichKernel = 1;
paddedKernel = zeros(length(h));
paddedKernel(1:length(kernel{whichKernel})) = kernel{whichKernel};
mag = abs(fft(paddedKernel));
ph  = angle(fft(paddedKernel));
fList = 1:length(kernel);
subplot(2,1,1), plot(fList,mag(fList),'k-o'), grid on
subplot(2,1,2), plot(fList,ph(fList),'r-o'), grid on


%%


