clear; %clc
rng(42)
addpath lib-mat
addpath lib-ADMM

kernel = normalizeFirst(double(imread('image/kernel/syn5.bmp')));
s = (size(kernel, 1)-1)/2;
thetaN = 10;
thetas = rand(thetaN, 1) * 360 - 180;
[R, xp] = radon(kernel, thetas);

for noise_level = 0.1:0.1:0.3
    R = R .* (1+rand(size(R))*noise_level-noise_level/2);

    figure(8); subplot(1, 3, 1);
    imshow(kernel, [])
    figure(8); subplot(1, 3, 2);
    backproj = iradon(R, thetas);
    imshow(backproj, [])

    %% using ADMM!
    As = cell(thetaN, 1);
    for i = 1:thetaN
        As{i} = @(x) radon(x, thetas(i));
    end

    Ats = cell(thetaN, 1);
    coordinates = cell(thetaN, 1);
    for i = 1:thetaN
        coordinates{i} = (-s:s)*cos(thetas(i)/180*pi) + (s:-1:-s)'*sin(thetas(i)/180*pi);
        Ats{i} = @(x) 2*interp1(xp, x, coordinates{i});
    end

    phis = mat2cell(R, numel(xp), ones(1, thetaN));

    % Wstruct = gradientHelper();
    % W = @(x) Wstruct.Wr(x, Wstruct.Wkernel);
    % Wt = @(x) Wstruct.Wrt(x, Wstruct.Wkernel);
    Wstruct = gradientHelper_asym();
    W = @(x) Wstruct.Wa(x, Wstruct.Wkernel);
    Wt = @(x) Wstruct.Wat(x, Wstruct.Wkernel);

    %%
    options = struct();
    options.ADMM_outInt = 20;
    options.ADMM_CG0 = 1e-2;
    options.ADMM_MaxItr = 50;
    lambdas = [5e-3 3e-3];
    u = ADMM_2_cont(As, Ats, phis, zeros(2*s+1), W, Wt, lambdas, ones(thetaN, 1), options);

    figure(9);
    subplot(1, 5, 1); title('Ground truth');
    imshow(kernel, [])
    subplot(1, 5, 2); title('Invoking iradon()');
    imshow(backproj, [])
    subplot(1, 5, round(noise_level*10+2)); title(sprintf('Recovered\nnoise level:%d%%', 100*noise_level));
    imshow(u, [])
end