% innerTest('butterfly', 'bmp', 8e-6, 'haar') % 194.262046s
% innerTest('butterfly', 'bmp', 8e-6, 'pw-linear') % 267.742360s
% innerTest('butterfly', 'bmp', 8e-6, 'pw-cubic') % 555.335289s

figure(51);
imshow([ ...
    imread('image/source/butterfly.bmp') ...
    imread('image/result/butterfly_frame_haar.png') ...
    imread('image/result/butterfly_lambda_1.png') ...
    imread('image/result/butterfly_frame_pw-cubic.png') ...
])

function innerTest(p1name, p2name, criterion, frame)
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
    options.wavelet_frame = frame;

    image_path = sprintf('image/blurred/%s.png', p1name);
    lambda_weight = 1;
    kernel_size = 15;
    gaussian_sigma = 1.5;
    result_image_path = sprintf('image/result/%s_frame_%s.png', p1name, frame);

    main(image_path, lambda_weight, kernel_size, gaussian_sigma, result_image_path, options);
end