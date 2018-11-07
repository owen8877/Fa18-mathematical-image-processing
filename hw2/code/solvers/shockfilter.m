function [f, clips] = shockfilter(f, ~, ~, options)
    maxT = default(options, 'pde_maxTime', 10);
    dt = default(options, 'pde_dt', 0.5);
    boundCond = default(options, 'pde_boundary_condition', 'replicate');
    psnrFunc = default(options, 'solver_psnrFunc', @(x) nan);
    gradientLB = default(options, 'pde_gradient_lb', 1);
    useNormald2 = default(options, 'pde_use_normald2', true);
    lambda = default(options, 'pde_lambda', 0);
    clipCount = default(options, 'solver_clip_count', 5);
    trickF = default(options, 'pde_trickF', false);
    
    if trickF
        FFunc = @xcosFunc;
    else
        FFunc = @idFunc;
    end
    
    itr = 1;
    time = dt;

    shape = size(f); clips = zeros([shape(1) shape(2)*clipCount]);
    clipdt = maxT / clipCount - 1e-6; clipIndex = 0;
    while time <= maxT + 1e-6
        [fx, fy, fxx, fxy, fyy] = derivative(f, boundCond);
        gradient_fsq = fx.^2 + fy.^2;
        gradient_f = sqrt(gradient_fsq);
        gradient_fsq = max(gradient_fsq, gradientLB);
        laplacian_f = fxx + fyy;
        if useNormald2
            fnn = (fx.^2 .* fxx + 2 .* fx.*fy.*fxy + fy.^2 .* fyy) ./ gradient_fsq;
            L = fnn;
        else
            L = laplacian_f;
        end
        rhs = (-gradient_f) .* FFunc(L) + lambda * laplacian_f;
        f = f + dt * rhs;
        
        if time >= (clipIndex+1)*clipdt
            clips(:, clipIndex*shape(2)+1:(clipIndex+1)*shape(2)) = f;
            clipIndex = clipIndex + 1;
        end
        
        fprintf('Itr % 3d, PSNR %.2f.\n', itr, psnrFunc(f));
        itr = itr + 1;
        time = time + dt;
    end
end

function F = xcosFunc(x)
    F = x.*cos(x/60*pi);
end

function F = idFunc(x)
    F = x;
end