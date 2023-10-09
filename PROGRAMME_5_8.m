rgb = imread('example1cs.jpg');
%rgb = imred('10.jpg');
[height,width,v] = size(rgb);
[X0,Y0,R] = Yuan(rgb); % return the coordinates and radius of the circular area
%% find the corresponding point of the distorted plane center in the correction plane 
x0=floor(X0);
y0=floor(Y0);
r = round(R);
u0 = x0;
v0 = y0;
Image = zeros(height,width,v);
Image = uint8(Image);
%% take any point p (x,y) on the imaging plane image ,an x and y are all integers
for y = 1 : height
Delta = floor(sqrt(r^2-(y-y0)^2));
Delta=real(Delta);
for x = x0-Delta : x0+Delta
det=floor(sqrt(r^2-(y-y0)^2));
dx=x-x0;
if dx==0% there is no distortion on the y-axis
v = y;
u = x;
else if dx<0
u=round(x0-((x0-x)/det)*r);
v=y;
else
u=round(x0+((x-x0)/det)*r);
v=y;
end
end
if v > height || v < 1 || u > width || u < 1 % if the parameters is out of the picture, then leave it
continue
end 
Image(v,u,:)=rgb(y,x,:);
end 
end
%figure, imshow (Image);
subplot(121)
imshow(rgb), title('the original image')
subplot(122)
imshow(Image),title('corrected image');
