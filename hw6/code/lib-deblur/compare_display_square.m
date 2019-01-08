function compare_display(options)
    p1name = options.p1name;
    p1Sname = options.p1Sname;
    p2name = options.p2name;
    
    if ~default(options, 'no_truth', false)
        truth_path = sprintf('image/source/%s.%s', p1Sname, p2name);
        truth_image = imread(truth_path);
        display_truth = default(options, 'display_truth', true);
        kernel_path = sprintf('image/kernel/%s.bmp', options.kernel_name);
        kernel_image = imread(kernel_path);
    else
        display_truth = false;
    end
        
    image_path = sprintf('image/blurred/%s.png', p1name);
    result_image_path = sprintf('image/result/%s.png', p1name);
    deblur_kernel_path = sprintf('image/kernel-rec/%s.bmp', options.deblur_kernel_name);
    
    blurred_image = imread(image_path);
    if default(options, 'display_recover', true)
        display_recover = true;
        result_image = imread(result_image_path);
        deblur_kernel_image = imread(deblur_kernel_path);
    else
        display_recover = false;
    end
    
    details_coor = default(options, 'details', []);
    
    figure(15); clf
    if display_truth
        t_a = helper(truth_image, details_coor, [], [0 0.5 0.5]);
        axes(t_a.p_a)
        title(sprintf('Ground truth (%dx%d)', size(truth_image, 1), size(truth_image, 2)))
    end
    
    
    if ~default(options, 'no_truth', false)
        b_a = helper(blurred_image, details_coor, kernel_image, [0 0 0.5]);
        axes(b_a.p_a)
        bpsnr = psnr(blurred_image, truth_image);
        title(['Blurred image; psnr: ' num2str(bpsnr)])
        axes(b_a.k_a)
        title(sprintf('(%dx%d)', size(kernel_image, 1), size(kernel_image, 2)))
    else
        b_a = helper(blurred_image, details_coor, [], [0 0 0.5]);
        axes(b_a.p_a)
        title('Blurred image')
    end
    if display_recover
        r_a = helper(result_image, details_coor, deblur_kernel_image, [0.5 0 0.5]);
        axes(r_a.k_a)
        title(sprintf('(%dx%d)', size(deblur_kernel_image, 1), size(deblur_kernel_image, 2)))
        axes(r_a.p_a)
        if ~default(options, 'no_truth', false)
            rpsnr = psnr(result_image, truth_image);
            title(['Recovered image; psnr: ' num2str(rpsnr)])
        else
            title('Recovered image')
        end
    end

    set(gcf, 'Position', [488 212 619 572])
end

function a = helper(image, coor, kernel, si)
    m = 0.015;
    colors = {[255 0 0], [0 255 0], [0 0 255]};
    
    a.d_a = cell(min(3, size(coor, 1)), 1);
    for i = 1:min(3, size(coor, 1))
        a.d_a{i} = axes('Position', c([0.23*(i-1)+0.04+m 0+m 0.23-2*m 0.25-2*m], si));
        a.d_a{i}.ActivePositionProperty = 'position';
        patch = get_patch(image, coor(i, :));
        imshow(padcolor(patch, colors{i}), 'InitialMagnification', 'fit')
        image = bI(image, coor(i, :), colors{i});
    end
    a.p_a = axes('OuterPosition', c([0 0.25 1 0.75], si));
    a.p_a.ActivePositionProperty = 'outerposition';
    imshow(image, 'InitialMagnification', 'fit')
    if numel(kernel) > 0
        a.k_a = axes('Position', c([0.73+m 0+m 0.23-2*m 0.25-2*m], si));
        a.k_a.ActivePositionProperty = 'position';
        imshow(kernel, 'InitialMagnification', 'fit')
    end
end

function I = bI(I, coor, co)
    thickness = 3;
    lout = coor(1)-coor(3)-thickness;
    lin = coor(1)-coor(3)-1;
    rout = coor(1)+coor(3)+thickness;
    rin = coor(1)+coor(3)+1;
    tout = coor(2)-coor(4)-thickness;
    tin = coor(2)-coor(4)-1;
    bout = coor(2)+coor(4)+thickness;
    bin = coor(2)+coor(4)+1;
    
    content = repmat(permute(co, [1 3 2]), rout-lout+1, tin-tout+1, 1);
    
    I(lout:rout, tout:tin, :) = content;
    I(lout:rout, bin:bout, :) = content;
    I(lout:lin, tout:bout, :) = permute(content, [2 1 3]);
    I(rin:rout, tout:bout, :) = permute(content, [2 1 3]);
end

function patch2 = padcolor(patch, color)
    thickness = 3;
    patch2 = zeros(size(patch) + [2 2 0]*thickness, 'like', patch);
    for i = 1:size(patch, 3)
        patch2(:, :, i) = padarray(patch(:, :, i), [1 1]*thickness, color(i));
    end
end

function cc = c(coor, si)
    xo = si(1); yo = si(2); s = si(3);
    cc = [coor(1)*s+xo coor(2)*s+yo coor(3)*s coor(4)*s];
end

function p = get_patch(image, coor)
    p = image(coor(1)-coor(3):coor(1)+coor(3), coor(2)-coor(4):coor(2)+coor(4), :);
end