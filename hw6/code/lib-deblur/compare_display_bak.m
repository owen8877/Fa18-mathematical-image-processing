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
%         result_image = insertKernel(result_image, deblur_kernel_image);
    else
        display_recover = false;
    end
    
    if ~default(options, 'no_truth', false)
%         blurred_image = insertKernel(blurred_image, kernel_image);
    end
    
    if display_truth
        index.t = 1; index.b = 2;
        if display_recover
            all_subplots = 3;
            index.r = 3;
        else
            all_subplots = 2;
        end
    else
        index.b = 1;
        if display_recover
            all_subplots = 2;
            index.r = 2;
        else
            all_subplots = 1;
        end
    end
    
    figure(15); clf
    if display_truth
        subplot(4, all_subplots*2, subplotGroup(all_subplots, index.t))
        set(gca, 'LooseInset', [0,0,0,0]);
        imshow(truth_image, 'InitialMagnification', 'fit')
        title(sprintf('Ground truth\n(%dx%d)', size(truth_image, 1), size(truth_image, 2)))
    end
    subplot(4, all_subplots*2, subplotGroup(all_subplots, index.b))
    set(gca, 'LooseInset', [0,0,0,0]);
    imshow(blurred_image, 'InitialMagnification', 'fit')
    title('Blurred image')
    if ~default(options, 'no_truth', false)
        bpsnr = psnr(blurred_image, truth_image);
        title(['Blurred image\newlinepsnr: ' num2str(bpsnr)])
        subplot(4, all_subplots*2, index.b*2+all_subplots*4)
        set(gca, 'LooseInset', [0,0,0,0]);
        imshow(kernel_image, 'InitialMagnification', 'fit')
        title(sprintf('Known kernel\n(%dx%d)', size(kernel_image, 1), size(kernel_image, 2)))
    end
    if display_recover
        subplot(4, all_subplots*2, subplotGroup(all_subplots, index.r))
        set(gca, 'LooseInset', [0,0,0,0]);
        imshow(result_image, 'InitialMagnification', 'fit')
        title('Recovered image')
        if ~default(options, 'no_truth', false)
            rpsnr = psnr(result_image, truth_image);
            title(['Recovered image\newlinepsnr: ' num2str(rpsnr)])
        end
        subplot(4, all_subplots*2, index.r*2+all_subplots*4)
        set(gca, 'LooseInset', [0,0,0,0]);
        imshow(deblur_kernel_image, 'InitialMagnification', 'fit')
        title(sprintf('Recovered kernel\n(%dx%d)', size(deblur_kernel_image, 1), size(deblur_kernel_image, 2)))
    end
    
    switch all_subplots
        case 2
            set(gcf, 'Position', [398 302 550 412])
        case 3
            set(gcf, 'Position', [398 302 747 412])
    end
end

function s = subplotGroup(all_subplots, i)
    s = [2*i-1 2*i 2*i-1+all_subplots*2 2*i+all_subplots*2];
end

function I = insertKernel(I, kernel)
    offset = floor(min(size(I, 1), size(I, 2)) / 20);
    if size(kernel, 3) < size(I, 3)
        kernel = repmat(kernel, [1 1 size(I, 3)]);
    end
    I(end-offset-size(kernel, 1)+1:end-offset, offset+1:offset+size(kernel, 2), :) = kernel;
end
