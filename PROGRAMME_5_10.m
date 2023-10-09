%%%%%% PROGRAMME 5.10
%the main program for DCP dehazing
warning('off','all');
image = double(imread('suongmu2.jpg'))/255;
%image = imresize(image,0.1);
result = dehaze(image,0.95,15);
%figure,imshow(image)
%figure,imshow(result)
subplot(1,2,1);
imshow(image);
title('original image');
subplot(1,2,2);
imshow(result);
title('Image Dehazing with DCP');
warning('on','all');
%%%%%% call different functions to dehaze
function [radiance]=dehaze(image,omega,win_size,lambda)
%DEHZE Summary of this function goes here
if~exist('omega','var')
   omega = 0.95;
end
if~exist('win_size','var')
   win_size = 15;
end
if~exist('lambda','var')
   lambda = 0.0001;
end
[m,n,~]=size(image);
dark_channel = get_dark_channel(image,win_size);
atmosphere = get_atmosphere(image,dark_channel);
trans_est = get_transmission_estimate(image,atmosphere,omega,win_size);
radiance = get_radiance(image,trans_est,atmosphere);
end
%%%%%% computer the atmosphere light A
function atmosphere = get_atmosphere(image,dark_channel)
    [m,n,~] = size(image);
    n_pixels = m*n;
    n_search_pixels = floor(n_pixels*0.01);
    dark_vec = reshape(dark_channel,n_pixels,1);
    image_vec = reshape(image,n_pixels,3);
    [~,indices] = sort(dark_vec,'descend');
    accumulator = zeros(1,3);

for k = 1:n_search_pixels
     accumulator = accumulator+image_vec(indices(k),:);
end
atmosphere = accumulator/n_search_pixels;
end
%%%%%% computer the dark channel
function dark_channel = get_dark_channel(image, win_size)

[m, n, ~] = size(image);

pad_size = floor(win_size/2);

padded_image = padarray(image, [pad_size pad_size], Inf);

dark_channel = zeros(m, n); 

for j = 1 : m
    for i = 1 : n
        patch = padded_image(j : j + (win_size-1), i : i + (win_size-1), :);

        dark_channel(j,i) = min(patch(:));
     end
end

end
%%%%%% estimate the transmission
function trans_est = get_transmission_estimate(image,atmosphere,omega,win_size)
     [m,n,~] = size(image);
     rep_atmosphere = repmat(reshape(atmosphere,[1,1,3]),m,n);
     trans_est = 1 - omega*get_dark_channel(image./rep_atmosphere,win_size);
end
%%%%%% recover image
function radiance = get_radiance(image,transmission,atmosphere)
    [m,n,~] = size(image);
    rep_atmosphere = repmat(reshape(atmosphere,[1,1,3]),m,n);
    max_transmission = repmat(max(transmission,0.1),[1,1,3]);
    radiance = ((image-rep_atmosphere)./max_transmission)+rep_atmosphere;
end