function f = shockfilter(f, options)
    maxT = default(options, 'pde_maxTime', 10);
    dt = default(options, 'pde_dt', 0.5);
    boundCond = default(options, 'pde_boundary_condition', 'replicate');
    gradientLB = default(options, 'pde_gradient_lb', 1);
    useNormald2 = default(options, 'pde_use_normald2', true);
    lambda = default(options, 'pde_lambda', 0);
    trickF = default(options, 'pde_trickF', false);
    
    if trickF
        FFunc = @xcosFunc;
    else
        FFunc = @idFunc;
    end
    
    itr = 1;
    time = dt;
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
        f = max(0, min(f, 255));

        if mod(itr, 10) == 0
            figure(9); imshow(f./255);
            fprintf('Itr % 3d.\n', itr);
        end
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