r = 10; %blur radius r = 10
psf = fspecial('disk',r); % get the Point Spread Function, PSF
f = imread('lena.jpg'); %input original image
f = rgb2gray(f);
f = im2double(f);
figure; subplot(2,3,1); imshow(f); title('Original image');
g = imfilter(f,psf, 'circular', 'conv');% realize the defocus blur
subplot(2,3,2);imshow(g); title('Out-of-focus Blur Image');
G = fftshift(log(abs(fft2(g))));
subplot(2,3,3); imshow(G,[], 'InitialMagnification', 'fit'); title('Fourier Spectrum');
[R,C] = size(G);
section = G(R/2,:);
subplot(2,3,4); plot(section); title('Cross Section of Logsrithm Spectrum');
Fsection = abs(fft(section));
subplot(2,3,5); plot(Fsection); title('Spectrum of Cross Section');