% innerTest('butterfly', 'bmp', 6e-6) % 328.310248s
% innerTest('comic', 'jpeg', 8e-6) % 192.324805s
% innerTest('bird', 'bmp', 9e-6) % 262.707029s
% innerTest('building', 'jpeg', 5e-6) % 209.572187s

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
    % CG, fast, all channels
    options = struct();
    options.blur = false;
    options.show = true;
    options.channels = 3;
    options.truth_path = sprintf('image/source/%s.%s', p1name, p2name);
    options.ADMM_fast = true;
    options.ADMM_minRes = false;
    options.ADMM_outInt = 15;
    options.ADMM_save_history = sprintf('history/%s_CG_fast_3.mat', p1name);
    options.ADMM_tor = criterion;
    options.TV_result = sprintf('../../hw1/code/image/result/%s.png', p1name);

    image_path = sprintf('image/blurred/%s.png', p1name);
    lambda_weight = 1;
    kernel_size = 15;
    gaussian_sigma = 1.5;
    result_image_path = sprintf('image/result/%s_3c.png', p1name);

    main(image_path, lambda_weight, kernel_size, gaussian_sigma, result_image_path, options);
end