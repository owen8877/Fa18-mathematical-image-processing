function Irgb = contourHelper(figNum, shape, shadow, v, I)
    figure(figNum); clf;
    subplot(1, 2, 1)
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
    
    subplot(1, 2, 2)
    imagesc(v); colorbar
end