%test_fair_mlpir
clear all;
close all;
%%
viewOptn = {'viewImage','viewImage2D','colormap','gray(256)'};
viewImage('reset',viewOptn{:});
%%
%Load in testdata
file = load('testdata100-10-21-25.mat');
ref_im = double(im2uint8(mat2gray(file.matfile(:,:,1))));
im = double(im2uint8(mat2gray(file.matfile(:,:,80))));

%%
% Get MLdata
omega = [0,1,0,1];
m = size(ref_im);
[MLdata,minLevel,maxLevel,fig] = getMultilevel({im, ref_im},omega,m, 'minLevel', 7);
%%
%Initialize distance measure
distance('set', 'distance', 'SSD');
%Initialize transformation and a starting guess
trafo('reset', 'trafo', 'affine2D');
%Initialize interpolation scheme and coefficients
inter('set', 'inter', 'splineInter');%Choose spline interpolation
%%
%
[wopt, his] = MLPIR(MLdata);

