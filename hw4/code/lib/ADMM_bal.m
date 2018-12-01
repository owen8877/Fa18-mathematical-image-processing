function Wtu = ADMM_bal(A, f, W, Wt, lambda, options)
    % Options are:
    % ADMM_CG0
    % ADMM_delta
    % ADMM_fast
    % ADMM_kappa
    % ADMM_L
    % ADMM_MaxItr
    % ADMM_minRes
    % ADMM_mu
    % ADMM_outInt
    % ADMM_save_history
    % ADMM_tor

    max_itr = default(options, 'ADMM_MaxItr', 1000);
    ADMMtor = default(options, 'ADMM_tor', 5e-5);
    psnrFunc = default(options, 'ADMM_psnrFunc', @(x) nan);
    outputInt = default(options, 'ADMM_outInt', 5);
    kappa = default(options, 'ADMM_kappa', 1);
    L = default(options, 'ADMM_L', 1000);
    retry = default(options, 'ADMM_retry', 5);
    
    % turn matrix into function
    try
        func2str(A);
        Afunc = A;
        Wfunc = W; Wtfunc = Wt;
    catch
        Afunc = @(x) A*x;
        Wfunc = @(x) W*x;
        Wtfunc = @(x) W'*x;
    end
    
    % initialize
    u = Wfunc(default(options, 'ADMM_initial', f));
    
    % iterations
    itr = 1;
    rel_err_arr = zeros(max_itr, 1);
    rel_err_min = Inf;
    psnr_arr = zeros(max_itr, 1);
    while itr <= max_itr
        AWtu = Afunc(Wtfunc(u));
        ImWWtu = u - Wfunc(Wtfunc(u));
        
        gF2 = Wfunc(Afunc(AWtu-f)) + kappa * ImWWtu;
        g = u - gF2 / L;
        u = soft_threshold(lambda/L, g);
        
        rel_err = matNorm(lambda*sign(u)+gF2);
        rel_err_arr(itr) = rel_err;
        rel_err_min = min(rel_err, rel_err_min);
        Wtu = Wtfunc(u);
        psnr_val = psnrFunc(Wtu);
        psnr_arr(itr) = psnr_val;
        fprintf('Itr % 5d, rel_err: %.4e, psnr: %.2f\n', itr, rel_err, psnr_val);
        if mod(itr, outputInt) == 0
            figure(8)
            imshow(uint8(Wtu)); title(sprintf('Iteration %d.', itr));
        end
        if rel_err > (1+ADMMtor) * rel_err_min
            L = L * 2;
            kappa = kappa * 5;
            retry = retry - 1;
            rel_err_min = rel_err;
            if retry < 0
                break
            end
            fprintf('Last % 3d retry, L increased to %.2f!\n', retry, L);
        end
        itr = itr + 1;
    end
    fprintf('Used %d iterations, \nrelative error: %.4e.\n', itr, rel_err)
    
    itr = min(itr, max_itr);
    
    if isfield(options, 'ADMM_save_history')
        figure(22); semilogy(1:itr, rel_err_arr(1:itr)); title('rel_err');
        figure(23); plot(1:itr, psnr_arr(1:itr)); title('psnr');
        save(options.ADMM_save_history, 'rel_err_arr', 'psnr_arr');
    end
end
