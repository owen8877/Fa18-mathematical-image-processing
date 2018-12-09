function u = ADMM_surf(lambda, f, W, Wt, options)
    max_itr = default(options, 'ADMM_MaxItr', 200);
    mu = default(options, 'ADMM_mu', 5);
    tor = default(options, 'ADMM_tor', 1e-5);
    
    % initialize
    u = 0*f;
    d = W0(u, options);
    v = W0(u, options);
    mf = matNorm3d(f);
    tfm1 = (2*f-1)/mu;
    
    % iterations
    itr = 1;
    rel_err_arr = zeros(max_itr, 1);
    while itr <= max_itr
        u_n = Wt(w_minus(d, v)) - tfm1;
        u_n = max(0, min(u_n, 1));
        
        Wu = W(u_n);
%         rel_err = matNorm3d(u_n-u) / matNorm3d(u);
        rel_err = w_norm(w_minus(Wu, d)) / mf;
        u = u_n;
        rel_err_arr(itr) = rel_err;
        fprintf('Itr % 5d, rel err: %.4e, max u: %.2e\n', itr, rel_err, max(max(max(u))));
        if rel_err < tor
            break
        end
        
        d = soft_threshold_helper(lambda/mu, w_plus(Wu, v));
        v = w_plus(v, w_minus(Wu, d));
        itr = itr + 1;
        java.lang.System.gc();
    end
    fprintf('Used %d iterations, \nrelative error: %.4e.\n', itr, rel_err)
    
    if isfield(options, 'ADMM_save_history')
        figure(20); semilogy(1:itr-1, rel_err_arr(1:itr-1)); title('rel_err');
        save(options.ADMM_save_history, 'rel_err_arr');
    end
end

function c = w_plus(a, b)
    n = numel(a);
    ms = size(a{1});
    
    c = cell(1, n);
    for i = 1:n
        c{i} = cell(ms);
        for j = 1:ms(1)
            for k = 1:ms(2)
                for l = 1:ms(3)
                    c{i}{j, k, l} = a{i}{j, k, l} + b{i}{j, k, l};
                end
            end
        end
    end
end

function c = w_minus(a, b)
    n = numel(a);
    ms = size(a{1});
    
    c = cell(1, n);
    for i = 1:n
        c{i} = cell(ms);
        for j = 1:ms(1)
            for k = 1:ms(2)
                for l = 1:ms(3)
                    c{i}{j, k, l} = a{i}{j, k, l} - b{i}{j, k, l};
                end
            end
        end
    end
end

function c = w_norm(a)
    c = sqrt(w_inner_prod(a, a));
end

function c = w_inner_prod(a, b)
    n = numel(a);
    ms = size(a{1});
    
    C = zeros(size(a{1}{1, 1, 1}));
    for i = 1:n
        for j = 1:ms(1)
            for k = 1:ms(2)
                for l = 1:ms(3)
                    C = C + a{i}{j, k, l} .* b{i}{j, k, l};
                end
            end
        end
    end
    c = sum(sum(sum(C)));
end

function w = W0(u, options)
    w = cell(1, options.additional_Level);
    os = size(u);
    
    for i = 1:options.additional_Level
        w{i} = cell([1 1 1]*options.additional_frame2);
        for j = 1:options.additional_frame2
            for k = 1:options.additional_frame2
                for l = 1:options.additional_frame2
                    w{i}{j, k, l} = zeros(os);
                end
            end
        end
    end
end

function y = soft_threshold_helper(tau, v)
    n = numel(v);
    ms = size(v{1});
    
    y = cell(1, n);
    for i = 1:n
        y{i} = cell(ms);
        tmp = zeros(size(v{1}{1, 1, 1}));
        for j = 1:ms(1)
            for k = 1:ms(2)
                for l = 1:ms(3)
                    tmp = tmp + v{i}{j, k, l}.^2;
                end
            end
        end
        tmp = sqrt(tmp) + 1e-5;
        
        for j = 1:ms(1)
            for k = 1:ms(2)
                for l = 1:ms(3)
                    vv = v{i}{j, k, l};
%                     y{i}{j, k, l} = soft_threshold(tau, vv);
                    y{i}{j, k, l} = isotropic_shrinkage(tau, vv, tmp);
                end
            end
        end
    end
end

function nn = matNorm3d(m)
    nn = sqrt(sum(sum(sum(m.^2))));
end


function a = isotropic_shrinkage(l, m, tmp)
    a = max(tmp-l, 0) .* (m./tmp);
end