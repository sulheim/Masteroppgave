%motionfromavi
clear all;
close all;
%Read in a avi file for motion processing
filename = '2014-05-02-09-51-16.avi';
movie = VideoReader(filename);
info = get(movie);

%%
%Read in two frames and compare
img1 = read(movie, 1);
img2 = read(movie, 600);

% img2 = imrotate(img1, 5, 'bilinear', 'crop');

figure; imshowpair(img1, img2, 'montage');
title(['Frame 1', repmat(' ',[1 70]), 'Frame 2']);

figure; imshowpair(img1,img2,'ColorChannels','red-cyan');
title('Color composite. img1 = red, img2 = cyan');

img3 = imsubtract(img1,img2);
h_im = imshow(img3);

%%
%Create ROI
e = imfreehand(gca);
BW = createMask(e, h_im);

new_diff = immultiply(BW, rgb2gray(img3));
imshow(new_diff);
imhist(new_diff);
%%
bw = rgb2bw(img3);
figure; imshow(bw);


%%
%COUNT
 B = bwboundaries(bw);
% number of points = length(B)
% 
% ptThresh = 0.1;
% points1 = detectFASTFeatures(img1, 'MinContrast', ptThresh);
% points2 = detectFASTFeatures(img2, 'MinContrast', ptThresh);
% 
% figure; imshow(img1); hold on;
% plot(points1)
% title('Corners in image1')
% 
% figure; imshow(img1); hold on;
% plot(points2)
% title('Corners in image2')
% 
% 
% 
% 
