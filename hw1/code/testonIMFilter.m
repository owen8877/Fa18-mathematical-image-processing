clear; %clc
addpath lib

% image_path = 'image/Wall-152-grayscale.jpg';
% kernel_size = 15;
% gaussian_sigma = 1.5;
% kernel = fspecial('gaussian', [1, 1] * kernel_size, gaussian_sigma);
% f = double(imread(image_path));

kernel_size = 3;
gaussian_sigma = 1;
kernel = fspecial('gaussian', [1, 1] * kernel_size, gaussian_sigma);
f = rand(6, 6);

f1 = imfilter(f, kernel);
f2 = reshape(imfOperator(size(f), kernel, struct('padding', 'omit')) * reshape(f, numel(f), 1), ...
    size(f, 1), size(f, 2));