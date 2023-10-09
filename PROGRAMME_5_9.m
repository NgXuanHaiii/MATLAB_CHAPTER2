I=imread('Test3.png'); % input the original image
I = rgb2gray(I);
A=im2bw(I);
se=strel('ball',12,0);% Defining the structural elements
BW=imdilate(A,se);% image text dilation
BW2=bwmorph(BW,'thin',Inf);% image text thinning
[H,T,R]=hough(BW2);%Hough transform
P=houghpeaks(H,5);%extract the peak point
lines=houghlines(BW2,T,R,P);% extract the straight line 
for k=1:length(lines)
    z=[lines(k).point1;lines(k).point2];% extract the coordinate
end
m=(z(2,2)- z(1,2))/(z(2,1)-z(1,1)); % calculate the slope of the line
M=atan(m); %calculate the angle
M=M*180/3.14;
C=imrotate(A,M);% Image correction
subplot(1,2,1);
imshow(A);
title('original image');
subplot(1,2,2);
imshow(C);
title('the corrected image');