clear; %clc

kernel_size = 15;
gaussian_sigma = 0.7;
kernel = fspecial('gaussian', [1, 1] * kernel_size, gaussian_sigma);

imwrite(kernel, sprintf('../image/kernel/gaussian-%dx-%.2f.bmp', kernel_size, gaussian_sigma))