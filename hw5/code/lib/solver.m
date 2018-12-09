function [u, Irgb] = solver(f, options)
    addpath wavelet-lib
    
    % type of wavelet frame used: 0 is Haar; 1 is piecewise linear; 3 is piecewise cubic
    wavelet_type = default(options, 'wavelet_frame', 'pw-linear');
    switch wavelet_type
        case 'haar'
            frame = 0;
        case 'pw-linear'
            frame = 1;
        case 'pw-cubic'
            frame = 3;
        otherwise
            error('Cannot handle wavelet frame of type: %s.\n', wavelet_type);
    end
    % level of decomposition, typically 1-4.
    Level = default(options, 'wavelet_level', 2);
    
    [D, R] = GenerateFrameletFilter(frame);
    W  = @(x) Wfunc(x, D, Level);  % Frame decomposition
    Wt = @(y) WtFunc(y, R, Level, frame); % Frame reconstruction

    shape = size(f);
    xs = linspace(0, 1, shape(1))'; ys = linspace(0, 1, shape(2));
    v = (1 - min(xs.*(1-xs), ys.*(1-ys)) * 4) .^ default(options, 'model_init_pow', 3);
    
    alpha = default(options, 'model_alpha', 0.02);
    sigma = default(options, 'model_sigma', 50/255);
    Wf_n = FraDecMultiLevel2D(f/255, D, Level);
    lambda = zeros(Level*(frame+2), frame+2);
    for i = 1:frame+2
        for j = 1:frame+2
            for l = 1:Level
                lambda((l-1)*(frame+2)+i, j) = sum(sum(Wf_n{l}{i, j}.^2));
            end
        end
    end
    lambda = alpha ./ (1+sigma*lambda)
    
    [u, Irgb] = ADMM(lambda, f, W, Wt, v, options);
end

function y = Wfunc(x, D, level)
    y_cell = FraDecMultiLevel2D(x, D, level);
    y = cell_to_mat(y_cell);
end

function x = WtFunc(y, R, level, frame)
    y_cell = mat_to_cell(y, frame+2, level);
    x = FraRecMultiLevel2D(y_cell, R, level);
end