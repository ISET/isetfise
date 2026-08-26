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

% 2. Define the discrete impulse line
%%

%%

%%

%%

%%

%%

%%

%%
% 
%   
%


%%
% This creates a vertical line impulse at the 65th column (center for N=129).
% In 0-indexed terms, this corresponds to n_x = (N-1)/2 = 64.
discrete_impulse_line = zeros(N, N);
center_column_idx = (N + 1) / 2; % For N=129, this is 65
discrete_impulse_line(:, center_column_idx) = 1;

% 3. Compute the 2D DFT coefficients of this impulse line
% IMPORTANT: Because the line is SHIFTED from n_x=0, these coefficients
% will be COMPLEX. They will also only be non-zero along the k_y=0 (first)
% row, as a vertical line has no variation in the y-frequency domain.
DFT_coefficients_2D = fft2(discrete_impulse_line);

% Initialize the 2D image that will accumulate the harmonics.
% It must be initialized with complex zeros because intermediate sums will be complex.
accumulated_harmonics_2D = zeros(N, N);

% --- Movie Setup ---
% Define the output video file name and format
outputVideoFile = 'line_impulse_build_up_2D_movie.mp4';
writerObj = VideoWriter(outputVideoFile, 'MPEG-4'); % Using MPEG-4 for good compression
writerObj.FrameRate = 15; % Set desired frames per second (e.g., 10 or 15)

% Open the video writer object
open(writerObj);

% Setup the figure for plotting each frame
hFig = figure; % Create a new figure window
set(hFig, 'Position', [100 100 800 600]); % Optional: Set figure size [left bottom width height]
hAx = gca; % Get the current axes handle for consistent plotting
colormap(hFig, 'gray'); % Set colormap to grayscale for clear visualization of intensity

fprintf('Creating movie "%s"... This may take a few moments.\n', outputVideoFile);

% --- Summation and Movie Frame Capture Loop ---
% For a vertical line impulse, only the k_y=0 (first row) of the 2D DFT coefficients
% `DFT_coefficients_2D` will be non-zero.
% Thus, we only need to loop through the x-frequency components (k_x or 'fx_val').
% The loop goes from 0 up to N-1 for fx_val.

frames_per_harmonic_step = 1; % Capture a frame for every harmonic added

for fx_val = 0:(N-1) % Loop through x-frequency components (k_x index)

    % Get the DFT coefficient for the current x-frequency and y-frequency = 0.
    % MATLAB uses 1-based indexing, so k_freq=0 is index 1.
    % DFT_coefficients_2D(k_x_index + 1, k_y_index + 1)
    current_DFT_coeff = DFT_coefficients_2D(fx_val + 1, 1); 

    % Calculate the current 2D harmonic component using the complex DFT coefficient
    % and the complex exponential. This component is applied across the entire 2D grid.
    % Note the use of '.*' for element-wise multiplication.
    current_harmonic_component = current_DFT_coeff .* exp(1j * 2 * pi * fx_val * n_x_grid / N);
    
    % Add the current harmonic component to the accumulated sum
    accumulated_harmonics_2D = accumulated_harmonics_2D + current_harmonic_component;
    
    % --- Plotting and Frame Capture for the current frame ---
    % Capture a frame every 'frames_per_harmonic_step' or for the very last harmonic.
    if mod(fx_val, frames_per_harmonic_step) == 0 || fx_val == (N-1)
        % Apply the overall 1/(N*N) scaling factor required for a 2D Inverse DFT.
        % We take the real part because the original impulse line is real;
        % any tiny imaginary parts are due to floating-point precision errors.
        current_frame_data = real(accumulated_harmonics_2D / (N*N)); 
        
        % The impulse line is already correctly positioned by the IDFT sum
        % (which handles the shift from its DFT coefficients).
        % So, no additional circshift is needed here for plotting.

        imagesc(hAx, x_spatial, y_spatial, current_frame_data); % Display the 2D image
        
        % Set consistent axis properties for stable visualization in the movie
        axis(hAx, 'xy', 'equal', 'tight'); % 'xy' for standard image orientation, 'equal' aspect ratio, 'tight' limits
        colorbar(hAx); % Show colorbar
        
        % Set consistent colorbar limits across all frames.
        % A unit impulse peak is 1. Sidelobes can go slightly negative (Gibbs phenomenon).
        caxis(hAx, [-0.2 1.1]); % Adjusted to accommodate slight undershoots and overshoot

        % Update the plot title to show current progress (number of harmonics added)
        title(hAx, sprintf('Summing 2D Harmonics: Frequencies Added = %d (fx from 0 to %d)', fx_val + 1, fx_val));
        xlabel(hAx, 'Spatial X-coordinate (radians)');
        ylabel(hAx, 'Spatial Y-coordinate (radians)');
        
        drawnow; % Force MATLAB to update the figure window immediately

        % Capture the current figure as a frame
        frame = getframe(hFig);
        
        % Write the captured frame to the video file
        writeVideo(writerObj, frame);
    end
end

% --- Finalize Movie ---
close(writerObj); % Close the video writer object
fprintf('Movie creation complete. File saved as: %s\n', outputVideoFile);

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
caxis([-0.2 1.1]); % Match movie's colorbar limits

fprintf('Maximum value of final reconstructed image: %f\n', max(final_impulse_image(:)));
fprintf('Minimum value of final reconstructed image (excluding peak): %f\n', min(final_impulse_image(final_impulse_image < 0.5)));