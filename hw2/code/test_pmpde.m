addpath lib
options = struct();

%% Buidling - General Test
% options.noise_level = 0.01;
% options.pde_maxTime = 20;
% options.pde_dt = 0.4;
% options.pde_K = 10;
% options.three_compare = true;
% innerTest('building', 'jpeg', options)

%% Comic - General Test
% options.noise_level = 0.01;
% options.pde_maxTime = 5;
% options.pde_dt = 0.1;
% options.pde_K = 100;
% options.three_compare = true;
% innerTest('comic', 'jpeg', options)

%% Butterfly - General Test
% options.noise_level = 0.01;
% options.pde_maxTime = 12;
% options.pde_dt = 0.2;
% options.pde_K = 50;
% options.three_compare = true;
% innerTest('butterfly', 'bmp', options)

%% Bird - General Test
% options.noise_level = 0.01;
% options.pde_maxTime = 16;
% options.pde_dt = 0.2;
% options.pde_K = 20;
% options.three_compare = true;
% innerTest('bird', 'bmp', options)

%% Building - Long T Test
options.noise_level = 0.01;
options.pde_maxTime = 40;
options.pde_dt = 0.4;
options.pde_K = 10;
options.clip_save = true;
innerTest('building', 'jpeg', options)

%% Building - Long T Test
% options.noise_level = 0.02;
% options.pde_maxTime = 40;
% options.pde_dt = 0.4;
% options.pde_K = 10;
% options.clip_save = true;
% innerTest('building', 'jpeg', options)

%%
function innerTest(p1name, p2name, options_ori)
    %% Generate a noised picture
    options = struct();
    options.blur = true;
    options.blur_only = true;
    options.noise_level = default(options_ori, 'noise_level', 0.05);

    image_path = sprintf('image/source/%s.%s', p1name, p2name);
    lambda_weight = 1;
    kernel_size = 15;
    gaussian_sigma = 1.5;
    result_image_path = sprintf('image/blurred/pm-%s.png', p1name);

    main(image_path, lambda_weight, kernel_size, gaussian_sigma, result_image_path, options);

    %% Denoise and Deblur the picture by pm pde
    options = options_ori;
    options.blur = false;
    options.show = true;
    options.channels = 3;
    options.truth_path = sprintf('image/source/%s.%s', p1name, p2name);
    options.solver = 'pmpde';
    
    options.pde_gradient_lb = 10;
    options.solver_clip_count = 4;
    
    if default(options, 'clip_save', false)
        options.clip_save = sprintf('../doc/plot/pm-%s-%s.png', p1name, num2str(options.noise_level));
    end
    
    if default(options, 'three_compare', false)
        options.three_compare = sprintf('../doc/plot/pm-result-%s-%s.png', p1name, num2str(options.noise_level));
    end

    image_path = sprintf('image/blurred/pm-%s.png', p1name);
    lambda_weight = 1;
    kernel_size = 1;
    gaussian_sigma = 1;
    result_image_path = sprintf('image/result/pm-%s.png', p1name);

    main(image_path, lambda_weight, kernel_size, gaussian_sigma, result_image_path, options);
end