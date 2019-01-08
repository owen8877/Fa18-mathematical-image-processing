clear; %clc

addpath lib-mat lib-util lib

f_blurred = double(imread('image/blurred/Wall_834.png'));

% avg_size = 7;
% p1name = 'people'; p2name = 'jpg';
% image_path = sprintf('image/source/%s.%s', p1name, p2name);
% output_path = sprintf('image/source/%s_dark.png', p1name);

% f_blurred = getDarkChannel(f_blurred, avg_size);

Wstruct = gradientHelper();

%% First apply shockfilter
soptions = struct();
soptions.pde_dt = 1e-2;
soptions.pde_maxTime = 0;
soptions.pde_plot = true;
f_shock = pmpde(f_blurred, soptions);
imshow(f_shock ./ 255)

% blur_kernel = fspecial('gaussian', 11, 0.5);
% f_shock_blurred = imfilter(f_shock, blur_kernel);
f_shock_blurred = f_shock;

%% 
g = Wstruct.Wr(f_blurred, Wstruct.Wkernel);
g = sqrt(g(1:end/2, :, :).^2 + g(1+end/2:end, :, :).^2);
gsb = Wstruct.Wr(f_shock_blurred, Wstruct.Wkernel);
gsb = sqrt(gsb(1:end/2, :, :).^2 + gsb(1+end/2:end, :, :).^2);

g_copy = g;
g_shape = size(g);
g_vec = reshape(gsb, prod(g_shape), 1);
[~, sidx] = sort(g_vec, 'descend');
box_size = 15;

known_kernel = normalizeFirst(double(imread('image/kernel/syn9.bmp')));
known_kernel = padarray(known_kernel, [1 1] * (box_size-(size(known_kernel, 1)-1)/2), 0, 'both');

offset = floor(prod(g_shape)*0.00);
maxN = floor(prod(g_shape)*0.1);
candidate = zeros(maxN, 2);
information = cell(maxN, 1);
counter = 1;

[~, xp] = radon(zeros(2*box_size+1), 0);
xpWidth = xp(end);

% poStep = pi/180 * 3;
% poCounter = zeros(ceil(pi/poStep), 1);
% poCrit = maxN/(pi/poStep);
% poEffect = true;

% imshow(gsb./max(gsb, [], 'all'))
% return

plotOn = true;
for swp_idx = offset+1:maxN
    idx = sidx(swp_idx);
    if g_copy(idx) < 0
        continue
    end
    
    [i, j, colorCh] = ind2sub(g_shape, idx);
    if i <= box_size || i > g_shape(1)-box_size || j <= box_size || j > g_shape(2)-box_size
        continue
    end
    
    g_copy(i-box_size:i+box_size, j-box_size:j+box_size, :) = -1;
    
    gradient_patch = g(i-box_size:i+box_size, j-box_size:j+box_size, colorCh);
    x_coor = repmat(-box_size:box_size, [2*box_size+1, 1]); y_coor = -x_coor';

    % use gradient descend
    ngp = normalizeFirst(gradient_patch);
    lossFunc = @(th) sum(sum((y_coor*cos(th) - x_coor*sin(th)).^2.*ngp));
    gFunc = @(th) 2*sum(sum((x_coor*sin(th) - y_coor*cos(th)).*(y_coor*sin(th) + x_coor*cos(th)).*ngp));
    g_options.max_itr = 50;
    g_options.L = 50;
    [theta, loss] = simple_gradient(0, lossFunc, gFunc, g_options);

%     fprintf('Loss is %.3e.\n', loss)
    
    lossness = loss / box_size^2;
    if lossness > 0.25
        continue
    end
    fprintf('Patch @(% 5d, % 5d), loss %.1f.\n', i, j, loss)
    
