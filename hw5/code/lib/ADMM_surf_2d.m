function u = ADMM_surf_2d(lambda, f, W, Wt, options)
    max_itr = default(options, 'ADMM_MaxItr', 200);
    mu = default(options, 'ADMM_mu', 5);
    tor = default(options, 'ADMM_tor', 1e-5);
    
    % initialize
    u = f*0;
    d = W0(u, options);
    v = W0(u, options);
    
    % iterations
    itr = 1;
    rel_err_arr = zeros(max_itr, 1);
    tfm1 = (2*f-1)/mu;
    fm = f/mu;
    mf = matNorm(f);
    lambdamu = lambda/mu;
    while itr <= max_itr
        u_old = u;
        u = Wt(w_minus(d, v)) + fm;
        u = max(0, min(u, 1));
        
        Wu = W(u);
        d = soft_threshold_helper(lambdamu, w_plus(Wu, v));
        Wumd = w_minus(Wu, d);
        v = w_plus(v, Wumd);
        
        rel_err = w_norm(Wumd) / mf;
%         rel_err = norm(u-u_old, 'fro') / norm(u_old, 'fro');
%         rel_err = Inf;
        rel_err_arr(itr) = rel_err;
        fprintf('Itr % 5d, rel err: %.4e\n', itr, rel_err);
        if rel_err < tor
            break
        end
        
        if mod(itr, 10) == 0
            figure(8);
            subplot(1, 2, 1); mesh(u);
            subplot(1, 2, 2); contourf(u);
        end
        
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
                c{i}{j, k} = a{i}{j, k} + b{i}{j, k};
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
                c{i}{j, k} = a{i}{j, k} - b{i}{j, k};
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
    
    C = zeros(size(a{1}{1, 1}));
    for i = 1:n
        for j = 1:ms(1)
            for k = 1:ms(2)
                C = C + a{i}{j, k} .* b{i}{j, k};
            end
        end
    end
    c = sum(sum(C));
end

function w = W0(u, options)
    w = cell(1, options.additional_Level);
    os = size(u);
    
    for i = 1:options.additional_Level
        w{i} = cell([1 1]*options.additional_frame2);
        for j = 1:options.additional_frame2
            for k = 1:options.additional_frame2
                w{i}{j, k} = zeros(os);
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
        tmp = zeros(size(v{1}{1, 1}));
        for j = 1:ms(1)
            for k = 1:ms(2)
                tmp = tmp + v{i}{j, k}.^2;
            end
        end
%         tmp = sqrt(mean(mean(tmp)));
        tmp = sqrt(tmp) + 1e-10;
        
        for j = 1:ms(1)
            for k = 1:ms(2)
                vv = v{i}{j, k};
%                 if j == 1 && k == 1
%                     y{i}{j, k} = soft_threshold(mean(mean(tau)), vv);
%                     y{i}{j, k} = vv;
%                     continue
%                 end
%                 y{i}{j, k} = soft_threshold(tau, vv);
%                 y{i}{j, k} = isotropic_shrinkage(tau, vv, abs(vv));
                y{i}{j, k} = isotropic_shrinkage(tau, vv, tmp);
            end
        end
    end
end

function a = isotropic_shrinkage(l, m, tmp)
%     if mean(mean(tmp)) > 1e-5
        a = max(tmp-l, 0) .* (m./tmp);
%     else
%         a = m;
%     end
end