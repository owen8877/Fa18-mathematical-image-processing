function u = main_3d(data_path, options)
    if nargin < 1
        data_path = 'data/statuette.mat';
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
    W  = @(x) FraDecMultiLevel3D(x, D, Level); % Frame decomposition
    Wt = @(x) FraRecMultiLevel3D(x, R, Level); % Frame reconstruction

    alpha = default(options, 'model_alpha', 0.02);
    options.additional_frame2 = frame+2;
    options.additional_Level = Level;
    
    %%
    tic
    u = ADMM_surf(alpha*data.phi, data.f, W, Wt, options);
    toc
    
    if default(options, 'show', false)
        figure(2);
        isosurface(permute(u, [3 1 2]), 0.5);
        title('Recovered surface')
    end
    if isfield(options, 'result_path')
        save(options.result_path, 'u');
    end
end