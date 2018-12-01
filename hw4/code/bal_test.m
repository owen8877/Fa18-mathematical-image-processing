%% Generate a blurred and noised building picture
options = struct();
options.blur = true;
options.blur_only = true;

image_path = 'image/source/building.jpeg';
lambda_weight = 1;
kernel_size = 15;
gaussian_sigma = 1.5;
result_image_path = 'image/blurred/building.png';

main(image_path, lambda_weight, kernel_size, gaussian_sigma, result_image_path, options);

%% Deblur and Denoise the building picture
% all channels: 73.026910s
options = struct();
options.blur = false;
options.show = true;
options.channels = 3;
options.truth_path = 'image/source/building.jpeg';
options.solver_ADMM = 'balanced';
options.ADMM_outInt = 15;
options.ADMM_save_history = 'history/building_bal_test.mat';
options.ADMM_tor = 5e-4;
options.ADMM_kappa = 0.1;
options.ADMM_L = 1;

image_path = 'image/blurred/building.png';
lambda_weight = 0.1;
kernel_size = 15;
gaussian_sigma = 1.5;
result_image_path = 'image/result/building_bal_test.png';

main(image_path, lambda_weight, kernel_size, gaussian_sigma, result_image_path, options);
