%% Generate a blurred and noised butterfly picture
% options = struct();
% options.blur = true;
% options.blur_only = true;
% 
% image_path = 'image/source/butterfly.bmp';
% lambda_weight = 1;
% kernel_size = 15;
% gaussian_sigma = 1.5;
% result_image_path = 'image/blurred/butterfly.png';
% 
% main(image_path, lambda_weight, kernel_size, gaussian_sigma, result_image_path, options);

%% Deblur and Denoise the butterfly picture
% CG, non-fast, single channel: 73.026910s
options = struct();
options.blur = false;
options.show = true;
options.channels = 1;
options.truth_path = 'image/source/butterfly.bmp';
options.ADMM_fast = false;
options.ADMM_minRes = false;
options.ADMM_outInt = 15;
options.ADMM_save_history = 'history/butterfly_CG_non_fast.mat';
options.ADMM_tor = 8e-6;

image_path = 'image/blurred/butterfly.png';
lambda_weight = 1;
kernel_size = 15;
gaussian_sigma = 1.5;
result_image_path = 'image/result/butterfly_red_CG_non_fast.png';

main(image_path, lambda_weight, kernel_size, gaussian_sigma, result_image_path, options);

%% Deblur and Denoise the butterfly picture
% CG, fast, single channel: 74.282185s
options = struct();
options.blur = false;
options.show = true;
options.channels = 1;
options.truth_path = 'image/source/butterfly.bmp';
options.ADMM_fast = true;
options.ADMM_minRes = false;
options.ADMM_outInt = 15;
options.ADMM_save_history = 'history/butterfly_CG_fast.mat';
options.ADMM_tor = 8e-6;

image_path = 'image/blurred/butterfly.png';
lambda_weight = 1;
kernel_size = 15;
gaussian_sigma = 1.5;
result_image_path = 'image/result/butterfly_red_CG_fast.png';

main(image_path, lambda_weight, kernel_size, gaussian_sigma, result_image_path, options);

%% Deblur and Denoise the butterfly picture
% minRes, non-fast, single channel: 94.988417s
options = struct();
options.blur = false;
options.show = true;
options.channels = 1;
options.truth_path = 'image/source/butterfly.bmp';
options.ADMM_fast = false;
options.ADMM_minRes = true;
options.ADMM_outInt = 15;
options.ADMM_save_history = 'history/butterfly_MinRes_non_fast.mat';
options.ADMM_tor = 8e-6;

image_path = 'image/blurred/butterfly.png';
lambda_weight = 1;
kernel_size = 15;
gaussian_sigma = 1.5;
result_image_path = 'image/result/butterfly_red_minRes_non_fast.png';

main(image_path, lambda_weight, kernel_size, gaussian_sigma, result_image_path, options);

%% Deblur and Denoise the butterfly picture
% minRes, fast, single channel: 98.823375s
options = struct();
options.blur = false;
options.show = true;
options.channels = 1;
options.truth_path = 'image/source/butterfly.bmp';
options.ADMM_fast = true;
options.ADMM_minRes = true;
options.ADMM_outInt = 15;
options.ADMM_save_history = 'history/butterfly_MinRes_fast.mat';
options.ADMM_tor = 8e-6;

image_path = 'image/blurred/butterfly.png';
lambda_weight = 1;
kernel_size = 15;
gaussian_sigma = 1.5;
result_image_path = 'image/result/butterfly_red_minRes_fast.png';

main(image_path, lambda_weight, kernel_size, gaussian_sigma, result_image_path, options);