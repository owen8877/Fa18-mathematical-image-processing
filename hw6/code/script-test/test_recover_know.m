clear; % clc

p1name = 'circle'; p2name = 'jpeg';
% kernel_name = 'gaussian-15x-0.70';
kernel_name = 'syn2';
lambda = 0.5;
criterion = 3e-6;

%% Generate a blurred picture
options = struct();
options.blur = true;
options.blur_only = true;
options.noise_level = 0e-3;
options.boundary_cond = 'replicate';

image_path = sprintf('image/source/%s.%s', p1name, p2name);
kernel_path = sprintf('image/kernel/%s.bmp', kernel_name);
lambda_weight = lambda;
result_image_path = sprintf('image/blurred/%s.png', p1name);

main(image_path, lambda_weight, kernel_path, result_image_path, options);

%% Deblur and Denoise the picture
options = struct();
options.blur = false;
options.show = true;
options.channels = 3;
options.boundary_cond = 'replicate';
options.truth_path = sprintf('image/source/%s.%s', p1name, p2name);

options.ADMM_CG0 = 3e-2;
options.ADMM_fast = true;
options.ADMM_minRes = false;
options.ADMM_outInt = 15;
options.ADMM_tor = criterion;

image_path = sprintf('image/blurred/%s.png', p1name);
kernel_path = sprintf('image/kernel/%s.bmp', kernel_name);
options.diff_operator = sprintf('image/kernel/%s-diff.mat', kernel_name);
lambda_weight = lambda;
result_image_path = sprintf('image/result/%s_lambda_%s.png', p1name, num2str(lambda));

main(image_path, lambda_weight, kernel_path, result_image_path, options);