%     if poEffect
%         poIndex = floor((theta+pi/2) / poStep);
%         if poCounter(poIndex) > poCrit
%             fprintf('Too many samples around theta~%d!\n', floor(theta/pi*180));
%         end
%         poCounter(poIndex) = poCounter(poIndex) + 1;
%     end
    
    %%
    color_patch = f_blurred(i-box_size:i+box_size, j-box_size:j+box_size, colorCh);

    weight = max(max(gradient_patch)) - gradient_patch;
    % c1
    area1_mask = y_coor*cos(theta) - x_coor*sin(theta) > box_size / 2;
    c1 = sum(sum(area1_mask .* weight .* color_patch)) / sum(sum(area1_mask .* weight));
    % c2
    area2_mask = y_coor*cos(theta) - x_coor*sin(theta) < -box_size / 2;
    c2 = sum(sum(area2_mask .* weight .* color_patch)) / sum(sum(area2_mask .* weight));
    % cinbetween
    areain_mask = ~(area1_mask | area2_mask);
    cinbetween = sum(sum(areain_mask .* weight .* color_patch)) / sum(sum(areain_mask .* weight));
    
    if (cinbetween - c1) * (cinbetween - c2) > 0
        fprintf('Color sequence: %.2f->%.2f->%.2f, rejected.\n', c2, cinbetween, c1);
        continue
    end
    
    % BH
    BH = (color_patch - c2) / (c1-c2);

    coor1d = y_coor * cos(theta) - x_coor * sin(theta);
    coor1d = reshape(coor1d, [(2*box_size+1)^2 1]);
    [coor1d, coorIdx] = sort(coor1d);

    proj_BH = reshape(BH, [(2*box_size+1)^2 1]);
    proj_BH = proj_BH(coorIdx);

    rasterN = 4*xpWidth+2;
    raster_BH = zeros(rasterN, 1);
    for l = 1:rasterN
        cond1 = -xpWidth-1+l/2 <= coor1d;
        cond2 = coor1d < -xpWidth-0.5+l/2;
        raster_BH(l) = mean(proj_BH(cond1 & cond2));
    end
    
    if max(raster_BH) > 1.5
        continue
    end
    
    % clean raster_BH
%     [~, minid] = min(isnan(raster_BH));
%     [~, maxid] = min(isnan(flipud(raster_BH))); maxid = numel(raster_BH)+1-maxid;
    
    hcoor = -(xpWidth + 0.25):0.5:(xpWidth + 0.25);
    raster_BH = interp1(hcoor(~isnan(raster_BH)), raster_BH(~isnan(raster_BH)), hcoor, 'linear');
    raster_BH = interp1(hcoor(~isnan(raster_BH)), raster_BH(~isnan(raster_BH)), hcoor, 'nearest', 'extrap');
    raster_BH = max(0, min(raster_BH, 1));
    
    raster_gradient = imfilter(raster_BH, [-1 1], 'replicate')';
    raster_gradient = max(raster_gradient, 0);
    center = sum(hcoor * raster_gradient) / sum(raster_gradient);

    h_BH = interp1(hcoor-center, raster_BH, xp, 'linear', 'extrap');
    
    grid_gradient = imfilter(h_BH', [-1 0 1]/2, 'replicate')';
    grid_gradient = max(grid_gradient, 0);
    grid_gradient = flipud(grid_gradient);
    
    if sum(grid_gradient) < 0.1
        fprintf('Possibly negative gradient, rejected!\n')
        continue
    end
    
    R_truth = radon(known_kernel, theta/pi*180+90);
    if plotOn
        figure(7); clf;
        
        subplot(1, 3, 1); title('gradient');
        imshow(range01First(gradient_patch), [], 'InitialMagnification', 'fit');
        
        subplot(1, 3, 2); title('BH');
        imshow(BH)
        
        s3 = subplot(1, 3, 3); title('projection'); hold(s3, 'on')
        plot(xp, flipud(grid_gradient), 'rs-', 'DisplayName', 'grid gradient')
        plot(hcoor, raster_BH, 'b-', 'DisplayName', 'raster BH')
        plot(xp, cumsum(flipud(R_truth)), 'm:', 'DisplayName', 'BH truth')
        plot(xp, flipud(R_truth), 'k:', 'DisplayName', 'R truth')
        legend
    end
    
    candidate(counter, :) = [i j];
    info = struct();
    info.theta = theta + pi/2;
    info.phi = grid_gradient;
    info.lossness = lossness;
    info.t = R_truth;
    information{counter} = info;
    counter = counter + 1;
    g_copy(i-box_size:i+box_size, j-box_size:j+box_size, :) = -1;
    
    set(gcf, 'Position', [100 237 1376 420])
end

figure(6); clf
counter = counter - 1;
candidate = candidate(1:counter, :);
% information = information{1:counter};
% f_anno = boximg(f_blurred_d, candidate, box_size);
% imshow(uint8(f_anno))
g_d = Wstruct.Wr(f_blurred, Wstruct.Wkernel);
g_d = sqrt(g_d(1:end/2, :, :).^2 + g_d(1+end/2:end, :, :).^2);
f_anno = boximg(g_d./max(max(g_d))*255, candidate, box_size);
imshow(f_anno./max(max(f_anno)), [])

save('test.mat', 'information', 'counter', 'box_size', 'xp')