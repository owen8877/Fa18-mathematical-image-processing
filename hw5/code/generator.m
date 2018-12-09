clear; %clc

N = 100;
R = 30;

x = -N/2+1:N/2; y = x;
[X, Y] = meshgrid(x, y);
% phi = abs(abs(X)+abs(Y) - R);
M = 4;
phi = abs((X.^M+Y.^M).^(1/M) - R);
phi = tanh(phi/5).^3;

% f = sqrt(X.^2+Y.^2) > R;
% f1 = (abs(X)+abs(Y)) <= (R+1);
f2 = max(abs(X), abs(Y)) <= R;
% f = and(f1, f2);
f = f2;

mesh(phi)
figure(); mesh(f2)
save data_2d/syn.mat f phi