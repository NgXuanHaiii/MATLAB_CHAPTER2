%J = wiener2(I,[m n], noise);
%J = wiener2(I,[m n]);
%[J, noise] = wiener2(I, [m n]);
I = rgb2gray(imread('Test2.jpg'));
J = imnoise(I,'gaussian',0,0.005);
K = wiener2(J,[5 5]);
imshow(J), figure, imshow(K)
