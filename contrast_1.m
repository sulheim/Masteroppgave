set(0,'defaultTextUnits','Normalized');

% specify filename here ------------------
fnameBase = 'D:\Phase shift project\Ultrasound image data\2014-05-02-09-24-14.rf';
%fnameBase= 'D:\020514\2014-05-02-09-24-14.rf';
% specify frame number here ------------------
frameNumber= 2;
% ------------------------------------------
[RF,param] = ReadRF(fnameBase, '.bmode', frameNumber);
% ------------------------------------------

figure(1);
imagesc([0 param.BmodeWidth(1)],[param.BmodeDepthOffset(1) param.BmodeDepth(1)],...
    20.*log10(abs(hilbert(RF))/1e3+1),[2 25]);
colormap('gray');
%%
figure(3);
imagesc([0 param.BmodeWidth(1)],[param.BmodeDepthOffset(1) param.BmodeDepth(1)],...
    20.*log10(abs(hilbert(RF))/1e3+1),[2 25]);
colormap('gray');

%% ------------------------------------------
[RF1,param] = ReadRF(fnameBase, '.contrast', frameNumber);
% ------------------------------------------
figure(2);
imagesc([0 param.BmodeWidth(1)],[param.BmodeDepthOffset(1) param.BmodeDepth(1)],...
    20.*log10(abs(hilbert(detrend(RF1(1:10112,:))))./.5e3+1),[0 14]);
colormap('gray');

figure(3);
axis([1.8 param.BmodeWidth(1)+1.8 param.BmodeDepthOffset(1) param.BmodeDepth(1)]);