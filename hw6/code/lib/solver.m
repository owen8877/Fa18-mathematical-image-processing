function u = solver(f, kernel, boundCond, lambda, options)
    A = @(x) imfilter(x, kernel, boundCond);
%     Wkernel = [0 0 0; -1 0 1; 0 0 0] / 2;
    Wkernel = [-1 0 1] / 2;
    fshape = size(f);
    
    switch boundCond
        case 'homogeneous'
            At = @(x) imfilter(x, kernel, 0, 'conv');
            W = @(x) W0func(x, Wkernel);
            Wt = @(x) W0tfunc(x, Wkernel);
        otherwise
            difference = readDifference(kernel, fshape, options)';
            At = @(x) imfilter(x, kernel, 0, 'conv') + reshape(difference * reshape(x, prod(fshape), 1), fshape);
            W = @(x) Wrfunc(x, Wkernel);
            Wt = @(x) Wrtfunc(x, Wkernel);
    end
    
    WtW = @(x) Wt(W(x));
    u = ADMM(A, At, f, W, Wt, WtW, lambda, options);
end

function g = W0func(x, Wkernel)
    g = [imfilter(x, Wkernel); imfilter(x, Wkernel')];
end

function g = W0tfunc(x, Wkernel)
    x1 = x(1:end/2, :);
    x2 = x(end/2+1:end, :);
    g = imfilter(x1, Wkernel, 'conv') + imfilter(x2, Wkernel', 'conv');
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

function diff = readDifference(kernel, fshape, options)
%     if ~isfield(options, 'diff_operator')
%         error('Must provide path to difference boundary operator!');
%     end
%     
%     file_path = options.diff_operator;
%     if exist(file_path, 'file')
%         data = load(file_path);
%         diff = data.diff;
%     else
%         diff = borderOp(kernel, fshape);
%         save(file_path, 'diff');
%     end
    diff = borderOp(kernel, fshape);
end