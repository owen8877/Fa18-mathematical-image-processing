function [x, f] = simple_gradient(x0, fH, gH, options)
    addpath lib-util
    
    maxItr = default(options, 'max_itr', 100);
    tor = default(options, 'tor', 1e-4);
    L = default(options, 'L', 1);
    alpha = default(options, 'alpha', 0.5);
    beta = default(options, 'beta', 0.8);
    outputOn = default(options, 'output_on', false);
   
    x = x0;
    for itr = 1:maxItr
        g = gH(x);
        f = fH(x);
        dx = g/L;
        
        a = 1;
        for t = 1:10
            if fH(x-a*dx) > f - alpha*(g'*dx)*a
                a = a * beta;
            else
                break
            end
        end
        x = x - a*dx;
        
        mg = matNorm(g);
        if outputOn
            fprintf('Itr % 5d, x: %.3e, |g|: %.3e\n', itr, x, mg)
        end
        
        if mg < tor
            break
        end
    end
end

