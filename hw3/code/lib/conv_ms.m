function [v, clips] = conv_ms(I, options)
    maxItr = default(options, 'admm_max_itr', 400);
%     dt = default(options, 'pde_dt', 5e-2);
%     boundCond = default(options, 'pde_boundary_condition', 'replicate');
    refreshN = default(options, 'admm_refreshN', 10);
%     reinitStep = default(options, 'pde_reinitStep', 15);
%     clipCount = default(options, 'solver_clip_count', 6);
    alpha = default(options, 'admm_alpha', 2);
%     gradientLB = default(options, 'pde_gradient_lb', 1);
%     shadow = default(options, 'solver_shadow', 'positive');
%     init_offset = default(options, 'pde_initial_offset', 0.01);
%     save_file = default(options, 'solver_save_file', '');
    mu = default(options, 'admm_mu', 0.5);
    
    if mod(clipCount, 2) ~= 0
        error('Clip count must be even!')
    end
    
    g = @(x) 1 ./ (1+alpha*x.^2);
    
    [Ix, Iy, ~, ~, ~] = derivative(I, boundCond);
    ggI = g(sqrt(max(Ix.^2+Iy.^2, gradientLB)));
    [ggIx, ggIy, ~, ~, ~] = derivative(ggI, boundCond);
    ggIxp = max(ggIx, 0);
    ggIxn = min(ggIx, 0);
    ggIyp = max(ggIy, 0);
    ggIyn = min(ggIy, 0);
    
    itr = 1;

    shape = size(I); clips = zeros([shape(1)*2 shape(2)*clipCount/2 3], 'uint8');
    clipdt = maxT / clipCount - 1e-6; clipIndex = 0;
    
    fprintf('maxItr set to %.2f.\n', maxItr)
    while itr <= maxItr
        
        if time >= (clipIndex+1)*clipdt
            if clipIndex < clipCount / 2
                clips(1:end/2, clipIndex*shape(2)+1:(clipIndex+1)*shape(2), :) = uint8(Irgb);
            else
                cc = clipIndex - clipCount / 2;
                clips(end/2+1:end, cc*shape(2)+1:(cc+1)*shape(2), :) = uint8(Irgb);
            end
            clipIndex = clipIndex + 1;
            figure(11); subplot(2, clipCount/2, clipIndex)
            imshow(uint8(Irgb))
            title(['Time=' num2str(time)])
        end
        
        if mod(itr, refreshN) == 0
            fprintf('Refresh at itr=%d!\n', itr)
            figure(8); clf; hold on
            Irgb = zeros(shape(1), shape(2), 3);
            switch shadow
                case 'zero'
                    selection = abs(I_n-mu) < 0.05;
                    Imod1 = I; Imod2 = I; Imod3 = I;
                    Imod1(selection) = 255;
                    Imod2(selection) = 0;
                    Imod3(selection) = 0;
                    Irgb(:, :, 1) = Imod1; Irgb(:, :, 2) = Imod2; Irgb(:, :, 3) = Imod3;
                case 'positive'
                    selection = I_n > mu;
                    Imod1 = I;
                    Imod1(selection) = Imod1(selection) + 100;
                    Irgb(:, :, 1) = Imod1; Irgb(:, :, 2) = I; Irgb(:, :, 3) = I;
            end
            imshow(uint8(Irgb))
        end

        itr = itr + 1;
    end
end