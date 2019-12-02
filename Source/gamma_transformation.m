%Adaptive Gamma Transformation: Prior Works
%source: https://arxiv.org/ftp/arxiv/papers/1709/1709.04427.pdf

clc;
clear all;
close all;

% D = '../Dataset/Part A/';
D = '../Dataset/Part B/';
S = fullfile(pwd, D, 'IMG_2.png');
% S = fullfile(pwd, D, 'IMG_2.png');
% S = fullfile(pwd, D, 'IMG_3.png');
% S = fullfile(pwd, D, 'IMG_4.png');
% S = fullfile(pwd, D, 'IMG_5.png');
% S = fullfile(pwd, D, 'IMG_6.png');
% S = fullfile(pwd, D, 'IMG_7.png');
% S = fullfile(pwd, D, 'IMG_8.png');
% S = fullfile(pwd, D, 'IMG_9.png');

im = imread(S);             % input image
% xr = x(:,:,1);
% xg = x(:,:,2);
% xb = x(:,:,3);

hsv_x = rgb2hsv(im);
gamma = 1.2;     %%% Part A
% % gamma = 1.2;   %%% Part B
% yr = adapt_gamma_transform(xr, gamma); 
% yg = adapt_gamma_transform(xg, gamma);
% yb = adapt_gamma_transform(xb, gamma);

% y = cat(3,uint8(yr),uint8(yg),uint8(yb));
i = uint8(hsv_x(:,:,3)*255);
hsv_y = adapt_gamma_transform(i, gamma);
i_new = double(hsv_y)/255.0;
hsv_x(:,:,3) = i_new;
y =  hsv2rgb(hsv_x);
figure; imshow(im), title('Original Image');
figure; imshow(y), title('Gamma Transformed Image')


brisque_orig_img = round(brisque(im), 4);
brisque_gamma = round(brisque(y), 4);

niqe_orig_img = round(niqe(im), 4);
niqe_gamma = round(niqe(y), 4);

% piqe_orig_img = round(piqe(im), 4);
% piqe_gamma = round(piqe(y), 4);

% figure; imhist(im)
% figure; imhist(y)

function y = adapt_gamma_transform(x, gamma)
    l_max = 255;
    [M,N]=size(x); % get size of image
    total_pixels = M*N;
    
    for i=0:255
       PDF(i+1)=sum(sum(x==i))/total_pixels; %hist of input image
    end

    y=x; 
    for i=0:255
       I = find(x==i); %index of pixels in input image with value �i�
       CDF = sum(PDF(1:i));
       % gamma = 1 - CDF;
       y(I) = round(l_max*((i/l_max)^gamma)); 
    end
end