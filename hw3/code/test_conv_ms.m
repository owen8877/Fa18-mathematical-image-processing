clear; %clc

%% europe
image_path = 'image/source/europe_small.jpg';
result_image_path = 'image/result/europe_small.jpg';

options.admm_max_itr = 24;
options.admm_refreshN = 3;
options.admm_mu = 1e2;

options.solver_clip_count = 8;
options.solver_shadow = 'positive';
options.show = true;
options.solver = 'conv_ms';

%% bag
% image_path = 'image/source/bag.jpg';
% result_image_path = 'image/result/bag.jpg';
% 
% options.admm_max_itr = 8;
% options.admm_refreshN = 1;
% options.admm_mu = 1e2;
% 
% options.solver_clip_count = 8;
% options.solver_shadow = 'positive';
% options.show = true;
% options.solver = 'conv_ms';

%% noised_geometry
% image_path = 'image/source/noised_geometry.jpg';
% result_image_path = 'image/result/noised_geometry.jpg';
% 
% options.admm_max_itr = 8;
% options.admm_refreshN = 1;
% options.admm_mu = 1e3;
% 
% options.solver_clip_count = 8;
% options.solver_shadow = 'positive';
% options.show = true;
% options.solver = 'conv_ms';

%% meme
% image_path = 'image/source/meme.jpg';
% result_image_path = 'image/result/meme.jpg';
% 
% options.admm_max_itr = 8;
% options.admm_refreshN = 1;
% options.admm_mu = 1e3;
% 
% options.solver_clip_count = 8;
% options.solver_shadow = 'positive';
% options.show = true;
% options.solver = 'conv_ms';

main(image_path, result_image_path, options);