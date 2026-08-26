%% How photons become electrons and preserve the Poisson distribution

%% The Poisson distribution
% The Poisson distribution describes the statistics of a series of 'events'. 
% For light an event is the arrival of a photon. 
% 
% The defining property of a Poisson distribution is that the chance of an event 
% is the same at each small interval of time. 
% 
% Suppose that for each small unit of time, $\delta T$ the probability that 
% a photon will arrive is constant, $\rho$. 

duration  = 0.2;             % Exposure duration
deltaT    = 1e-4;            % A millisecond
rho       = 1e-2;            % Chance of a photon in deltaT
T = deltaT:deltaT:duration;  % Time samples over 0.1 sec
%% Time series
% We can simulate the probably of an event happening or not, in each instance, 
% using the binomial distribution.  Here is a plot with a line at each moments 
% when there is (1) or is not (0) a photon.

 % The binomial random distribution
iePlot(T,photons);
xlabel('Time (sec)'); ylabel('Photon Event'); grid on
fprintf('There were %d photons in this sample.\n',sum(photons));

%% Now, run many samples and make a histogram of the counts

nSamples = 1000;
cnt = zeros(1,nSamples);
for ii=1:nSamples
    photons = binornd(1,rho,length(T),1);
    cnt(ii) = sum(photons);
end

mu = mean(cnt);
sigma = std(cnt);

ieFigure;

% Create the histogram
h = histogram(cnt, 'Normalization', 'probability');
h.EdgeColor = 'none';
h.FaceColor = [0.3 0.3 1];

hold on; % Prevent the next plot from overwriting the histogram

% Calculate the Probability Mass Function (PMF) of the Poisson distribution
xmin = min(cnt);
xmax = max(cnt);
x = xmin:xmax;
lambda = mu;
f = (lambda.^x .* exp(-lambda)) ./ factorial(x);   
plot(x, f, 'k-', 'LineWidth', 2); % 'r-' for a red solid line

% Calculate the probability density function (PDF) of the Normal distribution
x = linspace(min(cnt), max(cnt), 100);
f = exp(-(x - mu).^2 / (2 * sigma^2)) / (sigma * sqrt(2 * pi));
plot(x, f, 'r:', 'LineWidth', 2); % 'r-' for a red solid line

% Add labels and title
xlabel('Value');
ylabel('Probability');
% title('Histogram with Normal Distribution Overlay');
% legend('Histogram', 'Normal Distribution');

hold off; % Allow subsequent plots to overwrite this one


% The mean and variance are equal in the Poisson
fprintf('Mean %.3f Variance %0.3f\n',mean(cnt),var(cnt));

%% Photon to electron conversion
% At the sensor, an event is when a photon creates an electron. For a CMOS or 
% CCD image sensor, each photon turns into one electron or no electrons.  
% 
% Suppose the probability of a photon generating an electron is $\epsilon$.  
% Let's set epsilon to one half, as an example.

epsilon = 0.2;
%% 
% The probability of conversion is the same whenever the photon arrives. Here 
% is the probability of the conversion, which is also a Poisson distribution.

eConversion = binornd(1,epsilon,length(T),1);
%% 
% This is not worth plotting because with $\epsilon$ so large.  The graph of 
% eConversion will just look like a solid red square.  We will have an electron 
% in the interval $\delta T$ if 
%
% * There is a photon in that interval, and 
% * The electron conversion value is 1.
% 
% The probability is the same in each little time interval, and thus the whole 
% calculation is Poisson.

electrons = photons .* eConversion;
%% 
% Here is a plot of the electrons.  This is a subset of the times when there 
% is a photon

iePlot(T,electrons);
xlabel('Time (sec)'); ylabel('Electrons'); grid on
% fprintf('Combining photons with conversion likelihood, there were %d electrons\n',sum(electrons));
%% Equivalent calculation
% We do not have to do the calculation in two steps.  The calculation would 
% be the same distribution if we combine the two probabilities up front. 

electrons2 = binornd(1,rho*epsilon,length(T),1);
%% 
% This produces the same results as doing the calculation in two steps.

iePlot(T,electrons2);
% set(f,'Position',[100 100 256 64]);
xlabel('Time (sec)');
ylabel('Electrons'); grid on
fprintf('The alternative calculation - use the binomial with the combined probabilities.\nThere were %d electrons\n',sum(electrons));

%% Counts
cnt = zeros(1,nSamples);
for ii=1:nSamples
    tmp = binornd(1,rho*epsilon,length(T),1);
    cnt(ii) = sum(tmp);
end

% Counts and standard deviation of the counts
mu = mean(cnt);
sigma = std(cnt);

% Create the histogram
ieFigure;
h = histogram(cnt, 'Normalization', 'probability');
h.EdgeColor = [0.3 0.3 0.3];
h.FaceColor = [0.0 0.1 1];

hold on; % Prevent the next plot from overwriting the histogram

% Generate x-values for the Normal distribution plot

% Calculate the Probability Mass Function (PMF) of the Poisson distribution
xmin = min(cnt);
xmax = max(cnt);
x = xmin:xmax;
lambda = mu;
f = (lambda.^x .* exp(-lambda)) ./ factorial(x);   
plot(x, f, 'k-', 'LineWidth', 2); % 'r-' for a red solid line

% Calculate the probability density function (PDF) of the Normal distribution
x = linspace(min(cnt), max(cnt), 100);
f = exp(-(x - mu).^2 / (2 * sigma^2)) / (sigma * sqrt(2 * pi));
plot(x, f, 'k:', 'LineWidth', 2); % 'r-' for a red solid line

% Add labels and title
xlabel('Value');
ylabel('Probability');
% title('Histogram with Normal Distribution Overlay');
% legend('Histogram', 'Normal Distribution');

hold off; % Allow subsequent plots to overwrite this one
grid on;

% The mean and variance are equal in the Poisson
fprintf('Mean %.3f Variance %0.3f\n',mean(cnt),var(cnt));

%%