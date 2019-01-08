function s = gradientHelper()
    s.Wr = @Wrfunc;
    s.Wrt = @Wrtfunc;
    s.Wkernel = [-1 0 1] / 2;
end

function g = Wrfunc(x, Wkernel)
    g = [imfilter(x, Wkernel, 'replicate'); imfilter(x, Wkernel', 'replicate')];
end

function g = Wrtfunc(x, Wkernel)
    x1 = x(1:end/2, :);
    x2 = x(end/2+1:end, :);
    g = imfilter(x1, Wkernel, 'replicate', 'conv') + imfilter(x2, Wkernel', 'replicate', 'conv');
    g(:, end) = g(:, end) + x1(:, end)/2;
    g(:, 1) = g(:, 1) - x1(:, 1)/2;
    g(end, :) = g(end, :) + x2(end, :)/2;
    g(1, :) = g(1, :) - x2(1, :)/2;
end