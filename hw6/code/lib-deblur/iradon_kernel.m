function iradon_kernel(options)
    addpath lib-mat lib-ADMM

    edge_info_path = sprintf('data/%s.mat', options.edge_data);
    load(edge_info_path, 'information', 'counter', 'box_size', 'xp')

    s = options.radon_kernel_size;
    [~, xps] = radon(zeros(2*s+1), 0);
    thetas = zeros(counter, 1);
    R = zeros(numel(xp), counter);
    weights = ones(counter, 1);
    Rt = zeros(numel(xp), counter);
    thetaN = counter;

    for i = 1:counter
        thetas(i) = information{i}.theta / pi * 180;
        R(:, i) = information{i}.phi';
        weights(i) = 2 - 8*information{i}.lossness;
        Rt(:, i) = information{i}.t;
    %     if abs(thetas(i)-90) < 3
    %         weights(i) = 0;
    %     end
    %     figure(11); clf; hold on
    %     plot(xp, R(:, i), 'rs-', 'DisplayName', 'R')
    %     plot(xp, Rt(:, i), 'bs-', 'DisplayName', 'Rt')
    end

    numdiff = (numel(xp) - numel(xps))/2;
    R = R(numdiff+1:end-numdiff, :);
    Rt = Rt(numdiff+1:end-numdiff, :);

    [thetas, idx] = sort(thetas);
    R = R(:, idx);
    R = max(R, 0);
    Rt = Rt(:, idx);
    R = R ./ sum(R, 1);
    % R = Rt;

    %% clean data!
    % sampleN_array = histcounts(thetas, 0:3:180);
    % importance = 3 ./ sqrt(sampleN_array + 2);
    % weights = weights .* (importance(floor(thetas/3)+1))';

    %% blur operator
    useblur = default(options, 'radon_use_blur', false);
    if useblur
        blurKernel = fspecial('gaussian', 9, options.radon_blur_sigma);
        bl = @(x) imfilter(x, blurKernel);
    else
        bl = @(x) x;
    end

    %% using ADMM!
    As = cell(thetaN, 1);
    for i = 1:thetaN
        As{i} = @(x) bl(radon(x, thetas(i)));
    end

    Ats = cell(thetaN, 1);
    coordinates = cell(thetaN, 1);
    for i = 1:thetaN
        coordinates{i} = (-s:s)*cos(thetas(i)/180*pi) + (s:-1:-s)'*sin(thetas(i)/180*pi);
        Ats{i} = @(x) bl(2*interp1(xps, x, coordinates{i}));
    end

    phis = mat2cell(R, numel(xps), ones(1, thetaN));

    % Wstruct = gradientHelper();
    % W = @(x) Wstruct.Wr(x, Wstruct.Wkernel);
    % Wt = @(x) Wstruct.Wrt(x, Wstruct.Wkernel);

    Wstruct = gradientHelper_asym();
    W = @(x) Wstruct.Wa(x, Wstruct.Wkernel);
    Wt = @(x) Wstruct.Wat(x, Wstruct.Wkernel);

    %%
    o = struct();
    o.ADMM_outInt = 1;
    o.ADMM_CG0 = 1e-2;
    o.ADMM_mus = [1 1] * thetaN;
    o.muFor0 = thetaN;

    o.ADMM_MaxItr = options.radon_ADMM_MaxItr;
    lambdas = options.radon_lambdas * thetaN;
    switch options.radon_ADMM_method
        case 'ADMM_2_cont'
            o.ADMM_quad_sign = options.radon_ADMM_quad_sign;
            u = ADMM_2_cont(As, Ats, phis, zeros(2*s+1), W, Wt, lambdas, weights, o);
        case 'ADMM_2'
            u = ADMM_2(As, Ats, phis, zeros(2*s+1), W, Wt, lambdas, weights, o);
    end
    guess_kernel_path = sprintf('image/kernel-rec/%s.bmp', options.deblur_kernel_name);
    imwrite(uint8(u/max(max(u))*256), guess_kernel_path, 'bmp')
end
% deblur_kernel_name
% edge_data
% radon_ADMM_MaxItr
% radon_ADMM_method
% radon_ADMM_quad_sign
% radon_blur_sigma
% radon_kernel_size
% radon_lambdas
% radon_use_blur