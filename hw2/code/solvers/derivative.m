function [fx, fy, fxx, fxy, fyy] = derivative(f, cond)
    [ml, mr, mu, md] = move(f, cond);
    fx = (ml - mr) / 2;
    fy = (mu - md) / 2;
    
    [fxl, fxr, fxu, fxd] = move(fx, cond);
    [fyl, fyr, fyu, fyd] = move(fy, cond);
    fxx = (fxl - fxr) / 2;
    fxy = (fxu - fxd) / 2;
    fyy = (fyu - fyd) / 2;
end

function [ml, mr, mu, md] = move(f, cond)
    ml = circshift(f, [0, -1]);
    mr = circshift(f, [0,  1]);
    mu = circshift(f, [-1, 0]);
    md = circshift(f, [ 1, 0]);
    
    if strcmp(cond, 'replicate') || strcmp(cond, 'symmetric')
        ml(:, end) = f(:, end);
        mr(:, 1) = f(:, 1);
        mu(end, :) = f(end, :);
        md(1, :) = f(1, :);
    elseif strcmp(cond, 'circular')
        
    else
        error('Cannot handle boundary condition %s!', cond)
    end
end