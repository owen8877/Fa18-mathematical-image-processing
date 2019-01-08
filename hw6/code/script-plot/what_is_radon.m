clear; %clc

kernel = double(rgb2gray(imread('../image/kernel/syn5.bmp')));

figure(1); clf;

s1 = subplot(1, 2, 1); hold(s1, 'on');
imshow(kernel./max(kernel, [], 'all'), [], 'InitialMagnification', 'fit');
% axis on;

theta = 1;

arrow([8 8], [16 8], [17 8], 'x')
arrow([8 8], [8 16], [8 17], 'y')
line([8 8] + [cos(theta) -cos(theta)]*8*sqrt(2), [8 8] + [sin(theta) -sin(theta)]*8*sqrt(2), ...
    'Color', 'm', 'LineStyle', '--')

s2 = subplot(1, 2, 2); hold(s2, 'on');
[R, xp] = radon(kernel, theta/pi*180);
plot(xp, R)
xlabel('\rho'); ylabel('\phi')
title('Radon transform at \theta=1')

set(gcf, 'Position', [221 338 907 348])

function arrow(p1, p2, pt, t)
    dp = p2 - p1;
    quiver(p1(1), p1(2), dp(1), dp(2), 0)
    text(pt(1), pt(2), t, 'FontSize', 25)
end