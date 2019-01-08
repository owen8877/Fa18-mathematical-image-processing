function u = ADMM_2_cont(As, Ats, phis, f, W, Wt, lambdas, weights, options)
    addpath lib-mat lib-util
    
    max_itr = default(options, 'ADMM_MaxItr', 1000);
    mus = default(options, 'ADMM_mus', [10 10]);
    muFor0 = default(options, 'ADMM_muFor0', 5);
    delta = default(options, 'ADMM_delta', 1.618);
    ADMMtor = default(options, 'ADMM_tor', 5e-5);
    outputInt = default(options, 'ADMM_outInt', 5);
    quad_sign = default(options, 'ADMM_quad_sign', true);
    
    WtW = @(x) Wt(W(x));
    
    % initialize
    u = f * 0;
    d1 = W(u); d2 = u;
    b0 = 0; b1 = d1 * 0; b2 = d2;
    CGtorlerance0 = default(options, 'ADMM_CG0', 5e-5);
    
    % iterations
    itr = 1;
    rel_err_arr = zeros(max_itr, 1);
    while itr <= max_itr
        ATerm = @(x) A(x, As, Ats, WtW, mus, muFor0, weights);
        bTerm = b(Ats, Wt, mus, muFor0, d1, d2, b0, b1, b2, phis, weights);
        u = CG(u, ATerm, bTerm, struct('torlerance', CGtorlerance0));
        d1 = soft_threshold(lambdas(1)/mus(1), W(u)+b1);
        l2m = lambdas(2)/2/mus(2);
        if ~quad_sign
            l2m = -l2m;
        end
        d2 = triroot(u+b2, l2m);
        Wumd1 = W(u) - d1;
        umd22 = u - d2.^2;
        omu = sum(sum(u)) - 1;
        b0 = b0 + delta * omu;
        b1 = b1 + delta * Wumd1;
        b2 = b2 + delta * umd22;
        
        err = matNorm(Wumd1) + matNorm(omu) + matNorm(umd22);
        if itr == 1
            err0 = err;
        end
        rel_err = err / err0;
        rel_err_arr(itr) = rel_err;
        fprintf('Itr % 5d, rel err: %.4e\n', itr, rel_err);
        if mod(itr, outputInt) == 0
            figure(8); subplot(1, 3, 3)
            title(sprintf('Iteration %d.', itr))
            imshow(u, [])
        end
        if rel_err < ADMMtor
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

function val = A(x, As, Ats, WtW, mus, muFor0, weights)
    val = muFor0 * sum(sum(x)) + mus(1) * WtW(x) + mus(2) * x;
    for i = 1:numel(As)
        val = val + Ats{i}(As{i}(x)) * weights(i);
    end
end

function val = b(Ats, Wt, mus, muFor0, d1, d2, b0, b1, b2, phis, weights)
    val = muFor0 * (1-b0) + mus(1) * Wt(d1-b1) + mus(2) * (d2.^2-b2);
    for i = 1:numel(Ats)
        val = val + Ats{i}(phis{i}) * weights(i);
    end
end

function d = triroot(t, l)
    d = t*0;
    for i = 1:size(t, 1)
        for j = 1:size(t, 2)
            ha = sort(roots([1 0 -t(i, j) l]), 'descend', 'ComparisonMethod', 'real');
            if isreal(ha(1)) && ha(1) > 0
                d(i, j) = ha(1);
            else
                d(i, j) = 0;
            end
        end
    end
end