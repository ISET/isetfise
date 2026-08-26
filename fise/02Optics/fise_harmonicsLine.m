%% Movie of Summing 2D Harmonics to Create a Line Impulse
%%
% 
%  publish('fise_harmonicsLine.m', 'html');
%

N = 129; % Number of samples in each dimension (e.g., 129x129 image)

% 1. Define the spatial grid for the 2D image
x_spatial = linspace(-pi, pi, N); % X-coordinates for plotting
y_spatial = linspace(-pi, pi, N); % Y-coordinates for plotting
[X_grid_spatial, Y_grid_spatial] = meshgrid(x_spatial, y_spatial);

% Create 0-indexed spatial indices grids for the DFT formula (n_x, n_y)
% These are crucial for the (k*n/N) part of the exponential argument.
n_indices_1D = 0:(N-1); % Base 0-indexed vector
[n_x_grid, n_y_grid] = meshgrid(n_indices_1D, n_indices_1D); % 2D grids of 0-indexed spatial positions

%% 2. Define the discrete impulse line
%
% This creates a vertical line impulse at the 65th column (center for N=129).
% In 0-indexed terms, this corresponds to n_x = (N-1)/2 = 64.
discrete_impulse_line = zeros(N, N);
center_column_idx = (N + 1) / 2; % For N=129, this is 65
discrete_impulse_line(:, center_column_idx) = 1;

%% 3. Compute the 2D DFT coefficients of this impulse line
% IMPORTANT: Because the line is SHIFTED from n_x=0, these coefficients
% will be COMPLEX. MATLAB's fft2 places the frequency of variation along
% ROWS in dimension 1 (k_y) and the frequency of variation along COLUMNS
% in dimension 2 (k_x). This image has no variation along rows (it is
% constant down every column), so all of its energy sits in row index 1
% (k_y = 0), spread across every column (all k_x).
DFT_coefficients_2D = fft2(discrete_impulse_line);

% Initialize the 2D image that will accumulate the harmonics.
% It must be initialized with complex zeros because intermediate sums will be complex.
accumulated_harmonics_2D = zeros(N, N);

%% --- Movie Setup ---
% Define the output video file name and format
outputVideoFile = 'line_impulse_build_up_2D_movie.mp4';

fprintf('Creating movie "%s"... This may take a few moments.\n', outputVideoFile);

% --- Summation and Frame Accumulation Loop ---
% All of the signal's energy is in row 1 (k_y = 0) of DFT_coefficients_2D,
% spread across every column (k_x). So we loop through the x-frequency
% components (k_x, or 'fx_val') while holding the row index fixed at 1.
% The loop goes from 0 up to N-1 for fx_val.
%
% Each frame is just the accumulated numeric data -- no figure is
% rendered or screen-captured here. Both getframe and exportgraphics
% came back with solid black frames when called mid-loop during a
% publish-driven run in this MATLAB batch environment (regardless of
% figure visibility), so frames are handed to ieMovie as plain numbers
% instead; ieMovie writes them directly with no rendering step involved.

frames_per_harmonic_step = 1; % Capture a frame for every harmonic added

frameList = {}; % Growing list of accumulated-sum frames actually captured

for fx_val = 0:(N-1) % Loop through x-frequency components (k_x index)

    % Get the DFT coefficient for the current x-frequency, with
    % y-frequency fixed at 0. MATLAB uses 1-based indexing, so k_freq=0
    % is index 1, and dimension 1 is k_y while dimension 2 is k_x:
    % DFT_coefficients_2D(k_y_index + 1, k_x_index + 1)
    current_DFT_coeff = DFT_coefficients_2D(1, fx_val + 1);

    % Calculate the current 2D harmonic component using the complex DFT coefficient
    % and the complex exponential. This component is applied across the entire 2D grid.
    % Note the use of '.*' for element-wise multiplication.
    current_harmonic_component = current_DFT_coeff .* exp(1j * 2 * pi * fx_val * n_x_grid / N);

    % Add the current harmonic component to the accumulated sum
    accumulated_harmonics_2D = accumulated_harmonics_2D + current_harmonic_component;

    % Capture a frame every 'frames_per_harmonic_step' or for the very last harmonic.
    if mod(fx_val, frames_per_harmonic_step) == 0 || fx_val == (N-1)
        % Apply the overall 1/(N*N) scaling factor required for a 2D Inverse DFT.
        % We take the real part because the original impulse line is real;
        % any tiny imaginary parts are due to floating-point precision errors.
        current_frame_data = real(accumulated_harmonics_2D / (N*N));

        % The impulse line is already correctly positioned by the IDFT sum
        % (which handles the shift from its DFT coefficients).
        % So, no additional circshift is needed here.
        frameList{end + 1} = current_frame_data; %#ok<AGROW>
    end
end

% --- Finalize Movie ---
% Stack the accumulated-sum frames into (x, y, t) and hand them to
% ieMovie, isetcam's standard movie-writing utility, instead of a manual
% VideoWriter/writeVideo loop.
movieFrames = cat(3, frameList{:});
ieMovie(movieFrames, 'vname', outputVideoFile, 'show', false, 'FrameRate', 15);
fprintf('Movie creation complete. File saved as: %s\n', outputVideoFile);

%%
% iePublishVideo: line_impulse_build_up_2D_movie.mp4

% --- Optional: Display the final reconstructed impulse line in a separate figure ---
% This plot shows the final state of the summation, identical to the last frame of the movie.
figure; % Create a new figure for the final plot
final_impulse_image = real(accumulated_harmonics_2D / (N*N)); % Final scaling and taking real part

imagesc(x_spatial, y_spatial, final_impulse_image);
axis xy equal tight;
colorbar;
title(['Final Reconstructed 1D Impulse Line (N=' num2str(N) ' Harmonics)']);
xlabel('Spatial X-coordinate (radians)');
ylabel('Spatial Y-coordinate (radians)');
clim([-0.2 1.1]); % Match movie's colorbar limits

fprintf('Maximum value of final reconstructed image: %f\n', max(final_impulse_image(:)));
fprintf('Minimum value of final reconstructed image (excluding peak): %f\n', min(final_impulse_image(final_impulse_image < 0.5)));

%%