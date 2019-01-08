clear; %clc
addpath lib-mat
addpath lib-ADMM

load test.mat

% s = box_size;
s = 9;
[~, xps] = radon(zeros(2*s+1), 0);
thetas = zeros(counter, 1);
R = zeros(numel(xp), counter);
weights = ones(counter, 1);
Rt = zeros(numel(xp), counter);
thetaN = counter;

for i = 1:counter
    thetas(i) = information{i}.theta / pi * 180;
    R(:, i) = information{i}.phi';
    weights(i) = 2 - 8*information{i}.lossness;
    Rt(:, i) = information{i}.t;
%     if abs(thetas(i)-90) < 3
%         weights(i) = 0;
%     end
%     figure(11); clf; hold on
%     plot(xp, R(:, i), 'rs-', 'DisplayName', 'R')
%     plot(xp, Rt(:, i), 'bs-', 'DisplayName', 'Rt')
end

numdiff = (numel(xp) - numel(xps))/2;
R = R(numdiff+1:end-numdiff, :);
Rt = Rt(numdiff+1:end-numdiff, :);

[thetas, idx] = sort(thetas);
R = R(:, idx);
R = max(R, 0);
Rt = Rt(:, idx);
R = R ./ sum(R, 1);
% R = Rt;

%% clean data!
% sampleN_array = histcounts(thetas, 0:3:180);
% importance = 3 ./ sqrt(sampleN_array + 2);
% weights = weights .* (importance(floor(thetas/3)+1))';

%% blur operator
blurKernel = fspecial('gaussian', 9, 0.01);
% bl = @(x) imfilter(x, blurKernel);
bl = @(x) x;

%% using ADMM!
As = cell(thetaN, 1);
for i = 1:thetaN
    As{i} = @(x) bl(radon(x, thetas(i)));
end

Ats = cell(thetaN, 1);
coordinates = cell(thetaN, 1);
for i = 1:thetaN
    coordinates{i} = (-s:s)*cos(thetas(i)/180*pi) + (s:-1:-s)'*sin(thetas(i)/180*pi);
    Ats{i} = @(x) bl(2*interp1(xps, x, coordinates{i}));
end

phis = mat2cell(R, numel(xps), ones(1, thetaN));

% Wstruct = gradientHelper();
% W = @(x) Wstruct.Wr(x, Wstruct.Wkernel);
% Wt = @(x) Wstruct.Wrt(x, Wstruct.Wkernel);

Wstruct = gradientHelper_asym();
W = @(x) Wstruct.Wa(x, Wstruct.Wkernel);
Wt = @(x) Wstruct.Wat(x, Wstruct.Wkernel);

%%
options = struct();
options.ADMM_outInt = 1;
options.ADMM_CG0 = 1e-2;
options.ADMM_mus = [1 1] * thetaN;
options.muFor0 = thetaN;

% options.ADMM_MaxItr = 80;
% options.ADMM_quad_sign = true;
% lambdas = [5e-5 5e-5] * thetaN;

% options.ADMM_MaxItr = 80;
% options.ADMM_quad_sign = false;
% lambdas = [0.5e-5 5e-4] * thetaN;

% u = ADMM_2_cont(As, Ats, phis, zeros(2*s+1), W, Wt, lambdas, weights, options);

options.ADMM_MaxItr = 50;
lambdas = [5e-4 5e-2] * thetaN;
u = ADMM_2(As, Ats, phis, zeros(2*s+1), W, Wt, lambdas, weights, options);

imwrite(uint8(u/max(max(u))*256), 'image/kernel/guess.bmp', 'bmp')

%% Parameter:
% Wall_834.png + syn2: 2.5%, lambda=[1e-3 8e-2], itr=160, kernel=15*15,
%     loss_crit=0.25, opt_crit=3e-6
% Wall_834.png + syn4: 2.5%, lambda=[1e-3 5e-2], itr=260, kernel=23*23,
%     loss_crit=0.25, opt_crit=3e-6
% mountain2.jpg + syn1: 5%, lambda=[1e-3 5e-2], itr=160, kernel=15*15,
%     loss_crit=0.5, pde_dt=2e-3, pde_maxTime=0.3, opt_crit=3e-6
% street1.jpg + syn3: 2%, lambda=[5e-4 7e-2], itr=160, kernel=15*15,
%     loss_crit=0.2, pde_dt=2e-3, pde_maxTime=0.2, opt_crit=2e-6
% street1_big.jpg + syn3: 2%, lambda=[1e-3 7e-2], itr=160, kernel=15*15,
%     loss_crit=0.2, pde_dt=2e-3, pde_maxTime=0.2, opt_crit=2e-6
% Wall_834.png + syn5: 5%, lambda=[5e-5 5e-5](ADMM_2_cont, quad: true), itr=80,
%     kernel=23*23, loss_crit=0.15, opt_crit=2e-6 => -16, -11.5, -8
% Wall_834.png + syn5: 5%, lambda=[0.5e-5 5e-4](ADMM_2_cont, quad: false), itr=80,
%     kernel=23*23, loss_crit=0.15, opt_crit=2e-6 => -17.47, ...?
% street2_big.png + syn3: 1%, lambda=[10e-5 10e-5](ADMM_2_cont, quad: true), itr=80,
%     kernel=15*15, loss_crit=0.1, opt_crit=4e-6 => -16, ...?
% street2_big.png + syn7: 5%, lambda=[1e-5 20e-5](ADMM_2_cont, quad: true), itr=50,
%     kernel=23*23, loss_crit=0.15, opt_crit=4e-6 => -21.35, ...?
% street2_big.png + syn7: 1%-5%, lambda=[1e-4 5e-2](ADMM_2), itr=60,
%     kernel=23*23, loss_crit=0.1, opt_crit=4e-6 => -19.96, ...?