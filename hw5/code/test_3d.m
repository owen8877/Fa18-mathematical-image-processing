clear; %clc

%%
source = 'data/lucy.mat';
options.ADMM_MaxItr = 1000;
options.model_alpha = 500;
options.ADMM_mu = 0.04;

options.show = true;
options.result_path = 'result/lucy.mat';

main_3d(source, options);
set(gcf, 'Position', [429 61 339 660]);