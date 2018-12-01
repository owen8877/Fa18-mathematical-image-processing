clear; % clc

cg_non_fast = load('history/butterfly_CG_non_fast.mat');
cg_fast = load('history/butterfly_CG_fast.mat');
minres_non_fast = load('history/butterfly_MinRes_non_fast.mat');
minres_fast = load('history/butterfly_MinRes_fast.mat');

figure;
s1 = subplot(1, 2, 1);
semilogy(cg_non_fast.rel_err_arr, 'r-'); hold(s1, 'on')
semilogy(cg_fast.rel_err_arr, 'r-.');
semilogy(minres_non_fast.rel_err_arr, 'b-')
semilogy(minres_fast.rel_err_arr, 'b-.')
legend('CG, non fast', 'CG, fast', 'minRes, non fast', 'minRes, fast')
title('Relative error')
ylabel('||Wu_k-d_k||_2/||f||_2')
xlabel('iteration')
grid on

s2 = subplot(1, 2, 2);
plot(cg_non_fast.psnr_arr(1:252), 'r-'); hold(s2, 'on')
plot(cg_fast.psnr_arr(1:252), 'r-.');
plot(minres_non_fast.psnr_arr(1:252), 'b-')
plot(minres_fast.psnr_arr(1:252), 'b-.')
legend('CG, non fast', 'CG, fast', 'minRes, non fast', 'minRes, fast')
ylabel('psnr')
xlabel('iteration')
grid on

%%
cg_non_fast_img = imread('image/result/butterfly_red_CG_non_fast.png');
cg_fast_img = imread('image/result/butterfly_red_CG_fast.png');
minres_non_fast_img = imread('image/result/butterfly_red_minRes_non_fast.png');
minres_fast_img = imread('image/result/butterfly_red_minRes_fast.png');

figure();
imshow([cg_non_fast_img(:, :, 1) cg_fast_img(:, :, 1) minres_non_fast_img(:, :, 1) minres_fast_img(:, :, 1)]); title('CG/minRes, non-fast and fast')