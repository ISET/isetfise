% Aspherics to eliminate spherical aberration
%
% A lens made of one material (constant index of refraction) that has no
% spherical aberration can be built by adjusting the various parameters of
% this shape.  This aspheric formula is commonly used in optical design to
% create an aspheric lens.
%
% The parameter z is also called the 'sag' of the aspheric lens.  We can
% assume that the surface is rotationally symmetric.  So for the sag on a
% two-dimensional suface, z(rx,ry) we can simply calculate using
% 
%   r = sqrt(rx^2 + ry^2);
%   z(r)
%
% 
% It is also possible to create two-dimensional conics, which I believe
% Trisha implemented in ISET3d, ISETBio.  See the notes in the Gemini link
% below.
%
% Comments and code from Gemini:
%   https://g.co/gemini/share/a89a3d193d26
%

%% This is the shape of the family of aspherics

% r = distance from the lens center
% R = Radius of curvature at the vertex of the lens
% k = conic constant

rho = -0.5:0.01:0.5;
R = 1;

A4 = 0; A6 = 0; A8 = 0;  % For convenience
ieNewGraphWin;

for k = -3:0.1:3
    % z = rho.^2 ./ (R * (1 + sqrt(1 - (1+k)*(rho.^2/R^2))));
    z = aspheric_surface(rho,R,k,A4,A6,A8);
    plot(rho,z,'k'); hold on; grid on;
end

%% Special case of k=0, the shape becomes a sphere

zSphere = aspheric_surface(rho,R,0,0,0,0);
hold on;
plot(rho,zSphere,'r');
axis equal

%% The aspheric surface function

function z = aspheric_surface(rho, R, k, A4, A6, A8)
% ASPHERIC_SURFACE Calculates the sag of an aspheric surface.
%
%   z = ASPHERIC_SURFACE(rho, R, k, A4, A6, A8) 
%   calculates the sag (z) of an aspheric surface at a radial distance 
%   'rho' from the optical axis.
%
%   Inputs:
%       rho: Radial distance from the optical axis.
%       R: Radius of curvature at the vertex of the lens.
%       k: Conic constant.
%       A4, A6, A8: Higher-order aspheric coefficients.
%
%   Output:
%       z: Sag of the surface at the given radial distance.

    term1 = (rho.^2 / R) ./ (1 + sqrt(1 - (1 + k) * (rho/R).^2));
    term2 = A4 * rho.^4;
    term3 = A6 * rho.^6;
    term4 = A8 * rho.^8;

    z = term1 + term2 + term3 + term4;

end
