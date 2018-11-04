innerTest('butterfly', 'bmp', 2e-5) % 204.964774s
% innerTest('comic', 'jpeg', 2e-5) % 88.514101s
% innerTest('bird', 'bmp', 9e-6) % 619.479077s
% innerTest('building', 'jpeg', 5e-6) % 424.937297s

function innerTest(p1name, p2name, criterion)
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
    options.ADMM_save_history = sprintf('history/%s_MinRes_fast_3.mat', p1name);
    options.ADMM_tor = criterion;

    image_path = sprintf('image/blurred/%s.png', p1name);
    lambda_weight = 1;
    kernel_size = 15;
    gaussian_sigma = 1.5;
    result_image_path = sprintf('image/result/%s.png', p1name);

    main(image_path, lambda_weight, kernel_size, gaussian_sigma, result_image_path, options);
end