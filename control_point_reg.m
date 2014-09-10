%test controlpoint registration
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
BG = 20.*log10(abs(hilbert(RF))/1e3+1);

%%
%make rotated image
BG2 = imrotate(BG, -0.2, 'bilinear', 'crop');

%make transformed image
BG2 = imtranslate(BG2, [2, 8]);
%%

BG = imresize(BG, [256, 376]);
BG2 = imresize(BG2, [256, 376]);
figure(1); imshow(BG)

imhist(BG)

cpselect(BG, BG2);