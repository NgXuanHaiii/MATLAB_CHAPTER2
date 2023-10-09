I = imread('Test2.jpg');
J = imnoise(I, 'salt & pepper');
H = rgb2gray(J);
B = ordfilt2(H,5,true(3)); % order statistic filters
subplot(1,2,1), imshow(H); title('the graph begore filtering');
subplot(1,2,2), imshow(B); title('the graph after filtering');