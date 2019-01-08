function u = main(image_path, lambda_weight, kernel_path, result_image_path, options)
    addpath lib-ADMM lib-mat lib-util

    if nargin < 1
        image_path = 'image/source/comic.jpeg';
    end
    if nargin < 2
        lambda_weight = 1;
    end
    if nargin < 3
        kernel_path = 15;
    end
    if nargin < 4
        result_image_path = 'image/result/comic.jpeg';
    end
    if nargin < 5
        options = struct();
    end
    %
    addpath lib
    
    kernel = normalizeFirst(double(imread(kernel_path)));
    f_truth = double(imread(image_path));
        
    noise_sigma = max(max(max(f_truth))) * default(options, 'noise_level', 0.01);
    boundaryCondition = default(options, 'boundary_cond', 'replicate');
    blurFunc = @(x) imfilter(x, kernel, boundaryCondition);
    
    if default(options, 'blur', false)
        if isfield(options, 'rng_seed')
            rng(options.rng_seed)
        end
        f = blurFunc(f_truth) + noise_sigma*randn(size(f_truth));
        if default(options, 'blur_only', false)
            imwrite(uint8(f), result_image_path);
            return
        end
        if default(options, 'show', false)
%             figure; imshow(uint8([f_truth f])), title('Before recovered\newlineTruth - Blurred');
        end
    else
        f = f_truth;
        if isfield(options, 'truth_path')
            f_truth = double(imread(options.truth_path));
        end
        if default(options, 'show', false)
%             figure; imshow(uint8(f)), title('Blurred');
        end
    end
    
    tic
    ADMM_tor = default(options, 'ADMM_tor', 1e-5);
    channelN = size(f, 3);
    if isfield(options, 'saved_hint')
        u = load(sprintf('%s.%d.mat', image_path, options.saved_hint));
        f = u.f;
        u = u.u;
        if exist(sprintf('%s.%d.mat', image_path, options.saved_hint+1), 'file')
            error('Perhaps you have to increase!')
        end
        figure; imshow([f_truth f u]), title('Before recovered\newlineTruth - Blurred - Interstep');
    else
        u = zeros(size(f), 'uint8');
    end
    
    process_channels = min([channelN, default(options, 'channels', channelN)]);
    if numel(ADMM_tor) == 1
        ADMM_tor = ones(process_channels) * ADMM_tor;
    end
    for i = 1:process_channels
        options.ADMM_tor = ADMM_tor(i);
        options.ADMM_psnrFunc = @(x) psnr(x, f_truth(:, :, i));
%         options.ADMM_psnrFunc = @(x) psnr(x, f(:, :, i));
        fprintf('Processing the %d channel...\n', i);
        if isfield(options, 'saved_hint')
            options.ADMM_initial = double(u(:, :, i));
        end
        u(:, :, i) = uint8(solver(f(:, :, i), kernel, boundaryCondition, lambda_weight, options));
    end
    toc
    
    if default(options, 'show', false)
        figure; imshow([f_truth f u]), title('Truth - Blurred - Recovered');
        imwrite(u, result_image_path);
    else
        h = figure; imshow(u);
        print(h, result_image_path, '−dpng');
    end
    
    if isfield(options, 'saved_hint')
        save(sprintf('%s.%d.mat', image_path, options.saved_hint+1), 'u', 'f')
    else
%         save(sprintf('%s.1.mat', image_path), 'u', 'f')
    end
end