function [u, Irgb] = ADMM(lambda, f, W, Wt, u, options)
    max_itr = default(options, 'ADMM_MaxItr', 200);
    mu = default(options, 'ADMM_mu', 5);
    tor = default(options, 'ADMM_tor', 1e-5);
    outputInt = default(options, 'ADMM_outInt', 10);
    fast = default(options, 'ADMM_fast', false);
    shadow = default(options, 'solver_shadow', 'positive');
    avg = default(options, 'ADMM_avg', 0.5);
    clips = default(options, 'solver_clips', 5);
    
    % initialize
    d = W(u);
    v = d * 0;
    f_n = f / 255;
    
    c1 = 1;
    c2 = 0;
    shape = size(f);
    
    % iterations
    itr = 1;
    rel_err_arr = zeros(max_itr, 1);
    while itr <= max_itr
        u = Wt(d-v) - ((c1^2-c2^2)-(2*(c1-c2))*f_n) / mu;
        u = max(0, min(u, 1));
        
        d = soft_threshold_wrapper(lambda/mu, W(u)+v);
        avg = (max(max(u)) + min(min(u))) / 2;
        selection = u > avg;
        c1 = meanHelper(f_n, selection);
        c2 = meanHelper(f_n, ~selection);
        
        dv = W(u) - d;
        v = v + dv;
        
        rel_err = matNorm(dv)/matNorm(f_n);
        rel_err_arr(itr) = rel_err;
        fprintf('Itr % 5d, rel err: %.4e\n', itr, rel_err);
        if mod(itr, outputInt) == 0
            Irgb = contourHelper(8, shape, shadow, u-avg, f);
            title(sprintf('Iteration %d.', itr));
        end
        if mod(itr, max_itr/clips) == 0
            figure(9); subplot(1, clips, itr/(max_itr/clips))
            imagesc(u); colorbar; title(sprintf('Iteration %d.', itr))
        end
        if rel_err < tor
            break
        end
        itr = itr + 1;
    end
    fprintf('Used %d iterations, \nrelative error: %.4e.\n', itr, rel_err)
    
    if isfield(options, 'ADMM_save_history')
        figure(20); semilogy(1:itr-1, rel_err_arr(1:itr-1)); title('rel_err');
        save(options.ADMM_save_history, 'rel_err_arr');
    end
end

function m = meanHelper(mat, mask)
    m = sum(sum(mat(mask))) / sum(sum(mask));
end

function d = soft_threshold_wrapper(lambda, x)
    [m, n] = size(lambda);
    [p, q] = size(x);
    d = 0*x;
    mp = p / m; nq = q / n;
    for i = 1:m
        for j = 1:n
            d((i-1)*mp+1:i*mp, (j-1)*nq+1:j*nq) = soft_threshold(lambda(i, j), x((i-1)*mp+1:i*mp, (j-1)*nq+1:j*nq));
        end
    end
end
