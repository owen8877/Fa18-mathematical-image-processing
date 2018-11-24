clear; %clc

image_path = 'image/source/meme.jpg';
result_image_path = 'image/result/meme.jpg';

% % bag
% options.pde_maxTime = 5;
% options.pde_dt = 1e-2;
% options.pde_boundary_condition = 'extrap';
% options.pde_reinitStep = 100;
% options.pde_reinitN = 25;
% options.pde_alpha = 0.1;

% meme
options.pde_maxTime = 20;
options.pde_dt = 2e-2;
options.pde_boundary_condition = 'extrap';
options.pde_reinitStep = 10;
options.pde_reinitN = 10;
options.pde_alpha = 5e-3;
options.pde_initial_offset = 0.01;

options.solver_shadow = 'zero';
options.solver_save_file = 'saves/meme.mat';
options.show = false;

main(image_path, result_image_path, options);