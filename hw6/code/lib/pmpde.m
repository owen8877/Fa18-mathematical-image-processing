function f = pmpde(f, options)
    maxT = default(options, 'pde_maxTime', 10);
    dt = default(options, 'pde_dt', 0.5);
    boundCond = default(options, 'pde_boundary_condition', 'replicate');
    K = default(options, 'pde_K', 1);
    gradientLB = default(options, 'pde_gradient_lb', 1);
    lambda = default(options, 'pde_lambda', 0);
    
    itr = 1;
    time = dt;

    while time <= maxT + 1e-6
        [fx, fy, fxx, fxy, fyy] = derivative(f, boundCond);
        gradient_fsq = fx.^2 + fy.^2;
        gradient_fsq = max(gradient_fsq, gradientLB);
        fnn = (fx.^2 .* fxx + 2 .* fx.*fy.*fxy + fy.^2 .* fyy) ./ gradient_fsq;
        ftt = fxx + fyy - fnn;
        laplacian_f = fxx + fyy;
        rhs = cFunc(gradient_fsq, K) .* ftt + bFunc(gradient_fsq, K) .* fnn + lambda * laplacian_f;
        f = f + dt * rhs;
        
        if mod(itr, 10) == 0
            figure(9); imshow(f./255);
            fprintf('Itr % 3d.\n', itr);
        end
        itr = itr + 1;
        time = time + dt;
    end
end

function c = cFunc(s, K)
    c = 1 ./ (1+s/K);
end

function b = bFunc(s, K)
    sk = s/K;
    b = (1-sk) ./ (1+sk).^2;
end