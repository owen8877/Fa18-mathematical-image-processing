clear; %clc

addpath wavelet-lib
addpath lib

[D, R] = GenerateFrameletFilter(0);
Level = 1;
W  = @(x) FraDecMultiLevel2D(x, D, Level); % Frame decomposition
Wt = @(x) FraRecMultiLevel2D(x, R, Level); % Frame reconstruction

N = 100;
RR = 30;

x = -N/2+1:N/2; y = x;
[X, Y] = meshgrid(x, y);
% phi = abs(abs(X)+abs(Y) - R);
phi = abs(sqrt(X.^2+Y.^2) - RR);
phi = tanh(phi/5);

u = sqrt(X.^2+Y.^2) < RR;
u = double(u);

d = W(u);