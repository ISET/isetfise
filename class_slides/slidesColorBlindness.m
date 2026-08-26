%% Estimating cone fundamentals from color matching functions

% Here are the standard CMFs
[stockman,wave] = ieReadSpectra('StockmanEnergy');
ieNewGraphWin;
plot(wave,stockman);

%% We create example CMFs for the three types of dichromats
% 
% We apply a linear transform to protan/deutan/tritan fundamentals. We can
% use a different linear transform for each of the deuteranopic CMFs and
% the calculation will still work.  (We should check that L,M and N are
% invertible).
L = rand(2,2);
M = rand(2,2);
N = rand(2,2);

% The made-up CMFs of the three types of deuteranopes
protan = stockman(:,2:3)*L;
deutan = stockman(:,[1,3])*M;
tritan = stockman(:,1:2)*N;

%%  The intersection of planes

% Create a single matrix that has the two dimensions of one type of
% dichromatic in the first two columns and the two dimensions of a second
% type of dichromatic in the second two columns.

X = [deutan,tritan];  % L-cone
% X = [protan,tritan];  % M-cone
% X = [protan,deutan];  % S-cone

% We find the intersection of the two deuteranopic planes by solving this
% equation
%
%   0 = X*nullVec
%  
% The solution is the null vector of this matrix.  I could have done it
% another way, I suppose.  But this seems clear to me.  We find the solution
% to 0 = X'*X * nullVec from the svd.
%
[U,~,~] = svd(X'*X);

% Check that this a pretty good null vector
max(abs(X*U(:,4)))

% Now find the weighted some of the first two columns that is in the
% intersection. It will be the negative of the second two columns in the
% intersection.
nullVec = U(:,4);
est = X(:,[1,2])*nullVec(1:2);
est2 = X(:,[3,4])*nullVec(3:4);


% Make it positive
if sum(est) < 0, est = -1*est; end
est = ieScale(est,1);
%{ 
% You could check this
 if sum(est2) < 0, est = -1*est2; end
 est2 = ieScale(est2,1);
 ieNewGraphWin, plot(est(:),est2(:),'.');
 identityLine;
%} 

% Plot the estimate and compare with the original
% The 0.99 makes the overlay visible
ieNewGraphWin;
plot(wave,0.99*est,'k--',wave,stockman);

%%


