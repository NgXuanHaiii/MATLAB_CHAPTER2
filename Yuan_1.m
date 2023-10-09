function [X0,Y0,R]=Yuan(rgb) % Define the function to obtain the center coordinates and radius of the circular area
r=rgb(:,:,1);
g=rgb(:,:,2);
b=rgb(:,:,3);
I=0.59*r+0.11*g+0.3*b; % the pixel brightness calculation formula
I=uint8(I);
[Height,Width]=size(I);
Thre=46; % set the threshold value 
for Row1=1:(Height/2);% look for the upper boundary of circle region through the loop
CurRow_Bright=I(Row1,:);
Max=max(CurRow_Bright); % find the maximum brightness value
Min=min(CurRow_Bright); % find the minimum brightness value
Lim=Max-Min; %the limiting luminance difference of the scan line
if (Lim>Thre),
Ytop=Row1;
break;
end
end
for Row2=Height:-1:(Height/2) %look for the lower boundary of cirele region through the loop
CurRow_Bright=I(Row2,:);
Max=max(CurRow_Bright); % find the maximum brightness value
Min=min(CurRow_Bright); % find the minimum brightness value
Lim=Max-Min; %the limiting luminance difference of the scan line
if (Lim>Thre),
Ybot=Row2;
break;
end
end
for Col1=1:(Width/2) %look for the left boundary of cirele region through the loop
CurCol_Bright=I(:,Col1);
Max=max(CurRow_Bright); % find the maximum brightness value
Min=min(CurRow_Bright); % find the minimum brightness value
Lim=Max-Min; %the limiting luminance difference of the scan line
if (Lim>Thre),
Xleft=Col1;
break;
end
end
for Col2=Width/2:-1:(Height/2) %look for the right boundary of cirele region through the loop
CurCol_Bright=I(:,Col2);
Max=max(CurCol_Bright); % find the maximum brightness value
Min=min(CurCol_Bright); % find the minimum brightness value
Lim=Max-Min; %the limiting luminance difference of the scan line
if (Lim>Thre),
Xrig=Col2;
break;
end
end
X0=(Xleft+Xrig)/2;
Y0=(Ytop+Ybot)/2;
Rx=floor((Xrig-Xleft)/2);
Ry=floor((Ytop-Ybot)/2);
R=max(Rx,Ry);
end