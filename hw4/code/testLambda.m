% innerTest('butterfly', 'bmp', 8e-7, 0.01) % 332.087760s
% innerTest('butterfly', 'bmp', 2e-6, 0.1) % 545.307638s
% innerTest('butterfly', 'bmp', 8e-6, 1) % 267.742360s
% innerTest('butterfly', 'bmp', 4e-5, 10) % 118.545136s

figure(50);
imshow([ ...
    imread('image/source/butterfly.bmp') ...
    imread('image/result/butterfly_lambda_0.01.png') ...
    imread('image/result/butterfly_lambda_0.1.png') ...
    imread('image/result/butterfly_lambda_1.png') ...
    imread('image/result/butterfly_lambda_10.png') ...
])

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
    options = struct();
    options.blur = false;
    options.show = true;
    options.channels = 3;
    options.truth_path = sprintf('image/source/%s.%s', p1name, p2name);
    options.ADMM_fast = true;
    options.ADMM_minRes = false;
    options.ADMM_outInt = 15;
%     options.ADMM_save_history = sprintf('history/%s_MinRes_fast_3_lambda_%s.mat', p1name, num2str(lambda));
    options.ADMM_tor = criterion;

    image_path = sprintf('image/blurred/%s.png', p1name);
    lambda_weight = lambda;
    kernel_size = 15;
    gaussian_sigma = 1.5;
    result_image_path = sprintf('image/result/%s_lambda_%s.png', p1name, num2str(lambda));

    main(image_path, lambda_weight, kernel_size, gaussian_sigma, result_image_path, options);
end