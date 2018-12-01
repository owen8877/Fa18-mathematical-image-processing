function A = imfOperator(s, kernel, options)
    padding = default(options, 'padding', 'omit');
    switch padding
        case 'omit'
            A = omit(s, kernel);
        case 'symmetric'
            A = symmetric(s, kernel);
        case 'replicate'
            A = replicate(s, kernel);
        case 'circular'
            A = circular(s, kernel);
        otherwise
            error('Don`t know padding method %s.', padding)
    end
end

function [i, j, v] = shift_block(m, k)
    s = numel(k); t = (s+1)/2;
    all_n = (2*m-t)*(t-1)+m;
    i = zeros(1, all_n);
    j = zeros(1, all_n);
    v = zeros(1, all_n);
    
    i(1:m) = 1:m; j(1:m) = 1:m; v(1:m) = k(t); count = m;
    for l = 2:t
        i((1:m+1-l)+count) = 1:m+1-l;
        j((1:m+1-l)+count) = l:m;
        v((1:m+1-l)+count) = k(t+l-1);
        count = count + (m+1-l);
        
        i((1:m+1-l)+count) = l:m;
        j((1:m+1-l)+count) = 1:m+1-l;
        v((1:m+1-l)+count) = k(t+l-1);
        count = count + (m+1-l);
    end
end

function A = omit(si, kernel)
    m = si(1); n = si(2); s = size(kernel, 1); t = (s+1)/2;
    
    one_n = (2*m-t)*(t-1)+m;
    block_n = (2*n-t)*(t-1)+n;
    all_n = one_n * block_n;
    i = zeros(1, all_n);
    j = zeros(1, all_n);
    v = zeros(1, all_n);
    
    count = 0;
    [i_, j_, v_] = shift_block(m, kernel(:, t));
    for l = 1:n
        i((1:one_n)+count*block_n) = i_ + (l-1)*m;
        j((1:one_n)+count*block_n) = j_ + (l-1)*m;
        v((1:one_n)+count*block_n) = v_;
        count = count + 1;
    end
    
    for o = 2:t
        [i_, j_, v_] = shift_block(m, kernel(:, t-1+o));
        for l = 1:n+1-o
            i((1:one_n)+count*block_n) = i_ + (l-1)*m;
            j((1:one_n)+count*block_n) = j_ + (l-2+o)*m;
            v((1:one_n)+count*block_n) = v_;
            count = count + 1;
        end
        
        [i_, j_, v_] = shift_block(m, kernel(:, t+1-o));
        for l = 1:n+1-o
            i((1:one_n)+count*block_n) = i_ + (l-2+o)*m;
            j((1:one_n)+count*block_n) = j_ + (l-1)*m;
            v((1:one_n)+count*block_n) = v_;
            count = count + 1;
        end
    end
    
    A = sparse(i, j, v);
end