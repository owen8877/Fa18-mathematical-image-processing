clear; %clc

addpath lib

N = 2e4;
lambda = 2;
f = rand(N, 1);
A = sparse(randi(N, 4*N, 1), randi(N, 4*N, 1), rand(4*N, 1));
A = (A+A') / 2;
W = speye(N);

ADMM(@(x) A*x, f, @(x) W*x, lambda, struct('mu', 3));