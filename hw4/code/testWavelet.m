clear
clc

addpath wavelet-lib

frame=1; % type of wavelet frame used: 0 is Haar; 1 is piecewise linear; 3 is piecewise cubic
Level=2; % level of decomposition, typically 1-4.
[D,R]=GenerateFrameletFilter(frame);
W  = @(x) FraDecMultiLevel2D(x,D,Level); % Frame decomposition
WT = @(x) FraRecMultiLevel2D(x,R,Level); % Frame reconstruction
frameN = numel(D{1});

f=im2double(imread('image/source/aircraft.jpg'));

Cf=W(f); % wavelet frame transform. Cf is the wavelet frame coefficients.
f_reconstruction=WT(Cf); % inverse wavelet frame transform.

figure(1);kk=1;
for kn=1:length(D)-1
    for km=1:length(D)-1
        if kn>1 || km>1
            subplot(frameN,frameN,kk);imshow(Cf{1}{kn,km},[]);title(['Frame Coefficients of Band (' num2str(km) ', ' num2str(kn) ').'])
        end
        kk=kk+1;
    end
end
figure(2);kk=1;
for kn=1:length(D)-1
    for km=1:length(D)-1
        if kn==1 && km==1
            subplot(frameN,frameN,kk);imshow(Cf{2}{kn,km},[]);title('Low Frequency Approximation')
        end
        if kn>1 || km>1
            subplot(frameN,frameN,kk);imshow(Cf{2}{kn,km},[]);title(['Frame Coefficients of Band (' num2str(km) ', ' num2str(kn) ').'])
        end
        kk=kk+1;
    end
end

display(['Reconstruction error = ' num2str(norm(f-f_reconstruction,'fro')) '. (Perfect Reconstruction)'])