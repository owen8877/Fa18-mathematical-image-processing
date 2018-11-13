function u = pm(image_path, T, K, result_image_path, options)
    if nargin < 1
        image_path = 'image/blurred/pmbuilding.png';
    end
    if nargin < 2
        T = 20;
    end
    if nargin < 3
        K = 10;
    end
    if nargin < 4
        result_image_path = 'image/pm.jpg';
    end
    if nargin < 5
        options = struct();
    end
    
    options.pde_maxTime = T;
    options.pde_dt = 0.4;
    options.pde_K = K;    

    options.blur = false;
    options.show = false;
    options.channels = 3;
    options.solver = 'pmpde';
    options.pde_gradient_lb = 10;
    options.solver_clip_count = 4;

    u = main(image_path, 1, 1, 1, result_image_path, options);
end