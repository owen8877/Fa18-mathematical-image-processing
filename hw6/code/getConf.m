function conf = getConf(index)
switch index
case 1 % psnr: 28->33, proof of concept
    conf.p1Sname = 'Wall_834';
    conf.p2name = 'png';
    conf.kernel_name = 'syn2';
    conf.edge_max_percent = 2.5/100;
    conf.edge_offset = 0/100;
    conf.radon_lambdas = [1e-3 8e-2];
    conf.radon_ADMM_MaxItr = 160;
    conf.radon_ADMM_method = 'ADMM_2';
    conf.edge_box_size = 7;
    conf.radon_kernel_size = 7;
    conf.edge_lossness = 0.25;
    conf.deblur_lambda = 0.5;
    conf.deblur_criterion = 4e-6;
    conf.details = [163 99 15 15; 64 201 15 15];
% case 2 % obselete
%     conf.p1Sname = 'Wall_834_big';
%     conf.p2name = 'png';
%     conf.kernel_name = 'syn2';
%     conf.edge_max_percent = 2.5/100;
%     conf.edge_offset = 0/100;
%     conf.radon_lambdas = [1e-3 8e-2];
%     conf.radon_ADMM_MaxItr = 160;
%     conf.radon_ADMM_method = 'ADMM_2';
%     conf.edge_box_size = 11;
%     conf.radon_kernel_size = 7;
%     conf.edge_lossness = 0.25;
%     conf.deblur_lambda = 0.5;
%     conf.deblur_criterion = 2e-6;
% case 3 % psnr: 30->35; also test for larger, more directional kernel! and point out the problem (two edges)
%     conf.p1Sname = 'Wall_834_big';
%     conf.p2name = 'png';
%     conf.kernel_name = 'syn5';
%     conf.edge_max_percent = 5/100;
%     conf.edge_offset = 0/100;
%     conf.radon_lambdas = [4e-5 5e-5];
%     conf.radon_ADMM_MaxItr = 60;
%     conf.radon_ADMM_method = 'ADMM_2_cont';
%     conf.radon_ADMM_quad_sign = true;
%     conf.edge_box_size = 11;
%     conf.radon_kernel_size = 7;
%     conf.edge_lossness = 0.15;
%     conf.deblur_lambda = 0.5;
%     conf.deblur_criterion = 2e-6;
case 4 % 24 -> 25
    conf.p1Sname = 'street1';
    conf.p2name = 'jpg';
    conf.kernel_name = 'syn6';
    conf.sf_pde_dt = 2e-3;
    conf.sf_pde_maxTime = 0.2;
    conf.edge_max_percent = 5/100;
    conf.edge_offset = 0/100;
    conf.edge_lossness = 0.25;
    conf.radon_lambdas = [10e-4 3e-2];
    conf.radon_ADMM_MaxItr = 60;
    conf.radon_ADMM_method = 'ADMM_2';
    conf.edge_box_size = 9;
    conf.radon_kernel_size = 7;
    conf.deblur_lambda = 0.5;
    conf.deblur_criterion = 8e-6;
    conf.details = [167 259 15 15; 77 126 15 15; 23 66 15 15];
case 5 % psnr: 25->28; proof of concept
    conf.p1Sname = 'street2_big';
    conf.p2name = 'jpg';
    conf.kernel_name = 'syn7';
    conf.edge_max_percent = 5/100;
    conf.edge_offset = 1/100;
    conf.edge_lossness = 0.1;
    conf.radon_lambdas = [1e-4 5e-2];
    conf.radon_ADMM_MaxItr = 60;
    conf.radon_ADMM_method = 'ADMM_2';
    conf.radon_ADMM_quad_sign = true;
    conf.edge_box_size = 11;
    conf.radon_kernel_size = 7;
    conf.deblur_lambda = 0.5;
    conf.deblur_criterion = 4e-6;
    conf.details = [475 762 30 30; 153 760 30 30; 294 256 30 30];
