%%Test.m
close all;
clear all;
set(0,'defaultTextUnits','Normalized');

% specify filename here ------------------
fnameBase = 'D:\Phase shift project\Ultrasound image data\2014-05-02-09-47-04.rf';
%fnameBase= 'D:\020514\2014-05-02-09-47-04.rf';
% specify frame numbers here ------------------
frameNumber = 1;
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



fixed = BG;
moving = BG2;

%%%%%MAYBE INTERPOLATE WITH SPLINE%%%%%%%%%%%%
moving = imresize(moving, [512, 512]);
fixed = imresize(fixed, [512, 512]);
figure(2); imshowpair(moving, fixed, 'ColorChannels','red-cyan');
title('Colorchannel before fix')
%%
[moving_reg, T] = align_image(fixed, moving);
% figure; imshowpair(moving_reg, fixed);
%%
%resiz

% figure(3); imshowpair(moving_reg, fixed, 'diff');
% title('Difference');
% 
% figure(4); imshowpair(moving_reg, fixed, 'montage');
% title('Montage after fix');

figure(5); imshowpair(moving_reg, fixed, 'ColorChannels','red-cyan');
title('Color channel after fix');

[ssimval, ssimmap] = ssim(moving_reg, fixed);
fprintf('The SSIM value is %0.4f.\n',ssimval);


%%
%Take in image 94 and look at difference
frameNumber = 99;
[RF_94, param] = ReadRF(fnameBase, '.bmode', frameNumber);
BG_94 = 20.*log10(abs(hilbert(RF_94))/1e3+1);

diff = imabsdiff(BG, BG_94);
figure; imagesc(diff);
colormap('gray');
BG_94 = imresize(BG_94, [256, 376]);
BG = imresize(BG, [256, 376]);
figure(94); imshowpair(BG, BG_94, 'ColorChannels', 'red-cyan');
title('Comparison of frame 1 and frame 94')

figure(95); imshowpair(BG, BG_94, 'diff');
title('Difference');

