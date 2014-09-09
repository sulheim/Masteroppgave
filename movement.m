%%movement
clear all;
close all;
set(0,'defaultTextUnits','Normalized');

% specify filename here ------------------
fnameBase = 'D:\Phase shift project\Ultrasound image data\2014-05-02-09-47-04.rf';
% fnameBase = '\\tsclient\D\Phase shift project\Ultrasound image data\2014-05-02-09-47-04.rf';
% fnameBase= 'D:\020514\2014-05-02-09-47-04.rf';
% specify frame number here ------------------
RF_array = cell(1,260);
param_array = cell(1, 260);
BG = cell(1, 260);
for i = 1:2
    frameNumber = i;
    [RF_array{i}, param_array{i}] = ReadRF(fnameBase, '.bmode', frameNumber);
    tmp = 20.*log10(abs(hilbert(RF_array{i})));
    BG{i} = mat2gray(tmp);
end
save('cells', 'RF_array', 'param_array', 'BG')
%%


%%
% ------------------------------------------
% [RF,param] = ReadRF(fnameBase, '.bmode', frameNumber);
% ------------------------------------------
% size(RF)
% size(param)
%%
% figure(1);
% BG = 20.*log10(abs(hilbert(RF))/1e3+1);
% imagesc([0 param.BmodeWidth(1)],[param.BmodeDepthOffset(1) param.BmodeDepth(1)],...
%     BG, [2 25]);
% colormap('gray');
% imfinfo(BG)
