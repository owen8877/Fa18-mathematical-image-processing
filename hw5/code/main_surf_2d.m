function u = main_surf_2d(data_path, options)
    if nargin < 1
        data_path = 'data_2d/syn.mat';
    end
    if nargin < 2
        options = struct();
    end
    
    addpath lib
    addpath wavelet-lib
    
    data = load(data_path);
    
    %%
    % type of wavelet frame used: 0 is Haar; 1 is piecewise linear; 3 is piecewise cubic
    wavelet_type = default(options, 'wavelet_frame', 'haar');
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
    Level = default(options, 'wavelet_level', 1);
    
    [D, R] = GenerateFrameletFilter(frame);
    W  = @(x) FraDecMultiLevel2D(x, D, Level); % Frame decomposition
    Wt = @(x) FraRecMultiLevel2D(x, R, Level); % Frame reconstruction

    alpha = default(options, 'model_alpha', 0.02);
    options.additional_frame2 = frame+2;
    options.additional_Level = Level;
    
    %%
    tic
    u = ADMM_surf_2d(alpha*data.phi, data.f, W, Wt, options);
    toc
    
    if default(options, 'show', false)
        figure(2);
        az = -18.9146;
        el = 66.8937;
        subplot(2, 2, 1); view([az, el])
        mesh(data.f); title('Initial guess')
        subplot(2, 2, 2); view([az, el])
        mesh(data.phi); title('\phi')
        subplot(2, 2, 3); view([az, el])
        mesh(u); title('Reconstructed')
        subplot(2, 2, 4); view([az, el])
        contour(u, [1 1]*0.5); title('Reconstructed')
    end
    if isfield(options, 'result_path')
        save(options.result_path, 'u');
    end
end