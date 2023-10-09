clc;
clear;
addpath '.\fast-guided-filter-code-v1'
run '.\matconvnet\matlab\vl_setupnn.m'
load('network.mat');%load trained model
use_gpu = 0;% GPU:1,CPU:0
%%% parameters of guidedfilter
r=16;
eps=1;
s = 4;
%%%
input=im2double(imread('.\image\real_world\3.jpg'));
%imshow(input);
base_layer=zeros(size(input));% base layer
base_layer(:,:,1)=fastguidedfilter(input(:,:,1),input(:,:,1),r,eps,s);
base_layer(:,:,2)=fastguidedfilter(input(:,:,2),input(:,:,2),r,eps,s);
base_layer(:,:,3)=fastguidedfilter(input(:,:,3),input(:,:,3),r,eps,s);
detail_layer=input - base_layer;%detail layes
output = processing(input,detail_layer,model,use_gpu);%perfrom de-raining
%%%% If yuornvidiaGBU encountrs an "out of memory",try below code and make a small
%"max_patch_size"
%max_patch_size=120;
%output=processing(input,detail_layer,model,use_gpu,max_patch_size);
%%%%
figure,imshow([input,output]);
title('Left:rainy image    Right:de-rained result')
%%%%%%%%%%%%%%%%
function q=fastguidedfilter(I,p,r,eps,s)
% GUIDEDFILTER 0(1)time implementation of guided filter.
%
% -guidence image:I(should be a gray -scale/single channel image)
% -filtering imput image:p(should be a gray -scale/single channel image)
% -local windpw radius:r
% -regularization parameter:eps
% -subsampling ratio:s(try s=r/4 to s=r)

I_sub=imresize(I,1/s,'nearest');%NN is often enough
p_sub=imresize(p,1/s,'nearest');
r_sub=r/s;%make sure this is an integer 

[hei, wid]=size(I_sub);
N = boxfilter(ones(hei,wid),r_sub);% the size ofeach local patch;N=(2r+1)^2 expect for boundary pixels
mean_I = boxfilter(I_sub,r_sub)./ N;
mean_p = boxfilter (p_sub,r_sub)./ N;
mean_Ip = boxfilter(I_sub.*p_sub,r_sub)./ N;
cov_Ip = mean_Ip - mean_I.*mean_p;% this is the covariance of (I,p) in each localpatch.
mean_II = boxfilter(I_sub.*I_sub,r_sub)./ N;
var_I = mean_II - mean_I.*mean_I;

a = cov_Ip./(var_I+eps);
b = mean_p - a.*mean_I;
var_I=mean_II-mean_I.*mean_I;
a=cov_Ip./(var_I+eps);
b=mean_p-a.*mean_I;
mean_a=boxfilter(a,r_sub)./N;
mean_b=boxfilter(b,r_sub)./N;
mean_a=imresize(mean_a,[size(I,1),size(I,2)],'bilinear');%bilinear is recommended
mean_b=imresize(mean_b,[size(I,1),size(I,2)],'bilinear');
q=mean_a.*mean_b;
end
%%%%function boxfilter
function imDst = boxfilter(imSrc, r)

%   BOXFILTER   O(1) time box filtering using cumulative sum
%
%   - Definition imDst(x, y)=sum(sum(imSrc(x-r:x+r,y-r:y+r)));
%   - Running time independent of r; 
%   - Equivalent to the function: colfilt(imSrc, [2*r+1, 2*r+1], 'sliding', @sum);
%   - But much faster.

[hei, wid] = size(imSrc);
imDst = zeros(size(imSrc));

%cumulative sum over Y axis
imCum = cumsum(imSrc, 1);
%difference over Y axis
imDst(1:r+1, :) = imCum(1+r:2*r+1, :);
imDst(r+2:hei-r, :) = imCum(2*r+2:hei, :) - imCum(1:hei-2*r-1, :);
imDst(hei-r+1:hei, :) = repmat(imCum(hei, :), [r, 1]) - imCum(hei-2*r:hei-r-1, :);

%cumulative sum over X axis
imCum = cumsum(imDst, 2);
%difference over Y axis
imDst(:, 1:r+1) = imCum(:, 1+r:2*r+1);
imDst(:, r+2:wid-r) = imCum(:, 2*r+2:wid) - imCum(:, 1:wid-2*r-1);
imDst(:, wid-r+1:wid) = repmat(imCum(:, wid), [1, r]) - imCum(:, wid-2*r:wid-r-1);
end
