% fise_phasors
% 
% Things to show:
%  - change (fx,fy): both points move together, mirror-symmetric
%  - rotate the grating: the pair rotates around the center
%  - change phi: abs(F) is unchanged, angle(F) at the two points
%    moves in opposite directions (+phi and -phi)
% 

% Make an oriented cos
N = 128; [X,Y] = meshgrid((0:N-1)/N);
fx = 6; fy = 3; phi = 0;            % try changing each one
img = 0.5 + 0.4*cos(2*pi*(fx*X + fy*Y) + phi);

% Compute its FFT
F   = fftshift(fft2(img))/N^2;

subplot(1,2,1); imagesc(img); axis image; colormap gray

% Notice the two terms
subplot(1,2,2); imagesc(-N/2:N/2-1, -N/2:N/2-1, abs(F)); axis image xy

xlim([-12 12]); ylim([-12 12]); xlabel('f_x'); ylabel('f_y')

% Explain the notion of complex exponentials and phasors
%
% TODO
