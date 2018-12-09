clear; %clc

%%
source = 'data_2d/new.mat';
options.ADMM_MaxItr = 300;
options.ADMM_tor = 5e-4;
options.model_alpha = 0.3;
options.ADMM_mu = 0.01;
options.wavelet_frame = 'pw-cubic';
options.wavelet_level = 1;

options.show = true;
options.result_path = 'result/new.mat';

main_surf_2d(source, options);
% set(gcf, 'Position', [429 61 339 660]);