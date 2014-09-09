%%Test.m
close all;
clear all;
set(0,'defaultTextUnits','Normalized');

% specify filename here ------------------
fnameBase = 'D:\Phase shift project\Ultrasound image data\2014-05-02-09-47-04.rf';
%fnameBase= 'D:\020514\2014-05-02-09-47-04.rf';
% specify frame number here ------------------
frameNumber= 150;
% ------------------------------------------
[RF,param] = ReadRF(fnameBase, '.bmode', frameNumber);
% ------------------------------------------
%%

% figure(1);
BG = 20.*log10(abs(hilbert(RF))/1e3+1);
% imagesc([0 param.BmodeWidth(1)],[param.BmodeDepthOffset(1) param.BmodeDepth(1)],...
%     BG, [2 25]);
% colormap('gray');
%%
%make rotated image
BG2 = imrotate(BG, -0.2, 'bilinear', 'crop');

%make transformed image
BG2 = imtranslate(BG2, [2, 8]);

%Stretch image


%%
%Try out intensity based image registration
%Creat metric and optimizer. monomodal = images captured with same device
[optimizer, metric] = imregconfig('monomodal');
optimizer.MaximumIterations = 500;
optimizer.MaximumStepLength = 0.001;
%Setting moving and fixed image
fixed = BG;
moving = BG2;

moving = imresize(moving, [256, 376]);
fixed = imresize(fixed, [256, 376]);
figure(2); imshowpair(moving, fixed, 'ColorChannels','red-cyan');
title('Colorchannel before fix')

moving_reg = imregister(moving, fixed, 'rigid', optimizer, metric);
% figure; imshowpair(moving_reg, fixed);
%%
%resize
% moving_reg = imresize(moving_reg, [256, 376]);
% fixed = imresize(fixed, [256, 376]);

% figure(3); imshowpair(moving_reg, fixed, 'diff');
% title('Difference');
% 
% figure(4); imshowpair(moving_reg, fixed, 'montage');
% title('Montage after fix');

figure(5); imshowpair(moving_reg, fixed, 'ColorChannels','red-cyan');
title('Color channel after fix');




