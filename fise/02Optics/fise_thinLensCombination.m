%% Thin lens combination


f1 = 3;
f2 = 0.7;
d = linspace(0,2*(f1 + f2),50);

%% The pair becomes diverging at the sum of the two focal lengths
% g = 1/f
g = (1/f1) + (1/f2) - d/(f1*f2);

ieFigure;
plot(d, 1./g,'-ro');
yaxisLine(gca,f1 + f2);

xlabel('Inter-lens distance (m)');
ylabel('Focal length');
grid on;

%% The back focal length subtracts out the distance between the lenses


BFL = f2*(d - f1) ./ (d - (f1 + f2));
ieFigure;
plot(d, BFL, '-b');
yaxisLine(gca,f1);

xaxisLine(gca,0)
xlabel('Inter-lens distance (m)');
ylabel('Back Focal length');
grid on;