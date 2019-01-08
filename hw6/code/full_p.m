clear; %clc
addpath lib-deblur lib-util

index = 6;
proc = [5];

%% Prepare
conf = getConf(index);
% conf.display_truth = true;
% conf.display_recover = true;

conf.p1name = sprintf('%s-%d', conf.p1Sname, index);
conf.edge_data = conf.p1name;
if ~default(conf, 'no_truth', false)
    conf.deblur_kernel_name = sprintf('%s-%s-%d', conf.p1name, conf.kernel_name, index);
else
    conf.deblur_kernel_name = sprintf('%s-exp-%d', conf.p1name, index);
end

%% Fire!
if any(proc == 1)
    generate_blur(conf);
end
if any(proc == 2)
    edge_detect(conf);
end
if any(proc == 3)
    iradon_kernel(conf);
end
if any(proc == 4)
    deblur(conf);
end
if any(proc == 5)
    compare_display(conf);
end