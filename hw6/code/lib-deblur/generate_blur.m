function generate_blur(options)
    addpath lib-util
    o = struct();
    o.blur = true;
    o.blur_only = true;
    o.noise_level = default(options, 'blur_noise_level', 0e-3);
    o.boundary_cond = default(options, 'boundary_cond', 'replicate');
    
    p1name = options.p1name;
    p1Sname = options.p1Sname;
    p2name = options.p2name;

    image_path = sprintf('image/source/%s.%s', p1Sname, p2name);
    kernel_name = options.kernel_name;
    kernel_path = sprintf('image/kernel/%s.bmp', kernel_name);
    lambda_weight = NaN;
    result_image_path = sprintf('image/blurred/%s.png', p1name);

    main(image_path, lambda_weight, kernel_path, result_image_path, o);
end
% kernel_name
% p1name
% p1Sname
% p2name

