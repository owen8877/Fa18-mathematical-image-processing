function [dx, dy] = dfb(f, forward)
    if forward
        ml = circshift(f, [0, -1]);
        ml(:, end) = 2*f(:, end) - f(:, end-1);
        dx = ml - f;
        
        mu = circshift(f, [-1, 0]);
        mu(end, :) = 2*f(end, :) - f(end-1, :);
        dy = mu - f;
    else
        mr = circshift(f, [0,  1]);
        mr(:, 1) = 2*f(:, 1) - f(:, 2);
        dx = f - mr;
        
        md = circshift(f, [ 1, 0]);
        md(1, :) = 2*f(1, :) - f(2, :);
        dy = f - md;
    end
end