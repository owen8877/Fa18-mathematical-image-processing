function g = boximg(g, cand, bs)
    shape = size(g);
    if numel(shape) == 3
        g_copy = zeros(shape + [2 2 0]*bs);
        g_copy(bs+1:end-bs, bs+1:end-bs, :) = g;
        cshape = [1 1 3];
    else
        g_copy = zeros(shape + [2 2]*bs);
        g_copy(bs+1:end-bs, bs+1:end-bs) = g;
        cshape = [1 1];
    end
    
    for i = 1:size(cand, 1)
        c = randi(256, cshape) - 1;
        x = cand(i, 1); y = cand(i, 2);
        
        ch = repmat(c, [1 2*bs+1 1]);
        cv = repmat(c, [2*bs+1 1 1]);
        g_copy(x, y:y+2*bs, :) = ch;
        g_copy(x+2*bs, y:y+2*bs, :) = ch;
        g_copy(x:x+2*bs, y, :) = cv;
        g_copy(x:x+2*bs, y+2*bs, :) = cv;
    end
    
    g = g_copy(bs+1:end-bs, bs+1:end-bs, :);
end

