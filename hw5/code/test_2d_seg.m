clear; %clc

%%
% source = 'image/source/noised_geometry.jpg';
% result = 'image/result/noised_geometry.jpg';
% options.ADMM_MaxItr = 150;
% options.model_alpha = 10;
% options.model_sigma = 50;

%%
% source = 'image/source/chess.jpg';
% result = 'image/result/chess.jpg';
% options.ADMM_MaxItr = 150;
% options.ADMM_outInt = 5;
% options.model_alpha = 10;
% options.model_sigma = 50;

%%
% source = 'image/source/meme.jpg';
% result = 'image/result/meme.jpg';
% options.ADMM_MaxItr = 150;
% options.ADMM_outInt = 5;
% options.model_alpha = 10;
% options.model_sigma = 100;

%%
% source = 'image/source/bag.jpg';
% result = 'image/result/bag.jpg';
% options.ADMM_MaxItr = 100;
% options.ADMM_tor = 1e-8;
% options.ADMM_outInt = 5;
% options.model_alpha = 0.1;
% options.model_sigma = 50;
% 
% options.noise_level = 0.1;
% options.blur = true;
% options.gaussian_sigma = 0.1;

%%
source = 'image/source/aircraft.jpg';
result = 'image/result/aircraft.jpg';
options.ADMM_MaxItr = 3000;
options.ADMM_outInt = 5;
options.model_alpha = 10;
options.model_sigma = 100;

options.model_init_power = 2;
options.noise_level = 0.02;
options.blur = true;
options.gaussian_sigma = 0.1;

%%
options.show = true;
main(source, result, options);