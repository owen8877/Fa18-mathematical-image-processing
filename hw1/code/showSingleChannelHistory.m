clear; % clc

cg_non_fast = load('history/butterfly_CG_non_fast.mat');
minres_non_fast = load('history/butterfly_MinRes_non_fast.mat');
minres_fast = load('history/butterfly_MinRes_fast.mat');

figure;
s1 = subplot(1, 2, 1);
semilogy(cg_non_fast.rel_err_arr, 'rx-'); hold(s1, 'on')
semilogy(minres_non_fast.rel_err_arr, 'bx-')
semilogy(minres_fast.rel_err_arr, 'bd-')
legend('CG, non fast', 'minRes, non fast', 'minRes, fast')
title('Relative error')
ylabel('||Wu_k-d_k||_2/||f||_2')
xlabel('iteration')
grid on

s2 = subplot(1, 2, 2);
plot(cg_non_fast.psnr_arr(1:36), 'rx-'); hold(s2, 'on')
plot(minres_non_fast.psnr_arr(1:36), 'bx-')
plot(minres_fast.psnr_arr(1:36), 'bd-')
legend('CG, non fast', 'minRes, non fast', 'minRes, fast')
ylabel('psnr')
xlabel('iteration')