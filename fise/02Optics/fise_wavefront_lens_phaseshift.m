function fise_wavefront_lens_phaseshift(varargin)
% A linear phase ramp changes the direction of a collimated wavefront
%
% A collimated beam from a distant point arrives as a flat wavefront at
% a spatial light modulator (SLM), a device that leaves the amplitude of
% the light unchanged but delays its phase by an amount that varies
% across the surface. Here the SLM adds a phase shift that grows
% linearly with height on the device -- the same idea used by a blazed
% grating, a prism, or an optical phased array to steer a beam.
%
% As in fise_wavefrontLens, each ray is drawn as a little wave, and the
% peaks across the rays define the wavefront. Before the SLM the peaks
% line up on a flat, vertical line. A linear phase ramp keeps the
% outgoing beam collimated (still flat, still parallel rays) but tilts
% the wavefront -- and therefore the direction of propagation -- by an
% angle theta. The dashed line shows where the wavefront would have
% continued with no phase ramp; the solid tilted line is the actual
% (deflected) wavefront.
%
% Optional parameters:
%   tiltdeg    - the tilt angle produced by the phase ramp, in degrees
%                (default 12)
%   save_image - export a high-resolution PNG of the figure (default
%                false); see outDir below for where it is written
%
% See also
%   fise_wavefrontLens, fise_wavetimecourse
%
%   fise_wavefront_lens_phaseshift('tiltdeg',20);

%% Parse inputs
varargin = ieParamFormat(varargin);
p = inputParser;
p.addParameter('tiltdeg',12,@isscalar);
p.addParameter('save_image',false,@islogical);
p.parse(varargin{:});
theta      = p.Results.tiltdeg*pi/180;
save_image = p.Results.save_image;

%% Geometry
h     = 1;        % Aperture half-height
xIn   = -4;       % Left edge of the drawing
nRays = 7;

rippleAmp = 0.05;
period    = 0.85;

xOutSpan = 4;                 % Horizontal extent of the outgoing beam
sOut     = xOutSpan/cos(theta);   % Arc length along the tilted rays

y0 = linspace(-h,h,nRays);

% Outgoing ray direction, and its perpendicular (for the ripple), after
% the SLM tilts the wavefront by theta.
dOut = [cos(theta), -sin(theta)];
nOut = [sin(theta),  cos(theta)];

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

% Mark a few successive incoming wavefronts.
for k = 1:3
    xPeak = -period/4 - (k-1)*period;
    if xPeak > xIn
        plot([xPeak xPeak], [-h-0.25 h+0.25], '--', 'Color',[0.6 0.6 0.6]);
    end
end

% The SLM: a thin, pixelated-looking slab.
slmHalfWidth = 0.05;
patch(slmHalfWidth*[-1 1 1 -1], [-h -h h h], [0.88 0.88 0.88], ...
    'EdgeColor',[0.3 0.3 0.3],'LineWidth',1.2);
for yTick = linspace(-h,h,9)
    plot(slmHalfWidth*[-1 1], [yTick yTick], 'Color',[0.6 0.6 0.6]);
end
text(0, h+0.3, 'Phase modulator (SLM)', 'HorizontalAlignment','center', ...
    'FontSize',11);

% Outgoing rays: still collimated, but tilted by theta. The SLM adds a
% phase shift that grows linearly with y0; that is what tilts the
% wavefront. Each ray is drawn as a little wave along its own tilted
% direction, with the ramp's phase built into the ripple.
sVec = linspace(0, sOut, 300);
for ii = 1:nRays
    rampPhase = (2*pi/period)*sin(theta)*y0(ii);
    ripple = rippleAmp*sin(2*pi*sVec/period + rampPhase);
    pts = [0 y0(ii)] + sVec'*dOut + ripple'*nOut;
    plot(pts(:,1), pts(:,2), 'Color',[0.75 0.15 0.15],'LineWidth',1.1);
end

% The actual (tilted) wavefront: successive wave peaks on each outgoing
% ray, connected across rays. Three parallel lines match the three
% wavefronts marked on the incoming (collimated) side.
nWavefronts = 3;
crestPt = zeros(nRays,2);
crestPt0 = zeros(nRays,2);
for n = 0:nWavefronts-1
    for ii = 1:nRays
        rampPhase = (2*pi/period)*sin(theta)*y0(ii);
        sPeak = mod(period/4 - period*rampPhase/(2*pi), period) + n*period;
        crestPt(ii,:) = [0 y0(ii)] + sPeak*dOut;
    end
    plot(crestPt(:,1), crestPt(:,2), '--', 'Color',[0.75 0.15 0.15], ...
        'LineWidth',1.8);
    if n == 0
        crestPt0 = crestPt;
        plot(crestPt0(:,1), crestPt0(:,2), 'o','MarkerSize',5,...
            'MarkerFaceColor',[0.75 0.15 0.15],'MarkerEdgeColor','none');
    end
end

% The undeflected wavefront: where the flat wavefront would have
% continued with no phase ramp.
xUndeflected = mean(crestPt0(:,1));
plot([xUndeflected xUndeflected], [-h-0.25 h+0.25], '--', ...
    'Color',[0.2 0.2 0.2],'LineWidth',1.3);
text(xUndeflected+0.1, h+0.75, 'Undeflected wavefront (no ramp)', ...
    'FontSize',10,'Color',[0.2 0.2 0.2]);
text(crestPt0(1,1)+0.1, crestPt0(1,2)-0.35, 'Tilted (actual) wavefront', ...
    'FontSize',10,'Color',[0.75 0.15 0.15]);

% Angle arc and label at the on-axis ray, right where it leaves the SLM.
arcR   = 0.45;
arcAng = linspace(0,-theta,20);
plot(arcR*cos(arcAng), arcR*sin(arcAng), 'Color',[0.3 0.3 0.3]);
text(arcR*cos(theta/2)+0.12, arcR*sin(theta/2)-0.05, '\theta', ...
    'FontSize',13,'HorizontalAlignment','left');

text(xIn+0.1, h+1.1, 'Collimated beam','FontSize',11);

xlim([xIn-0.3, xOutSpan+0.6]); ylim([-h-0.9, h+1.3]);
title('A linear phase ramp tilts the wavefront direction');

%% Save
% Destined for chapters/images/optics/12-wavefront/ in the FISE book;
% written here to a local, gitignored directory and copied over by hand.
if save_image
    outDir = fullfile(fileparts(fileparts(fileparts(mfilename('fullpath')))), ...
        'local','images','optics','12-wavefront');
    if ~exist(outDir,'dir'), mkdir(outDir); end
    exportgraphics(gcf, fullfile(outDir,'wavefront-phaseramp.png'), ...
        'Resolution',300);
end
