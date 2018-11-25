function [fx, fy] = dc(f, lr, ud)
    [ml, mr, mu, md] = move(f, lr, ud);
    if lr
        fx = (ml - mr) / 2;
    else
        fx = [];
    end
    if ud
        fy = (mu - md) / 2;
    else
        fy = [];
    end
end

function [ml, mr, mu, md] = move(f, lr, ud)
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
    
    if lr
        ml(:, end) = 2*f(:, end) - f(:, end-1);
        mr(:, 1) = 2*f(:, 1) - f(:, 2);
    end
    if ud
        mu(end, :) = 2*f(end, :) - f(end-1, :);
        md(1, :) = 2*f(1, :) - f(2, :);
    end
end