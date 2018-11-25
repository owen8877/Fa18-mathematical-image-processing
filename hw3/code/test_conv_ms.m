clear; %clc

%% bag
image_path = 'image/source/bag.jpg';
result_image_path = 'image/result/bag.jpg';

options.pde_maxTime = 135;
options.pde_dt = 5e-2;
options.pde_boundary_condition = 'extrap';
options.pde_reinitStep = 10;
options.pde_reinitN = 10;
options.pde_alpha = 1.5;
options.pde_mu = 1;
options.pde_initial_offset = 0.05;

options.solver_clip_count = 8;
options.solver_shadow = 'zero';
options.solver_save_file = 'saves/bag.mat';
options.show = false;
options.solver = 'conv_ms';

main(image_path, result_image_path, options);