clear; %clc

%% bag
% image_path = 'image/source/bag.jpg';
% result_image_path = 'image/result/bag.jpg';
% options.pde_maxTime = 135;
% options.pde_dt = 5e-2;
% options.pde_boundary_condition = 'extrap';
% options.pde_reinitStep = 10;
% options.pde_reinitN = 10;
% options.pde_alpha = 1.5;
% options.pde_mu = 1;
% options.pde_initial_offset = 0.05;
% 
% options.solver_clip_count = 8;
% options.solver_shadow = 'zero';
% options.solver_save_file = 'saves/bag.mat';
% options.show = false;

%% bag blurred
% image_path = 'image/source/bag.jpg';
% result_image_path = 'image/result/bag.jpg';
% options.noise_level = 0.00;
% options.blur = true;
% options.gaussian_sigma = 1;
% 
% options.pde_maxTime = 135;
% options.pde_dt = 5e-2;
% options.pde_boundary_condition = 'extrap';
% options.pde_reinitStep = 10;
% options.pde_reinitN = 10;
% options.pde_alpha = 1.5;
% options.pde_mu = 1;
% options.pde_initial_offset = 0.05;
% 
% options.solver_clip_count = 8;
% options.solver_shadow = 'zero';
% % options.solver_save_file = 'saves/bag.mat';
% options.show = false;

%% bag blurred+noise
% image_path = 'image/source/bag.jpg';
% result_image_path = 'image/result/bag.jpg';
% options.noise_level = 0.01;
% options.blur = true;
% options.gaussian_sigma = 1;
% 
% options.pde_maxTime = 135;
% options.pde_dt = 5e-2;
% options.pde_boundary_condition = 'extrap';
% options.pde_reinitStep = 10;
% options.pde_reinitN = 10;
% options.pde_alpha = 1.5;
% options.pde_mu = 1;
% options.pde_initial_offset = 0.05;
% 
% options.solver_clip_count = 8;
% options.solver_shadow = 'zero';
% % options.solver_save_file = 'saves/bag.mat';
% options.show = false;

%% chess
% image_path = 'image/source/DSCN1464.jpg';
% result_image_path = 'image/result/DSCN1464.jpg';
% options.pde_maxTime = 300;
% options.pde_dt = 5e-2;
% options.pde_boundary_condition = 'extrap';
% options.pde_reinitStep = 10;
% options.pde_reinitN = 10;
% options.pde_alpha = 1.5;
% options.pde_mu = 1;
% options.pde_initial_offset = 0.05;
% 
% options.solver_clip_count = 8;
% options.solver_shadow = 'zero';
% % options.solver_save_file = 'saves/DSCN1464.mat';
% options.show = false;

%% meme
% image_path = 'image/source/meme.jpg';
% result_image_path = 'image/result/meme.jpg';

% options.pde_maxTime = 720;
% options.pde_dt = 5e-2;
% options.pde_boundary_condition = 'extrap';
% options.pde_reinitStep = 15;
% options.pde_reinitN = 10;
% options.pde_alpha = 5;
% options.pde_mu = 10;
% options.pde_initial_offset = 0.01;

% options.pde_maxTime = 320;
% options.pde_dt = 5e-2;
% options.pde_boundary_condition = 'extrap';
% options.pde_reinitStep = 15;
% options.pde_reinitN = 10;
% options.pde_alpha = 2;
% options.pde_mu = 1;
% options.pde_initial_offset = 0.01;

% options.pde_maxTime = 120;
% options.pde_dt = 5e-2;
% options.pde_boundary_condition = 'extrap';
% options.pde_reinitStep = 15;
% options.pde_reinitN = 10;
% options.pde_alpha = 5;
% options.pde_mu = 1;
% options.pde_initial_offset = 0.01;

% options.solver_clip_count = 8;
% options.solver_shadow = 'zero';
% options.solver_save_file = 'saves/meme.mat';
% options.show = true;

main(image_path, result_image_path, options);