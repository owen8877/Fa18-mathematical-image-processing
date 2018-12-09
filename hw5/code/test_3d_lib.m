clear
clc

addpath wavelet-lib
addpath lib

frame=0; % type of wavelet frame used: 0 is Haar; 1 is piecewise linear; 3 is piecewise cubic
Level=1; % level of decomposition, typically 1-4.
[D,R]=GenerateFrameletFilter(frame);
W  = @(x) FraDecMultiLevel3D(x,D,Level); % Frame decomposition
WT = @(x) FraRecMultiLevel3D(x,R,Level); % Frame reconstruction

load data/statuette.mat

Cf=W(f); % wavelet frame transform. Cf is the wavelet frame coefficients.
f_reconstruction=WT(Cf); % inverse wavelet frame transform.

% figure(1);kk=1;
% for kn=1:length(D)-1
%     for km=1:length(D)-1
%         if kn>1 || km>1
%           c  subplot(3,3,kk);imshow(Cf{1}{kn,km},[]);title(['Frame Coefficients of Band (' num2str(km) ', ' num2str(kn) ').'])
%         end
%         kk=kk+1;
%     end
% end
% figure(2);kk=1;
% for kn=1:length(D)-1
%     for km=1:length(D)-1
%         if kn==1 && km==1
%             subplot(3,3,kk);imshow(Cf{2}{kn,km},[]);title('Low Frequency Approximation')
%         end
%         if kn>1 || km>1
%             subplot(3,3,kk);imshow(Cf{2}{kn,km},[]);title(['Frame Coefficients of Band (' num2str(km) ', ' num2str(kn) ').'])
%         end
%         kk=kk+1;
%     end
% end

fprintf('Reconstruction error = %.3e. (Perfect Reconstruction)\n', ...
    sum(sum(sum((f-f_reconstruction).^2))));