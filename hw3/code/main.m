function u = main(image_path, result_image_path, options)
    if nargin < 1
        image_path = 'image/source/DSCN1464.jpg';
    end
    if nargin < 2
        result_image_path = 'image/result/DSCN1464.jpg';
    end
    if nargin < 3
        options = struct();
    end
    
    addpath lib
    
    kernel_size = default(options, 'kernel_size', 10);
    gaussian_sigma = default(options, 'gaussian_sigma', 1);
    kernel = fspecial('gaussian', [1, 1] * kernel_size, gaussian_sigma);
    f_original = double(rgb2gray(imread(image_path)));
        
    noise_sigma = max(max(max(f_original))) * default(options, 'noise_level', 0.01);
    boundaryCondition = default(options, 'boundary_cond', 'replicate');
    
    if default(options, 'blur', false)
        f = imfilter(f_original, kernel, boundaryCondition) + noise_sigma*randn(size(f_original));
    else
        f = f_original;
    end
    if default(options, 'show', false)
        figure(7); imshow(uint8(f)), title('Before segmentation');
    end
    
    solver = str2func(default(options, 'solver', 'pde'));
    tic
    [u, clips] = solver(f, options);
    toc
    
    if default(options, 'show', false)
        figure(2); mesh(u)
        figure(3); imshow(clips); title('Intermediate results.')
    end
    if default(options, 'write_result', true)
        imwrite(u, result_image_path);
    end
end