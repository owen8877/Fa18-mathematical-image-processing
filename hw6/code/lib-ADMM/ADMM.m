function u = ADMM(A, At, f, W, Wt, WtW, lambda, options)
    max_itr = default(options, 'ADMM_MaxItr', 1000);
    mu = default(options, 'ADMM_mu', 10);
    delta = default(options, 'ADMM_delta', 1.618);
    ADMMtor = default(options, 'ADMM_tor', 5e-5);
    psnrFunc = default(options, 'ADMM_psnrFunc', @(x) nan);
    outputInt = default(options, 'ADMM_outInt', 5);
    consoleInt = default(options, 'ADMM_consoleInt', outputInt);
    fast = default(options, 'ADMM_fast', false);
    useMinRes = default(options, 'ADMM_minRes', false);
    
    Afunc = A; Atfunc = At;
    Wfunc = W; Wtfunc = Wt;
    WtWfunc = WtW;
    
    % initialize
    u = default(options, 'ADMM_initial', f);
    d = Wfunc(u);
    b = 0*d;
    CGtorlerance0 = default(options, 'ADMM_CG0', 5e-5);
    alpha = 1;
    mf = matNorm(f);
    
    % iterations
    itr = 1;
    rel_err_arr = zeros(max_itr, 1);
    psnr_arr = zeros(max_itr, 1);
    while itr <= max_itr
        ATerm = @(x) Atfunc(Afunc(x))+mu*WtWfunc(x);
        bTerm = Atfunc(f) + Wtfunc(d-b)*mu;
        if useMinRes
            uMid = minres(ATermWrapper(ATerm, size(u)), vectorize(bTerm), 1e-6, 1000);
            u_n = reshape(uMid, size(u));
        else
            u_n = CG(u, ATerm, bTerm, struct('torlerance', CGtorlerance0));
%                 struct('torlerance', max(CGtorlerance0/log(itr+2),
%                 1e-7)))
        end
        d_n = soft_threshold(lambda/mu, Wfunc(u_n)+b);
        b_n = b + delta*(Wfunc(u_n)-d_n);
        
        if fast && itr >= 2
            alpha_n = (1+sqrt(1+4*alpha^2)) / 2;
            u = u_n;
            d = d_n + (alpha-1)/alpha_n * (d_n-d_n_old);
            b = b_n + (alpha-1)/alpha_n * (b_n-b_n_old);
        else
            u = u_n;
            d = d_n;
            b = b_n;
        end
        d_n_old = d_n;
        b_n_old = b_n;
        
        if mod(itr, consoleInt) == 0
            rel_err = matNorm(Wfunc(u)-d)/mf;
            rel_err_arr(itr) = rel_err;
            psnr_val = psnrFunc(u);
            psnr_arr(itr) = psnr_val;
            fprintf('Itr % 5d, rel err: %.4e, psnr: %.2f\n', itr, rel_err, psnr_val);
            
            if rel_err < ADMMtor
                break
            end
        end
        if mod(itr, outputInt) == 0
            figure(8)
            imshow(uint8(u)); title(sprintf('Iteration %d.', itr));
        end
        itr = itr + 1;
    end
    rel_err = matNorm(Wfunc(u)-d)/mf;
    fprintf('Used %d iterations, \nrelative error: %.4e.\n', itr, rel_err)
    
    if isfield(options, 'ADMM_save_history')
        figure(20); semilogy(1:itr-1, rel_err_arr(1:itr-1)); title('rel_err');
        figure(21); plot(1:itr-1, psnr_arr(1:itr-1)); title('psnr');
        save(options.ADMM_save_history, 'rel_err_arr', 'psnr_arr');
    end
end
