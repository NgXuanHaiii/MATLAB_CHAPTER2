%PROGRAMME 5.11:Image Dehazing with DCP+Soft Matting
     %%%%%% the main program for DCP dehazing
            warning('off','all');
            image=double(imread('images10.jpg'))/255;
            %image=imresize(image,0.1);
            result=dehaze(image,0.95,15);
            %figure,imshow(image)
            %figure,imshow(result)
            subplot(1,2,1);
            imshow(image);
            title('original image');
            subplot(1,2,2);
            imshow(result);
            title('Image Dehazing with DCP + Soft Matting');
            warning('on','all');
     %%%%%% call different funetions to dehaze
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
L=get_laplacian(image);
A=L+lambda*speye(size(L));
b= lambda*trans_est(:);
x=A\b;
transmission = reshape(x,m,n);
radiance = get_radiance(image, transmission,atmosphere);
end
%********************************
 function [ L ] = get_laplacian( image )
%GET_LAPLACIAN
[m, n, c] = size(image);
img_size = m*n;
win_rad = 1;
epsilon = 0.0000001;
max_num_neigh = (win_rad*2+1)^2;
ind_mat = reshape( 1:img_size, m, n);
indices = 1 : (m*n);
num_ind = length(indices);
max_num_vertex = max_num_neigh * num_ind;
row_inds = zeros( max_num_vertex, 1 );
col_inds = zeros( max_num_vertex, 1 );
vals = zeros( max_num_vertex, 1 );
len = 0;
for k = 1 : length(indices);
ind = indices(k);
[i, j] = ind2sub( [m n], ind );
m_min = max( 1, i - win_rad );
m_max = min( m, i + win_rad ); 
n_min = max( 1, j - win_rad );
n_max = min( n, j + win_rad );
win_inds = ind_mat( m_min : m_max, n_min : n_max );
win_inds = win_inds(:);
num_neigh = size( win_inds, 1 );
win_image = image( m_min : m_max, n_min : n_max, : );
win_image = reshape( win_image, num_neigh, c );
win_mean = mean( win_image, 1 );
win_var = inv( (win_image' * win_image / num_neigh) - (win_mean' * win_mean) + (epsilon / num_neigh * eye(c) ) );
win_image = win_image - repmat( win_mean, num_neigh, 1 );
win_vals = ( 1 + win_image * win_var * win_image' ) / num_neigh;
sub_len = num_neigh*num_neigh;
win_inds = repmat(win_inds, 1, num_neigh);
row_inds(1+len: len+sub_len) = win_inds(:);
win_inds = win_inds';
col_inds(1+len: len+sub_len) = win_inds(:);
vals(1+len: len+sub_len) = win_vals(:);
len = len + sub_len;
end
A = sparse(row_inds(1:len),col_inds(1:len),vals(1:len),img_size,img_size);
D = spdiags(sum(A,2),0,n*m,n*m);
L = D - A;
 end
%*************************************
function trans_est = get_transmission_estimate(image,atmosphere,omega,win_size)
     [m,n,~] = size(image);
     rep_atmosphere = repmat(reshape(atmosphere,[1,1,3]),m,n);
     trans_est = 1 - omega*get_dark_channel(image./rep_atmosphere,win_size);
end
function radiance = get_radiance(image,transmission,atmosphere)
    [m,n,~] = size(image);
    rep_atmosphere = repmat(reshape(atmosphere,[1,1,3]),m,n);
    max_transmission = repmat(max(transmission,0.1),[1,1,3]);
    radiance = ((image-rep_atmosphere)./max_transmission)+rep_atmosphere;
end
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
