function u = heat(image_path, T, result_image_path, options)
    if nargin < 1
        image_path = 'image/blurred/hecomic.png';
    end
    if nargin < 2
        T = 4.0;
    end
    if nargin < 3
        result_image_path = 'image/he.jpg';
    end
    if nargin < 4
        options = struct();
    end
    
    options.blur = false;
    options.show = false;
    options.channels = 3;
    options.solver = 'heatpde';
    options.pde_maxTime = T;
    options.pde_dt = 0.2;

    u = main(image_path, 1, 1, 1, result_image_path, options);
end