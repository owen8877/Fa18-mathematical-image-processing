function u = solver(f, blurFunc, lambda, options)
    addpath wavelet-lib
    A = blurFunc;
    
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

    switch default(options, 'solver_ADMM', 'analysis')
        case 'analysis'
            u = ADMM(A, f, W, Wt, lambda, options);
        case 'balanced'
            u = ADMM_bal(A, f, W, Wt, lambda, options);
    end
end

function y = Wfunc(x, D, level)
    y_cell = FraDecMultiLevel2D(x, D, level);
    y = cell_to_mat(y_cell);
end

function x = WtFunc(y, R, level, frame)
    y_cell = mat_to_cell(y, frame+2, level);
    x = FraRecMultiLevel2D(y_cell, R, level);
end