function u = main(image_path, lambda_weight, kernel_size, gaussian_sigma, result_image_path, options)
    % Options are:

    if nargin < 1
        image_path = 'image/source/comic.jpeg';
    end
    if nargin < 2
        lambda_weight = 1;
    end
    if nargin < 3
        kernel_size = 15;
    end
    if nargin < 4
        gaussian_sigma = 1.5;
    end
    if nargin < 5
        result_image_path = 'image/result/comic.jpeg';
    end
    if nargin < 6
        options = struct();
    end
    
    addpath lib
    addpath solvers
    
    kernel = fspecial('gaussian', [1, 1] * kernel_size, gaussian_sigma);
    f_truth = double(imread(image_path));
        
    noise_sigma = max(max(max(f_truth))) * default(options, 'noise_level', 0.01);
    boundaryCondition = default(options, 'boundary_cond', 'replicate');
    blurFunc = @(x) imfilter(x, kernel, boundaryCondition);
    
    if default(options, 'blur', false)
        f = blurFunc(f_truth) + noise_sigma*randn(size(f_truth));
        if default(options, 'blur_only', false)
            imwrite(uint8(f), result_image_path);
            return
        end
        if default(options, 'show', false)
            % figure; imshow(uint8([f_truth f])), title('Before recovered\newlineTruth - Blurred');
        end
    else
        f = f_truth;
        if isfield(options, 'truth_path')
            f_truth = double(imread(options.truth_path));
        end
        if default(options, 'show', false)
            % figure; imshow(uint8(f)), title('Blurred');
        end
    end
    
    solver_handle = str2func(default(options, 'solver', 'defsolver'));
    
    tic
    channelN = size(f, 3);
    shape = size(f);
    shape(3) = min([channelN, default(options, 'channels', channelN)]);
    f_truth = f_truth(:, :, 1:shape(3));
    f = f(:, :, 1:shape(3));
    u = zeros(shape, 'uint8');
    
    clipCount = default(options, 'solver_clip_count', 5);
    options.solver_clip_count = clipCount;
    cshape = shape; cshape(2) = cshape(2) * clipCount;
    clips = zeros(cshape, 'uint8');
    
    for i = 1:shape(3)
        options.solver_psnrFunc = @(x) psnr(x, f_truth(:, :, i));
        fprintf('Processing the %d channel...\n', i);
        [out1, out2] = solver_handle(f(:, :, i), blurFunc, lambda_weight, options);
        u(:, :, i) = uint8(out1);
        clips(:, :, i) = uint8(out2);
    end
    toc
    
    if default(options, 'show', false)
        figure; imshow([f_truth f u]), title('Truth - Blurred - Recovered');
        if isfield(options, 'three_compare')
            imwrite([f_truth f u], options.three_compare);
        end
        figure; imshow(clips), title('Intermediate results');
        if isfield(options, 'clip_save')
            imwrite(clips, options.clip_save);
        end
    end
    imwrite(u, result_image_path);
    
    % save(sprintf('%s.1.mat', image_path), 'u', 'f')
end