case 6 % acceptable, test for larger kernels
    conf.p1Sname = 'flower_small';
    conf.p2name = 'jpg';
    conf.kernel_name = 'syn8';
    conf.sf_pde_dt = 1e-2;
    conf.sf_pde_maxTime = 0;
    conf.sf_pde_processor = 'pm';
    conf.edge_max_percent = 10/100;
    conf.edge_offset = 0/100;
    conf.edge_lossness = 0.25;
    conf.radon_lambdas = [7e-4 3e-2];
    conf.radon_ADMM_MaxItr = 50;
    conf.radon_ADMM_method = 'ADMM_2';
    conf.edge_box_size = 21;
    conf.radon_kernel_size = 9;
    conf.deblur_lambda = 0.5;
    conf.deblur_criterion = 1e-5;
    conf.details = [191 253 20 20; 121 184 20 20; 145 423 20 20];
case 7 % circles+larger kernel; no noise
    conf.p1Sname = 'Wall_834';
    conf.p2name = 'png';
    conf.kernel_name = 'syn9';
    conf.edge_max_percent = 10/100;
    conf.edge_offset = 0/100;
    conf.edge_lossness = 0.15;
    conf.radon_lambdas = [5e-4 5e-2];
    conf.radon_ADMM_MaxItr = 50;
    conf.radon_ADMM_method = 'ADMM_2';
    conf.edge_box_size = 15;
    conf.radon_kernel_size = 9;
    conf.deblur_lambda = 0.5;
    conf.deblur_criterion = 2e-6;
    conf.details = [163 99 15 15; 64 201 15 15; 240 115 15 15];
case 8 % circles+larger kernel; noise 2.5%
    conf.p1Sname = 'Wall_834';
    conf.p2name = 'png';
    conf.kernel_name = 'syn9';
    conf.blur_noise_level = 0.5e-2;
    conf.rng = 42;
    conf.edge_max_percent = 10/100;
    conf.edge_offset = 0/100;
    conf.edge_lossness = 0.25;
    conf.radon_lambdas = [5e-4 5e-2];
    conf.radon_ADMM_MaxItr = 50;
    conf.radon_ADMM_method = 'ADMM_2';
    conf.edge_box_size = 15;
    conf.radon_kernel_size = 9;
    conf.deblur_lambda = 0.5;
    conf.deblur_criterion = 3.5e-6;
    conf.details = [163 99 15 15; 64 201 15 15; 240 115 15 15];
case 9 % circles+larger kernel; noise 5%
    conf.p1Sname = 'Wall_834';
    conf.p2name = 'png';
    conf.kernel_name = 'syn9';
    conf.blur_noise_level = 1e-2;
    conf.rng = 42;
    conf.edge_max_percent = 10/100;
    conf.edge_offset = 0/100;
    conf.edge_lossness = 0.25;
    conf.radon_lambdas = [5e-4 5e-2];
    conf.radon_ADMM_MaxItr = 50;
    conf.radon_ADMM_method = 'ADMM_2';
    conf.edge_box_size = 15;
    conf.radon_kernel_size = 9;
    conf.deblur_lambda = 0.5;
    conf.deblur_criterion = 5e-6;
    conf.details = [163 99 15 15; 64 201 15 15; 240 115 15 15];
    
    
case 22 % proof of concept; ringing effect
    conf.p1Sname = 'escape';
    conf.p2name = 'png';
    conf.no_truth = true;
    conf.display_truth = false;
    conf.edge_max_percent = 4/100;
    conf.edge_lossness = 0.25;
    conf.edge_offset = 0/100;
    conf.radon_lambdas = [1e-3 5e-2];
    conf.radon_ADMM_MaxItr = 60;
    conf.radon_ADMM_method = 'ADMM_2';
    conf.edge_box_size = 16;
    conf.radon_kernel_size = 8;
    conf.deblur_lambda = 0.5;
    conf.deblur_criterion = [3e-4 7e-6 1e-5];
    conf.details = [72 212 15 15; 157 303 15 15; 272 380 15 15];
    
    
case 31 % just for demonstration; never for step 2 3 4
    conf.p1Sname = 'street2';
    conf.p2name = 'jpg';
    conf.kernel_name = 'syn5';
    conf.edge_max_percent = 4/100;
    conf.edge_lossness = 0.25;
    conf.edge_offset = 0/100;
    conf.radon_lambdas = [1e-3 5e-2];
    conf.radon_ADMM_MaxItr = 60;
    conf.radon_ADMM_method = 'ADMM_2';
    conf.edge_box_size = 16;
    conf.radon_kernel_size = 8;
    conf.deblur_lambda = 0.5;
    conf.deblur_criterion = [3e-4 7e-6 1e-5];
    conf.display_recover = false;
end
end

