% innerTest('building', 'jpeg', 4e-7, 0.01) % 247.053777s
% innerTest('building', 'jpeg', 2e-6, 0.1) % 206.333901s
% innerTest('building', 'jpeg', 8e-6, 1) % 247.505230s
innerTest('building', 'jpeg', 4e-5, 10) % 162.008077s

function innerTest(p1name, p2name, criterion, lambda)
    %% Generate a blurred picture
    options = struct();
    options.blur = true;
    options.blur_only = true;

    image_path = sprintf('image/source/%s.%s', p1name, p2name);
    lambda_weight = lambda;
    kernel_size = 15;
    gaussian_sigma = 1.5;
    result_image_path = sprintf('image/blurred/%s.png', p1name);

    main(image_path, lambda_weight, kernel_size, gaussian_sigma, result_image_path, options);

    %% Deblur and Denoise the picture
    % minRes, fast, all channels: 21.947201s
    options = struct();
    options.blur = false;
    options.show = true;
    options.channels = 3;
    options.truth_path = sprintf('image/source/%s.%s', p1name, p2name);
    options.ADMM_fast = true;
    options.ADMM_minRes = true;
    options.ADMM_outInt = 15;
    options.ADMM_save_history = sprintf('history/%s_MinRes_fast_3_lambda_%s.mat', p1name, num2str(lambda));
    options.ADMM_tor = criterion;

    image_path = sprintf('image/blurred/%s.png', p1name);
    lambda_weight = lambda;
    kernel_size = 15;
    gaussian_sigma = 1.5;
    result_image_path = sprintf('image/result/%s_lambda_%s.png', p1name, num2str(lambda));

    main(image_path, lambda_weight, kernel_size, gaussian_sigma, result_image_path, options);
end