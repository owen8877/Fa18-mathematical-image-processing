addpath lib
options = struct();

%% No noise; building
% options.noise_level = 0.00;
% options.pde_maxTime = 0.06;
% options.pde_dt = 0.005;
% options.pde_lambda = 0.00;
% options.pde_use_normald2 = true;
% options.three_compare = true;
% options.solver_clip_count = 4;
% innerTest('building', 'jpeg', options)

%% No noise; comic
% options.noise_level = 0.00;
% options.pde_maxTime = 0.05;
% options.pde_dt = 0.005;
% options.pde_lambda = 0.00;
% options.pde_use_normald2 = true;
% options.three_compare = true;
% options.solver_clip_count = 4;
% innerTest('comic', 'jpeg', options)

%% No noise; butterfly
% options.noise_level = 0.00;
% options.pde_maxTime = 0.06;
% options.pde_dt = 0.005;
% options.pde_lambda = 0.00;
% options.pde_use_normald2 = true;
% options.three_compare = true;
% options.solver_clip_count = 4;
% innerTest('butterfly', 'bmp', options)

%% No noise; bird
% options.noise_level = 0.00;
% options.pde_maxTime = 0.06;
% options.pde_dt = 0.005;
% options.pde_lambda = 0.00;
% options.pde_use_normald2 = true;
% options.three_compare = true;
% options.solver_clip_count = 4;
% innerTest('bird', 'bmp', options)

%% No noise; comic - normald2
% options.noise_level = 0.00;
% options.pde_maxTime = 0.06;
% options.pde_dt = 0.005;
% options.pde_lambda = 0.00;
% options.pde_use_normald2 = true;
% options.solver_clip_count = 6;
% options.clip_save = true;
% innerTest('comic', 'jpeg', options)

%% No noise; comic - no normald2
% options.noise_level = 0.00;
% options.pde_maxTime = 0.06;
% options.pde_dt = 0.005;
% options.pde_lambda = 0.00;
% options.pde_use_normald2 = false;
% options.solver_clip_count = 6;
% options.clip_save = true;
% innerTest('comic', 'jpeg', options)

%% Noise 1%; comic - normald2
% options.noise_level = 0.01;
% options.pde_maxTime = 0.06;
% options.pde_dt = 0.005;
% options.pde_lambda = 0.00;
% options.pde_use_normald2 = true;
% options.solver_clip_count = 6;
% options.clip_save = true;
% innerTest('comic', 'jpeg', options)

%% Noise 2%; comic - normald2
% options.noise_level = 0.02;
% options.pde_maxTime = 0.06;
% options.pde_dt = 0.005;
% options.pde_lambda = 0.00;
% options.pde_use_normald2 = true;
% options.solver_clip_count = 6;
% options.clip_save = true;
% innerTest('comic', 'jpeg', options)

%% Noise 4%; comic - normald2
% options.noise_level = 0.04;
% options.pde_maxTime = 0.06;
% options.pde_dt = 0.005;
% options.pde_lambda = 0.00;
% options.pde_use_normald2 = true;
% options.solver_clip_count = 6;
% options.clip_save = true;
% innerTest('comic', 'jpeg', options)

%% Noise 4%; comic - normald2; blurring
options.noise_level = 0.04;
options.pde_maxTime = 0.06;
options.pde_dt = 0.005;
options.pde_lambda = 8;
options.pde_use_normald2 = true;
options.solver_clip_count = 6;
options.clip_save = true;
innerTest('comic', 'jpeg', options)

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
    result_image_path = sprintf('image/blurred/sf-%s.png', p1name);

    main(image_path, lambda_weight, kernel_size, gaussian_sigma, result_image_path, options);

    %% Denoise and Deblur the picture by shock filter
    options = options_ori;
    options.blur = false;
    options.show = true;
    options.channels = 3;
    options.truth_path = sprintf('image/source/%s.%s', p1name, p2name);
    options.solver = 'shockfilter';

    options.pde_gradient_lb = 10;
    
    if default(options, 'clip_save', false)
        options.clip_save = sprintf('../doc/plot/sf-%s-%s-nd2%d-lambda%s.png', ...
            p1name, num2str(options.noise_level), default(options, 'pde_use_normald2', false), ...
            num2str(default(options, 'pde_lambda', 0)));
    end
    
    if default(options, 'three_compare', false)
        options.three_compare = sprintf('../doc/plot/sf-result-%s-%s-nd2%d-lambda%s.png', ...
            p1name, num2str(options.noise_level), default(options, 'pde_use_normald2', false), ...
            num2str(default(options, 'pde_lambda', 0)));
    end

    image_path = sprintf('image/blurred/sf-%s.png', p1name);
    lambda_weight = 1;
    kernel_size = 1;
    gaussian_sigma = 1;
    result_image_path = sprintf('image/result/sf-%s.png', p1name);

    main(image_path, lambda_weight, kernel_size, gaussian_sigma, result_image_path, options);
end