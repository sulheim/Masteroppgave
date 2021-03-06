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
RF2 = imrotate(RF, -0.2, 'bilinear', 'crop');
%make transformed image
BG2 = imtranslate(BG2, [2, 8]);
RF2 = imtranslate(RF2, [2,8]);
%Stretch image



fixed = BG;
moving = BG2;

%%%%%MAYBE INTERPOLATE WITH SPLINE%%%%%%%%%%%%
moving = imresize(moving, [512, 512]);
fixed = imresize(fixed, [512, 512]);
figure(1);
subplot(2,2,1); imshowpair(moving, fixed, 'ColorChannels','red-cyan');
title('Colorchannel before fix')
%%
[moving_reg, T] = align_image(fixed, moving, 50, 0.001);
% figure; imshowpair(moving_reg, fixed);
%%
%resiz

% figure(3); imshowpair(moving_reg, fixed, 'diff');
% title('Difference');
% 
% figure(4); imshowpair(moving_reg, fixed, 'montage');
% title('Montage after fix');

subplot(2,2,2); imshowpair(moving_reg, fixed, 'ColorChannels','red-cyan');
title('Color channel after fix');

RF = imresize(RF, [512, 512]);
RF2 = imresize(RF2, [512, 512]);

subplot(2,2,3); imshowpair(log_compress(RF2), log_compress(RF), 'ColorChannels','red-cyan');
title('Color channel before fix. RF image.');


[RF_fixed, T2] = align_image(RF, RF2, 50, 0.1);

subplot(2,2,4); imshowpair(log_compress(RF_fixed), log_compress(RF), 'ColorChannels','red-cyan');
title('Color channel after fix. RF image.');
spaceplots(gcf,[0 0 0 0], [.01 .01]);