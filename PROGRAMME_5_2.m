I = imread('Test2.jpg');
J = rgb2gray(I);
I1 = imnoise(J, 'salt & pepper',0.02); %add noise
subplot(1,2,1), imshow(I1); title('a graph containing salt and pepper noise');
J1=filter2(fspecial('average',3), I1)/255; %average filtering
subplot(1,2,2), imshow(J1); title('the graph after the average filtering');