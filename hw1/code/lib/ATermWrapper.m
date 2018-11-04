function ATerm = ATermWrapper(A, shape)
    ATerm = @(xvec) ATermCore(A, xvec, shape);
end

function yvec = ATermCore(A, xvec, shape)
    x = reshape(xvec, shape);
    y = A(x);
    yvec = reshape(y, numel(y), 1);
end