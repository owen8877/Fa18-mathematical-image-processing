function [v, clips] = pde(I, options)
    maxT = default(options, 'pde_maxTime', 400);
    dt = default(options, 'pde_dt', 5e-2);
    boundCond = default(options, 'pde_boundary_condition', 'replicate');
    reinitN = default(options, 'pde_reinitN', 10);
    reinitStep = default(options, 'pde_reinitStep', 15);
    clipCount = default(options, 'solver_clip_count', 6);
    alpha = default(options, 'pde_alpha', 2);
    gradientLB = default(options, 'pde_gradient_lb', 1);
    shadow = default(options, 'solver_shadow', 'positive');
    init_offset = default(options, 'pde_initial_offset', 0.01);
    save_file = default(options, 'solver_save_file', '');
    mu = default(options, 'pde_mu', 10);
    
    if mod(clipCount, 2) ~= 0
        error('Clip count must be even!')
    end
    
    g = @(x) 1 ./ (1+mu*x.^2);
    
    [Ix, Iy, ~, ~, ~] = derivative(I, boundCond);
    ggI = g(sqrt(max(Ix.^2+Iy.^2, gradientLB)));
    [ggIx, ggIy, ~, ~, ~] = derivative(ggI, boundCond);
    ggIxp = max(ggIx, 0);
    ggIxn = min(ggIx, 0);
    ggIyp = max(ggIy, 0);
    ggIyn = min(ggIy, 0);
    
    itr = 1;
    time = dt;

    shape = size(I); clips = zeros([shape(1)*2 shape(2)*clipCount/2 3], 'uint8');
    clipdt = maxT / clipCount - 1e-6; clipIndex = 0;
    
    if exist(save_file, 'file')
        v_data = load(save_file);
        v = v_data.v;
    else
        xs = linspace(0, 1, shape(1))'; ys = linspace(0, 1, shape(2));
        v = init_offset - min(xs.*(1-xs), ys.*(1-ys));
    end
    fprintf('maxTime set to %.2f.\n', maxT)
    while time <= maxT + 1e-6
%         fprintf('Time: %.2f.\n', time)
        [vx, vy, vxx, vxy, vyy] = derivative(v, boundCond);
        gradient_vsq = max(vx.^2 + vy.^2, gradientLB);
        vnn = (vx.^2 .* vxx + 2 .* vx.*vy.*vxy + vy.^2 .* vyy) ./ gradient_vsq;
        
        divngv = vxx + vyy - vnn;
        ggIgv = ggI .* divngv;
        
        [dfxv, dfyv] = dfb(v, true);
        [dbxv, dbyv] = dfb(v, false);
        Dfv = sqrt(max(dbxv, 0).^2 + min(dfxv, 0).^2 + max(dbyv, 0).^2 + min(dfyv, 0).^2);
%         Dbv = sqrt(min(dbxv, 0).^2 + max(dfxv, 0).^2 + min(dbyv, 0).^2 + max(dfyv, 0).^2);
        gv = ggI .* Dfv;
        gggv = ggIxp.*dbxv + ggIxn.*dfxv + ggIyp.*dbyv + ggIyn.*dfyv;
        v = v + dt * (ggIgv.*divngv + alpha.*gv + gggv);
        
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
        
        if mod(itr, reinitN) == 0
            fprintf('R16n at time=%.2f!\n', time)
            v = Reinitial2D(v, reinitStep);
            figure(8); clf; hold on
            Irgb = zeros(shape(1), shape(2), 3);
            switch shadow
                case 'zero'
                    selection = abs(v) < 2e-3;
                    Imod1 = I; Imod2 = I; Imod3 = I;
                    Imod1(selection) = 255;
                    Imod2(selection) = 0;
                    Imod3(selection) = 0;
                    Irgb(:, :, 1) = Imod1; Irgb(:, :, 2) = Imod2; Irgb(:, :, 3) = Imod3;
                case 'positive'
                    selection = v > 0;
                    Imod1 = I;
                    Imod1(selection) = Imod1(selection) + 100;
                    Irgb(:, :, 1) = Imod1; Irgb(:, :, 2) = I; Irgb(:, :, 3) = I;
            end
            imshow(uint8(Irgb))
        end

        itr = itr + 1;
        time = time + dt;
    end
    
    if ~strcmp(save_file, '')
        save(save_file, 'v')
    end
end