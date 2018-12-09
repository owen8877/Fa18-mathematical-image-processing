function u = main(image_path, result_image_path, options)
    if nargin < 1
        image_path = 'image/source/noised_geometry.jpg';
    end
    if nargin < 2
        result_image_path = 'image/result/noised_geometry.jpg';
    end
    if nargin < 3
        options = struct();
    end
    
    addpath lib
    
    kernel_size = default(options, 'kernel_size', 10);
    gaussian_sigma = default(options, 'gaussian_sigma', 1);
    kernel = fspecial('gaussian', [1, 1] * kernel_size, gaussian_sigma);
    f_raw = imread(image_path);
    if size(f_raw, 3) == 3
        f_original = double(rgb2gray(f_raw));
    else
        f_original = double(f_raw);
    end
        
    noise_sigma = max(max(max(f_original))) * default(options, 'noise_level', 0.01);
    boundaryCondition = default(options, 'boundary_cond', 'replicate');
    
    if default(options, 'blur', false)
        f = imfilter(f_original, kernel, boundaryCondition) + noise_sigma*randn(size(f_original));
    else
        f = f_original;
    end
    if default(options, 'show', false)
%         figure(7); imshow(uint8(f)), title('Before segmentation');
    end
    
    tic
    [u, Irgb] = solver(f, options);
    toc
    
    if default(options, 'show', false)
        figure(2);
        imshow([gray2rgb(uint8(f)) Irgb gray2rgb(uint8(u*255))])
        title('before - segmented - indication function')
    end
    if default(options, 'write_result', true)
        imwrite(u, result_image_path);
    end
end

function rgb = gray2rgb(f)
	rgb = zeros([size(f) 3], 'uint8');
    rgb(:, :, 1) = f;
    rgb(:, :, 2) = f;
    rgb(:, :, 3) = f;
end