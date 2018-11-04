innerTest('butterfly', 'bmp', 3e-5, 2.5) % 206.137799s
% innerTest('butterfly', 'bmp', 1.6e-5, 2.0) % 366.724800s
% innerTest('butterfly', 'bmp', 8e-6, 1.5) % 520.089750s
% innerTest('butterfly', 'bmp', 4e-6, 1.0) % 728.870698s
% innerTest('butterfly', 'bmp', 2e-6, 0.5) % 64.702542s

function innerTest(p1name, p2name, criterion, gs)
    %% Generate a blurred picture
    options = struct();
    options.blur = true;
    options.blur_only = true;

    image_path = sprintf('image/source/%s.%s', p1name, p2name);
    lambda_weight = 1;
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
    options.ADMM_save_history = sprintf('history/%s_MinRes_fast_3_gs_%s.mat', p1name, num2str(gs));
    options.ADMM_tor = criterion;

    image_path = sprintf('image/blurred/%s.png', p1name);
    lambda_weight = 1;
    kernel_size = 15;
    gaussian_sigma = gs;
    result_image_path = sprintf('image/result/%s_gs_%s.png', p1name, num2str(gs));

    main(image_path, lambda_weight, kernel_size, gaussian_sigma, result_image_path, options);
end