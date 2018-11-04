function u = solver(f, blurFunc, lambda, options)
    A = blurFunc;
    W = @Wfunc;
    Wt = @Wtfunc;
    u = ADMM(A, f, W, Wt, lambda, options);
end

% symmetric
function g = Wfunc(x)
    g1 = x * 0;
    g1(:, 1) = (x(:, 2) - x(:, 1)) / 2;
    g1(:, 2:end-1) = (x(:, 3:end) - x(:, 1:end-2)) / 2;
    g1(:, end) = (x(:, end) - x(:, end-1)) / 2;
    g2 = x * 0;
    g2(1, :) = (x(2, :) - x(1, :)) / 2;
    g2(2:end-1, :) = (x(3:end, :) - x(1:end-2, :)) / 2;
    g2(end, :) = (x(end, :) - x(end-1, :)) / 2;
    g = [g1; g2];
end

function g = Wtfunc(x)
    x1 = x(1:end/2, :);
    x2 = x(end/2+1:end, :);
    
    g1 = x1 * 0;
    g1(:, 1) = (x1(:, 2) + x1(:, 1)) / (-2);
    g1(:, 2:end-1) = (x1(:, 1:end-2) - x1(:, 3:end)) / 2;
    g1(:, end) = (x1(:, end) + x1(:, end-1)) / 2;
    g2 = x2 * 0;
    g2(1, :) = (x2(2, :) + x2(1, :)) / (-2);
    g2(2:end-1, :) = (x2(1:end-2, :) - x2(3:end, :)) / 2;
    g2(end, :) = (x2(end, :) + x2(end-1, :)) / 2;
    g = g1 + g2;
end

% % symmetric - one side
% function g = Wfunc(x)
%     g1 = x * 0;
%     g1(:, 1:end-1) = x(:, 2:end) - x(:, 1:end-1);
%     g2 = x * 0;
%     g2(1:end-1, :) = x(2:end, :) - x(1:end-1, :);
%     g = [g1; g2];
% end
% 
% function g = Wtfunc(x)
%     x1 = x(1:end/2, :);
%     x2 = x(end/2+1:end, :);
%     
%     g1 = x1 * 0;
%     g1(:, 1:end-1) = x1(:, 1:end-1);
%     g1(:, 2:end) = g1(:, 2:end) - x1(:, 1:end-1);
%     g2 = x2 * 0;
%     g2(1:end-1, :) = x2(1:end-1, :);
%     g2(2:end, :) = g2(2:end, :) - x2(1:end-1, :);
%     g = g1 + g2;
% end

% % circular
% function g = Wfunc(x)
%     g1 = (circshift(x, [0, -1]) - circshift(x, [0, 1])) / 2;
%     g2 = (circshift(x, [-1, 0]) - circshift(x, [1, 0])) / 2;
%     g = [g1; g2];
% end
% 
% function g = Wtfunc(x)
%     x1 = x(1:end/2, :);
%     x2 = x(end/2+1:end, :);
%     
%     g1 = (circshift(x1, [0, 1]) - circshift(x1, [0, -1])) / 2;
%     g2 = (circshift(x2, [1, 0]) - circshift(x2, [-1, 0])) / 2;
%     g = g1 + g2;
% end