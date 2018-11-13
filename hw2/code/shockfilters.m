function u = shockfilters(image_path, T, result_image_path, options)
    if nargin < 1
        image_path = 'image/blurred/sfcomic.png';
    end
    if nargin < 2
        T = 0.03;
    end
    if nargin < 3
        result_image_path = 'image/sf.jpg';
    end
    if nargin < 4
        options = struct();
    end

    options.blur = false;
    options.show = true;
    options.channels = 3;
    options.solver = 'shockfilter';
    
    options.pde_maxTime = T;
    options.pde_dt = 0.005;
    options.pde_lambda = 0;
    options.pde_gradient_lb = 10;

    u = main(image_path, 1, 1, 1, result_image_path, options);
end