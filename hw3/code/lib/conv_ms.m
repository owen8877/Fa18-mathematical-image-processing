function [u, clips] = conv_ms(I, options)
    maxItr = default(options, 'admm_max_itr', 8);
    refreshN = default(options, 'admm_refreshN', 10);
    clipCount = default(options, 'solver_clip_count', 6);
    alpha = default(options, 'admm_alpha', 0);
    shadow = default(options, 'solver_shadow', 'positive');
    mu = default(options, 'admm_mu', 1);
    avg = default(options, 'admm_avg', 0.5);
    lambda = default(options, 'admm_lambda', 1.618);
    
    if mod(clipCount, 2) ~= 0
        error('Clip count must be even!')
    end
    
    I_n = I / 256;
    u = I_n;
    selection = u > avg;
    c1 = meanHelper(I_n, selection);
    c2 = meanHelper(I_n, ~selection);
    bx = 0*u; by = bx; dx = bx; dy = dx;
    
    g = @(x) 1 ./ (1+alpha*x.^2);
    [dInx, dIny] = dc(I_n, true, true);
    gMat = g(sqrt(dInx.^2 + dIny.^2));
    
    itr = 1;

    shape = size(I); clips = zeros([shape(1)*2 shape(2)*clipCount/2 3], 'uint8');
    clipdt = maxItr / clipCount - 1e-6; clipIndex = 0;
    
    fprintf('maxItr set to %.2f.\n', maxItr)
    while itr <= maxItr
        r = (I_n-c1).^2 - (I_n-c2).^2;
        murdl = (mu/lambda) * r;
        for i = 1:20
            [ddxx, ~] = dc(dx, true, false);
            [~, ddyy] = dc(dy, false, true);
            [dbxx, ~] = dc(bx, true, false);
            [~, dbyy] = dc(by, false, true);
            alpha_ = - (ddxx + ddyy) + (dbxx + dbyy);
            beta = (imfilter(u, [0 1 0; 1 0 1; 0 1 0], 'replicate')-murdl+alpha_)/4;
            u = max(min(beta, 1), 0);
            
%             if mod(i, 3) == 0
%                 figure(6); subplot(2, 5, i/3)
%                 mesh(u)
%             end
        end
        [dux, duy] = dc(u, true, true);
        dx = soft_threshold(bx + dux, lambda, gMat);
        dy = soft_threshold(by + duy, lambda, gMat);
        bx = bx + (dux - dx)*lambda;
        by = by + (duy - dy)*lambda;
        selection = u > avg;
        c1 = meanHelper(I_n, selection);
        c2 = meanHelper(I_n, ~selection);
        
        if mod(itr, refreshN) == 0
            fprintf('Refresh at itr=%d!\n', itr)
            figure(8); clf; hold on
            Irgb = zeros(shape(1), shape(2), 3);
            switch shadow
                case 'zero'
                    selection = abs(u-avg) < 0.05;
                    Imod1 = I; Imod2 = I; Imod3 = I;
                    Imod1(selection) = 255;
                    Imod2(selection) = 0;
                    Imod3(selection) = 0;
                    Irgb(:, :, 1) = Imod1; Irgb(:, :, 2) = Imod2; Irgb(:, :, 3) = Imod3;
                case 'positive'
                    selection = u > avg;
                    Imod1 = I;
                    Imod1(selection) = Imod1(selection) + 100;
                    Irgb(:, :, 1) = Imod1; Irgb(:, :, 2) = I; Irgb(:, :, 3) = I;
            end
            imshow(uint8(Irgb))
        end
        
        if itr >= (clipIndex+1)*clipdt
            if clipIndex < clipCount / 2
                clips(1:end/2, clipIndex*shape(2)+1:(clipIndex+1)*shape(2), :) = uint8(Irgb);
            else
                cc = clipIndex - clipCount / 2;
                clips(end/2+1:end, cc*shape(2)+1:(cc+1)*shape(2), :) = uint8(Irgb);
            end
            clipIndex = clipIndex + 1;
            figure(11); subplot(2, clipCount/2, clipIndex)
            imshow(uint8(round(u))*255)
            title(['Itr=' num2str(itr)])
        end

        itr = itr + 1;
    end
end

function m = meanHelper(mat, mask)
    m = sum(sum(mat(mask))) / sum(sum(mask));
end