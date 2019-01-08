function u = deblur(options)
    p1name = options.p1name;
    p1Sname = options.p1Sname;
    p2name = options.p2name;
    
    o = struct();
    o.blur = false;
    o.show = true;
    o.channels = 3;
    o.boundary_cond = default(options, 'boundary_cond', 'replicate');
    if ~default(options, 'no_truth', false)
        o.truth_path = sprintf('image/source/%s.%s', p1Sname, p2name);
    end

    o.ADMM_CG0 = 3e-2;
    o.ADMM_fast = true;
    o.ADMM_minRes = false;
    o.ADMM_outInt = 15;
    o.ADMM_tor = options.deblur_criterion;
    o.ADMM_MaxItr = 1000;

    kernel_name = options.deblur_kernel_name;
    image_path = sprintf('image/blurred/%s.png', p1name);
    kernel_path = sprintf('image/kernel-rec/%s.bmp', kernel_name);
    o.diff_operator = sprintf('image/kernel/%s-diff.mat', kernel_name);
    lambda_weight = options.deblur_lambda;
    result_image_path = sprintf('image/result/%s.png', p1name);

    u = main(image_path, lambda_weight, kernel_path, result_image_path, o);
end
% deblur_criterion
% deblur_kernel_name
% deblur_lambda
% p1name
% p1Sname
% p2name