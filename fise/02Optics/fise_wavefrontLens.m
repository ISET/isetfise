function fise_wavefrontLens(varargin)
% A lens converts a flat (collimated) wavefront into a converging one
%
% A collimated beam from a distant point arrives at a lens as a flat
% wavefront. An ideal lens turns it into a perfect converging spherical
% wave. A real lens cannot do this exactly: the actual wavefront
% deviates from the ideal (reference) sphere by an amount W(rho), the
% wavefront aberration, where rho is the ray height at the lens.
%
% Each ray is drawn as a little wave -- a sinusoid riding along the ray
% -- and the peaks of these little waves, taken across all the rays,
% define the wavefront. Before the lens the peaks line up on a flat
% (vertical) line, the signature of collimated light. After the lens we
% mark, on each ray, the peak that lands on the ideal reference sphere
% (dashed) and the peak that lands on the actual, aberrated wavefront
% (solid). The gap between them is W(rho).
%
% The aberration shown here (a rho^4 term, the classic spherical
% aberration signature) is exaggerated far beyond real wavelength-scale
% deviations so that it is visible in the drawing.
%
% Optional parameters:
%   aberration - W at the pupil edge, in the same units as the pupil
%                half-height and the lens-to-focus distance below
%                (default 0.3)
%   save_image - export a high-resolution PNG of the figure (default
%                false); see outDir below for where it is written
%
% See also
%   fise_wavefront_lens_phaseshift, fise_wavetimecourse
%
%   fise_wavefrontLens('aberration',1);

%% Parse inputs
varargin = ieParamFormat(varargin);
p = inputParser;
p.addParameter('aberration',0.3,@isscalar);
p.addParameter('save_image',false,@islogical);
p.parse(varargin{:});
Wedge      = p.Results.aberration;
save_image = p.Results.save_image;

%% Geometry
h     = 1;        % Pupil (aperture) half-height
f     = 6;        % Lens-to-focus distance
xIn   = -4;       % Left edge of the drawing
nRays = 7;
r0    = 0.42*f;   % Radius of the reference sphere, measured back from the focus

rippleAmp = 0.05;
period    = 0.85;

y0    = linspace(-h,h,nRays);
focus = [f 0];

%% Ideal and actual wavefront points, one per ray
% Each ray runs straight from the lens to the focus. The reference
% sphere is the point a fixed distance r0 back from the focus; the
% actual wavefront is (r0 + W(rho)) back from the focus, along the same
% ray.
R    = sqrt(f^2 + y0.^2);        % Lens-to-focus distance for this ray
dirX = f./R;  dirY = -y0./R;     % Unit vector from the lens toward the focus
W    = Wedge*(y0/h).^4;          % Spherical aberration term

idealPt  = [focus(1) - r0*dirX;      focus(2) - r0*dirY];
actualPt = [focus(1) - (r0+W).*dirX; focus(2) - (r0+W).*dirY];

% Dense versions of the same two curves, for smooth arcs.
yy  = linspace(-h,h,200);
Rd  = sqrt(f^2 + yy.^2);
dXd = f./Rd; dYd = -yy./Rd;
Wd  = Wedge*(yy/h).^4;
idealCurve  = [focus(1) - r0*dXd;       focus(2) - r0*dYd];
actualCurve = [focus(1) - (r0+Wd).*dXd; focus(2) - (r0+Wd).*dYd];

%% Draw

ieFigure([],'wide');
hold on; axis equal off;

% Incoming rays, each drawn as a little wave. All the rays share the
% same ripple phase, so their peaks line up on a flat (vertical)
% wavefront -- the signature of collimated light.
xIncoming = linspace(xIn,0,400);
for ii = 1:nRays
    ripple = rippleAmp*sin(2*pi*(-xIncoming)/period);
    plot(xIncoming, y0(ii) + ripple, 'Color',[0.20 0.40 0.75],'LineWidth',1.1);
end

% Mark a few successive incoming wavefronts: flat lines through aligned
% peaks.
for k = 1:3
    xPeak = -period/4 - (k-1)*period;
    if xPeak > xIn
        plot([xPeak xPeak], [-h-0.25 h+0.25], '--', 'Color',[0.6 0.6 0.6]);
    end
end

% The lens: a simple biconvex glyph.
yLens  = linspace(-h,h,60);
bulge  = 0.12;
xLensL = -bulge*(1-(yLens/h).^2);
xLensR =  bulge*(1-(yLens/h).^2);
patch([xLensR fliplr(xLensL)], [yLens fliplr(yLens)], [0.85 0.92 1], ...
    'EdgeColor',[0.2 0.3 0.5],'LineWidth',1.2);

% Rays after the lens, converging on the focus.
for ii = 1:nRays
    plot([0 f], [y0(ii) 0], 'Color',[0.75 0.75 0.75],'LineWidth',0.8);
end

% Focus
plot(f,0,'k+','MarkerSize',8,'LineWidth',1.5);
text(f, -0.28, 'Paraxial focus', 'HorizontalAlignment','center','FontSize',10);

% The two wavefronts.
hIdeal  = plot(idealCurve(1,:), idealCurve(2,:), '--', 'Color',[0.2 0.2 0.2],'LineWidth',2.2);
hActual = plot(actualCurve(1,:),actualCurve(2,:), '-',  'Color',[0.75 0.15 0.15],'LineWidth',1.8);

% Little-wave crest markers on each ray.
for ii = 1:nRays
    plot(idealPt(1,ii), idealPt(2,ii), 'o','MarkerSize',5,...
        'MarkerFaceColor',[0.2 0.2 0.2],'MarkerEdgeColor','none');
    plot(actualPt(1,ii),actualPt(2,ii),'o','MarkerSize',5,...
        'MarkerFaceColor',[0.75 0.15 0.15],'MarkerEdgeColor','none');
end

% Label the W(rho) gap for the marginal (top) ray.
ii = nRays;
plot([idealPt(1,ii) actualPt(1,ii)], [idealPt(2,ii) actualPt(2,ii)], ...
    'Color',[0.4 0.4 0.4]);
text(mean([idealPt(1,ii) actualPt(1,ii)]), idealPt(2,ii)+0.22, ...
    'W(\rho)','FontSize',12,'HorizontalAlignment','center');

% A legend keeps the "reference" and "actual" labels out of the crowded
% convergence region entirely.
legend([hIdeal hActual], {'Reference (ideal) wavefront','Actual wavefront'}, ...
    'Location','southwest','Box','off','FontSize',10);

text(xIn+0.1, h+0.5, 'Collimated beam','FontSize',11);

xlim([xIn-0.3, f+0.6]); ylim([-h-0.9, h+0.9]);
title('Spherical aberration as a deviation from the ideal wavefront');

%% Save
% Destined for chapters/images/optics/12-wavefront/ in the FISE book;
% written here to a local, gitignored directory and copied over by hand.
if save_image
    outDir = fullfile(fileparts(fileparts(fileparts(mfilename('fullpath')))), ...
        'local','images','optics','12-wavefront');
    if ~exist(outDir,'dir'), mkdir(outDir); end
    exportgraphics(gcf, fullfile(outDir,'wavefront-lens-aberration.png'), ...
        'Resolution',300);
end
