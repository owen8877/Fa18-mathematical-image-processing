function [fx, fy, fxx, fxy, fyy] = derivative(f, cond)
    [ml, mr, mu, md] = move(f, cond, true, true);
    fx = (ml - mr) / 2;
    fy = (mu - md) / 2;
    
    [fxl, fxr, fxu, fxd] = move(fx, cond, true, true);
    [~, ~, fyu, fyd] = move(fy, cond, false, true);
    fxx = (fxl - fxr) / 2;
    fxy = (fxu - fxd) / 2;
    fyy = (fyu - fyd) / 2;
end

function [ml, mr, mu, md] = move(f, cond, lr, ud)
    if lr
        ml = circshift(f, [0, -1]);
        mr = circshift(f, [0,  1]);
    else
        ml = []; mr = [];
    end
    if ud
        mu = circshift(f, [-1, 0]);
        md = circshift(f, [ 1, 0]);
    else
        mu = []; md = [];
    end
    
    if strcmp(cond, 'extrap')
        if lr
            ml(:, end) = 3*f(:, end) - 3*f(:, end-1) + f(:, end-2);
            mr(:, 1) = 3*f(:, 1) - 3*f(:, 2) + f(:, 3);
        end
        if ud
            mu(end, :) = 3*f(end, :) - 3*f(end-1, :) + f(end-2, :);
            md(1, :) = 3*f(1, :) - 3*f(2, :) + f(3, :);
        end
    elseif strcmp(cond, 'replicate') || strcmp(cond, 'symmetric')
        if lr
            ml(:, end) = f(:, end);
            mr(:, 1) = f(:, 1);
        end
        if ud
            mu(end, :) = f(end, :);
            md(1, :) = f(1, :);
        end
    elseif strcmp(cond, 'circular')
        
    else
        error('Cannot handle boundary condition %s!', cond)
    end
end