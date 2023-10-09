%I = imread('rice.jpg');
I = imread('Test2.jpg');
I = rgb2gray(I);
K1 = imnoise(I,'gaussian',0,0.02); %add Gaussian noise
subplot(2,2,1); imshow(K1);
title('white Gaussian noise');
M1 = wiener2(K1,[5 5]); %wiener2 adaptive filter
subplot(2,2,2); imshow(M1);
title('filtered Gauss white noise');
K2 = imnoise(I, 'salt & pepper', 0.2);
subplot(2,2,3); imshow(K2);
title('salt-and-pepper noise');
M2 = wiener2(K2,[9 9]); %wiener2 adaptive filter
subplot(2,2,4); imshow(M2);
title('filtered sale-and-pepper noise');
