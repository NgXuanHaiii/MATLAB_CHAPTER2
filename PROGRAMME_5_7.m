len = 30; % montion displacement
theta =40; %motion angle
psf = fspecial('motion',len,theta); %montion psf
f = imread('lena.jpg'); % input the original image
f = rgb2gray(f);
f = im2double(f);
figure; subplot(2,3,1); imshow(f); title('Original Image');
g = imfilter(f,psf, 'circular', 'conv'); %realize the defocus blur
subplot(2,3,2); imshow(g); title('Motion Blur Image');
G = abs(fft2(g));
subplot(2,3,3); imshow(fftshift(log(G)),[],'InitialMagnification', 'fit'); title('Fourier Spectrum');
Cep = fftshift(ifft2(log10(abs(1+G))));
subplot(2,3,4); imshow(Cep,[], 'InitialMagnification', 'fit'); title('cepectrum');
minmum = min(Cep(:));
[R,C] = find(Cep == minmum);
[rows,cols]=size(Cep);
row1s = rows;
col1s = cols;
m = 0.5;
if(length(R)==1 && length(C) == 1)
    R(2)=0;
    C(2)=0;
    row1s = 0;
    col1s = 0;
    m  =0;
end
retrive_len = (1-m)*sqrt((R(1)-rows/2)^2 + (C(1)-cols/2)^2) + m*sqrt((R(2) - row1s/2)^2+(C(2)-col1s/2)^2);
retrive_theta = (1-m)*acot(abs(C(1)-cols/2-1)/abs(R(1)-rows/2-1))*180/pi+m*acot(abs(C(1)-cols/2-1)/abs(R(1)-rows/2-1))*180/pi;
ipsf = fspecial('motion',retrive_len, retrive_theta);
f_restored_LR = deconvlucy(g,ipsf,50);
subplot(2,3,5); imshow(f_restored_LR);title('Lucy_Richardsib Method');
f_restored_WNR = deconvwnr(g,ipsf);
subplot(2,3,6); imshow(f_restored_WNR); title('Wiener Filter Method');
