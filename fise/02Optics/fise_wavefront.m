function fise_wavefront(varargin)
% How a Zernike polynomial coefficient defines a wavefront aberration
%
% How a Zernike polynomial coefficient defines a wavefront aberration,
% how that aberration enters the pupil function, and how the point
% spread function follows from the pupil function.
%
% The wavefront aberration W(rho,theta) is the optical path difference
% between the actual and the ideal (reference) wavefront, measured
% across the pupil in polar coordinates. The pupil function combines an
% amplitude term A(rho,theta) (1 inside the aperture, 0 outside) with a
% phase term derived from W:
%
%   P(rho,theta) = A(rho,theta) * exp(1i * (2*pi/lambda) * W(rho,theta))
%
% W is expanded in Zernike polynomials, W = sum_i a_i * Z_i(rho,theta),
% and each coefficient a_i corresponds to a named aberration mode
% (defocus, astigmatism, coma, spherical, trefoil, ...). The PSF is the
% squared magnitude of the Fourier transform of the pupil function, so
% changes to a single Zernike coefficient show up directly as changes to
% the PSF shape.
%
% This is a condensed version of the ISETCam tutorials t_wvfOverview and
% t_wvfZernike, focused on the pupil-function and Zernike material in the
% wavefronts chapter.
%
% Optional parameter:
%   save_image - export a high-resolution PNG of each of the three
%                figures below (default false); see outDir below for
%                where they are written
%
% See also
%   t_wvfOverview, t_wvfZernike, wvfCreate, wvfSet, wvfCompute, wvfPlot
%
%   fise_wavefront('save_image',true);

%% Parse inputs
varargin = ieParamFormat(varargin);
p = inputParser;
p.addParameter('save_image',false,@islogical);
p.parse(varargin{:});
save_image = p.Results.save_image;

% Destined for chapters/images/optics/12-wavefront/ in the FISE book;
% written here to a local, gitignored directory and copied over by hand.
if save_image
    outDir = fullfile(fileparts(fileparts(fileparts(mfilename('fullpath')))), ...
        'local','images','optics','12-wavefront');
    if ~exist(outDir,'dir'), mkdir(outDir); end
end

%% Initialize

wave         = 550;   % Single wavelength (nm) for all the plots
psfRangeUM   = 20;     % PSF plot range (microns)
pupilRangeMM = 2;      % Pupil plot range (mm)

%% Diffraction-limited pupil function and PSF
% With no aberrations (all Zernike coefficients are 0), the wavefront
% aberration is zero everywhere, so the pupil function is just the
% aperture: amplitude 1 inside the pupil, flat (zero) phase. The
% resulting PSF is the diffraction-limited Airy pattern.

wvf0 = wvfCreate;
wvf0 = wvfCompute(wvf0);

ieFigure([], 'wide');
tiledlayout(1, 3);
nexttile;
wvfPlot(wvf0, 'image pupil amp', 'unit', 'mm', 'wave', wave, ...
    'plot range', pupilRangeMM, 'window', false);
nexttile;
wvfPlot(wvf0, 'image pupil phase', 'unit', 'mm', 'wave', wave, ...
    'plot range', pupilRangeMM, 'window', false);
nexttile;
wvfPlot(wvf0, 'psf', 'unit', 'um', 'wave', wave, ...
    'plot range', psfRangeUM, 'airy disk', true, 'window', false);

if save_image
    exportgraphics(gcf, fullfile(outDir,'wavefront-pupil-diffraction.png'), ...
        'Resolution',300);
end

%% Add a single Zernike term: defocus
% Setting one Zernike coefficient makes the wavefront aberration nonzero.
% That aberration appears as spatial phase variation across the pupil --
% the amplitude term is untouched -- which in turn reshapes the PSF away
% from the Airy pattern above. This triptych mirrors the diffraction-
% limited one above it: same amplitude panel, so the two figures compare
% directly and show that only the phase (and hence the PSF) changed.

zVal = 2;   % Zernike coefficient value, in microns
wvf1 = wvfSet(wvf0, 'zcoeffs', zVal, 'defocus');
wvf1 = wvfCompute(wvf1);

ieFigure([], 'wide');
tiledlayout(1, 3);
nexttile;
wvfPlot(wvf1, 'image pupil amp', 'unit', 'mm', 'wave', wave, ...
    'plot range', pupilRangeMM, 'window', false);
nexttile;
wvfPlot(wvf1, 'image pupil phase', 'unit', 'mm', 'wave', wave, ...
    'plot range', pupilRangeMM, 'window', false);
nexttile;
wvfPlot(wvf1, 'psf normalized', 'unit', 'um', 'wave', wave, ...
    'plot range', psfRangeUM, 'window', false);

if save_image
    exportgraphics(gcf, fullfile(outDir,'wavefront-pupil-defocus.png'), ...
        'Resolution',300);
end

%% A gallery of aberration modes
% Each Zernike coefficient corresponds to a named aberration mode. Here
% we set one coefficient at a time, all with the same magnitude, and
% compare how each mode reshapes the PSF.

names = {'defocus', 'vertical_astigmatism', ...
    'primary_spherical', 'vertical_trefoil'};

ieFigure([], 'big');
tiledlayout(2, 2);
for ii = 1:numel(names)
    wvf = wvfSet(wvf0, 'zcoeffs', zVal, names{ii});
    wvf = wvfCompute(wvf);
    nexttile;
    wvfPlot(wvf, 'psf normalized', 'unit', 'um', 'wave', wave, ...
        'plot range', psfRangeUM, 'window', false);
    title(names{ii}, 'Interpreter', 'none');
end

if save_image
    exportgraphics(gcf, fullfile(outDir,'wavefront-pupil-gallery.png'), ...
        'Resolution',300);
end
