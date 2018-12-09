clear; %clc

N = 100;
R = 30; S = 10;

x = -(N/2-1/2):1:(N/2-1/2); y = x;
[X, Y] = meshgrid(x, y);

p1x = linspace(S, R, 7); p1y = linspace(S, 0, 7);
p1 = [p1x; p1y];
p2 = [p1x; -p1y];
point_data = [p1 p2];
point_data = [point_data -point_data];
point_data = [point_data flipud(point_data)];

phi = Inf(N);
for i = 1:size(point_data, 2)
    x1 = point_data(1, i); y1 = point_data(2, i);
    phi = min(phi, sqrt((X-x1).^2+(Y-y1).^2));
end

mesh(phi)

f = (abs(X)+abs(Y)) <= R;

save data_2d/new.mat f phi