function [x, history] = CG(x0, A, b, options)
    if ~isfield(options, 'torlerance')
        options.torlerance = 1e-6;
    end
    if ~isfield(options, 'lowerBound')
        options.lowerBound = 1e-8;
    end
    
    outputInt = default(options, 'CG_outInt', 100);
    
    x = x0;
    r0 = b - A(x);
    r0Norm = matNorm(r0);
    
    if r0Norm < options.lowerBound
        x = x0;
        return;
    end
    
    r = r0;
    z = r;
    p = z;
    
    itr = 0;
    history = [];
    while true
        rTz = matProd(r, z);
        Ap = A(p);
        alpha = rTz / matProd(p, Ap);
        x = x + alpha * p;
        r = r - alpha * Ap;
        
        relErr = matNorm(r)/r0Norm;
        if relErr < options.torlerance
            break
        end
        
        z = r;
        beta = matProd(r, z) / rTz;
        p = z + beta * p;
        
        itr = itr + 1;
        if mod(itr, outputInt) == 0
            fprintf('Iteration %d / %.3e.\n', itr, relErr);
        end
    end
end
