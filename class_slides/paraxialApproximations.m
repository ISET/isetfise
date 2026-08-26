%% Paraxial approximations
%
% For making the paraxial geometric optics slides
%

%% 
chdir(teachRootPath);
chdir('slides');

%% 
close all

%% 0.1 radian is about 5.7 deg

xRadians = -1:0.01:1;
xDegrees = rad2deg(xRadians);
lst = xDegrees > -20 & xDegrees < 20;
xRange = deg2rad(xDegrees(lst));

ieNewGraphWin;
plot(xRadians,sin(xRadians),'LineWidth',2);
hold on; plot(xRadians,xRadians,'k--','LineWidth',2);
grid on;
xlabel('Angle (radians)')
set(gca,'ylim',[-1 1])
line([0.2 0.2],[-1 1],'Color',[0.3 0.3 0.3]);
line([-0.2 -0.2 ],[-1 1 ],'Color',[0.3 0.3 0.3]);
xlabel('Angle (radians)');
exportgraphics(gca,'paraxSine.png','Resolution',150);

ieNewGraphWin;
plot(xRadians,cos(xRadians),'LineWidth',2);
hold on; plot(xRadians,ones(size(xRadians)),'k--','LineWidth',2);
grid on;
set(gca,'ylim',[-1 1])
line([0.2 0.2],[-1 1],'Color',[0.3 0.3 0.3]);
line([-0.2 -0.2 ],[-1 1 ],'Color',[0.3 0.3 0.3]);
xlabel('Angle (radians)');
exportgraphics(gca,'paraxCosine.png','Resolution',150);

ieNewGraphWin;
plot(xRadians,tan(xRadians),'LineWidth',2)
hold on; plot(xRadians,xRadians,'k--','LineWidth',2); 
grid on;
set(gca,'ylim',[-1 1])
line([0.2 0.2],[-1 1],'Color',[0.3 0.3 0.3]);
line([-0.2 -0.2 ],[-1 1 ],'Color',[0.3 0.3 0.3]);
xlabel('Angle (radians)');
exportgraphics(gca,'paraxTangent.png','Resolution',150);

%%
%{
ieNewGraphWin;
plot(xRange,sin(xRange));
hold on; plot(xRange,xRange,'k--');
grid on;
xlabel('Angle (radians)')
set(gca,'ylim',[-1 1])

ieNewGraphWin;
plot(xRange,cos(xRange));
hold on; plot(xRange,ones(size(xRange)),'k--');
grid on;
set(gca,'ylim',[0 1])

ieNewGraphWin;
plot(xRange,tan(xRange),'')
hold on; plot(xRange,xRange,'k--'); 
grid on;
set(gca,'ylim',[-1 1])
%}
%%