clear; % clc

p1name = 'Wall_834'; p2name = 'png';

lambda = 0.5;
criterion = 5e-6;

stage = 2;

%% Generate a blurred picture
if stage == 1
options = struct();
options.blur = true;
options.blur_only = true;
options.noise_level = 0.5e-2;
options.rng = 42;
options.boundary_cond = 'replicate';

image_path = sprintf('image/source/%s.%s', p1name, p2name);
kernel_name = 'syn9';
kernel_path = sprintf('image/kernel/%s.bmp', kernel_name);
lambda_weight = lambda;
result_image_path = sprintf('image/blurred/%s.png', p1name);

main(image_path, lambda_weight, kernel_path, result_image_path, options);
end
%% Deblur and Denoise the picture
if stage == 2
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
options.ADMM_MaxItr = 1000;

kernel_name = 'guess';
image_path = sprintf('image/blurred/%s.png', p1name);
kernel_path = sprintf('image/kernel/%s.bmp', kernel_name);
options.diff_operator = sprintf('image/kernel/%s-diff.mat', kernel_name);
lambda_weight = lambda;
result_image_path = sprintf('image/result/%s_lambda_%s.png', p1name, num2str(lambda));

main(image_path, lambda_weight, kernel_path, result_image_path, options);
end