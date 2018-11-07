innerTest('butterfly', 'bmp', 0.05)
innerTest('bird', 'bmp', 0.05)
innerTest('building', 'jpeg', 0.05)
innerTest('comic', 'jpeg', 0.05)

function innerTest(p1name, p2name, noise_level)
    %% Generate a noised butterfly picture
    options = struct();
    options.blur = true;
    options.blur_only = true;
    options.noise_level = noise_level;

    image_path = sprintf('image/source/%s.%s', p1name, p2name);
    lambda_weight = 1;
    kernel_size = 1;
    gaussian_sigma = 1;
    result_image_path = sprintf('image/blurred/he-%s.png', p1name);

    main(image_path, lambda_weight, kernel_size, gaussian_sigma, result_image_path, options);

    %% Denoise the butterfly picture by heat pde
    options = struct();
    options.blur = false;
    options.show = true;
    options.channels = 3;
    options.truth_path = sprintf('image/source/%s.%s', p1name, p2name);
    options.solver = 'heatpde';
    options.pde_maxTime = 4.0;
    options.pde_dt = 0.2;
    options.solver_clip_count = 4;
    options.clip_save = sprintf('../doc/plot/heat-%s-%s.png', p1name, num2str(noise_level));
    options.three_compare = sprintf('../doc/plot/heat-result-%s-%s.png', p1name, num2str(noise_level));

    image_path = sprintf('image/blurred/he-%s.png', p1name);
    lambda_weight = 1;
    kernel_size = 1;
    gaussian_sigma = 1;
    result_image_path = sprintf('image/result/he-%s.png', p1name);

    main(image_path, lambda_weight, kernel_size, gaussian_sigma, result_image_path, options);
    set(gcf, 'Position', [341.8000, 465.8000, 555.2000, 207.2000])
end