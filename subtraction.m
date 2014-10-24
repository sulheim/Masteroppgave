%subtraction
clear all;
close all;
fnameBase = 'C:\Users\Snorre\Documents\masteroppgave\Masteroppgave\corrected_data\2014-05-01-09-40-14_all_singlemotion_corrected_goodaffine_1000.mat';
a = load(fnameBase);
a.corrected_data.frames = single(a.corrected_data.frames);
%%
% get background file
bg_file = load('C:\Users\Snorre\Documents\masteroppgave\Masteroppgave\corrected_data\2014-05-01-09-39-20_all_singlemotion_corrected_goodaffine_1000.mat');
bg_file.corrected_data.frames = single(bg_file.corrected_data.frames);
% bg_frames = bg_file.corrected_data.frames;
% imshowpair(frames1(:,:,1), bg_frames(:,:,1), 'ColorChannels', 'red-cyan')
sub_idxs = 1:1:1000;
%%
frames = single(cat(3, bg_file.corrected_data.frames, a.corrected_data.frames(:,:, sub_idxs)));
clear a.corrected_data.frames;
clear bg_file.corrected_data.frames;
%%
%get background and subtracted images
[linear_sub, background] = do_subtraction(frames, 'type', 'linear', 'background_idxs', 1:100);%1:size(bg_frames, 3)
% imshow(log_compress_2(background,'compress'));

%%
save_lin = ['C:\Users\Snorre\Documents\masteroppgave\Masteroppgave\corrected_data\2014-05-01-09-40-14__linear_subtracted_',...
    num2str(sub_idxs(1))','_to_', num2str(sub_idxs(end))];
sub.subtracted = linear_sub;
sub.background = background;
sub.sub_idxs = sub_idxs;
save(save_lin, 'sub');
%%
BmodeWidth = a.corrected_data.param.BmodeWidth(1);
BmodeDepth = a.corrected_data.param.BmodeDepth;
BmodeDepthOffset = a.corrected_data.param.BmodeDepthOffset;

%%
%Get regionBoundaries
%%
%get bw and count
l =size(linear_sub, 3);
%Preallocate B
element = struct('boundaries',{[]}, 'rp', struct(), 'len', 0);
B(1, l) = element;
%%
%run through alle elements in subtracted
min_intensity = 1*1e5;
min_size = 4;
for k = 1:l
    [b, rp] = bw_and_count(linear_sub(:,:,k), min_intensity, min_size);
    B(k).boundaries = b;
    B(k).rp = rp;
    B(k).len = min(length(b), length(rp));
end


%%
%Make video object
save_path = 'C:\Users\Snorre\Documents\masteroppgave\Masteroppgave\Phaseshiftcounting\';
% [~,name, ~]= fileparts(name);
name  = 'bubles_on_subtracted';
vidObj2 = VideoWriter([save_path, name,'_',num2str(min_intensity),'_',num2str(min_size),'.avi']);
vidObj2.FrameRate = 5;
vidObj2.Quality = 100;
open(vidObj2);
%%
%Plot boundary on top of image
figure('units','normalized','outerposition',[0 0 1 1])
y_aspect = (BmodeDepth-BmodeDepthOffset)/BmodeWidth;
for k = 1:20%l
    k
%     h = figure(1);
%     subplot(1,2,1);
%         imagesc(frames(:,:,size(bg_frames,3)+k))
    imagesc(log_compress_2(linear_sub(:,:,2), 'compress'))
    colormap('gray')
    %     axis image;
    hold on;
    s = zeros(1,B(k).len);
    for m = 1:B(k).len
        b = B(k).boundaries{m};
        s(m)=B(k).rp(m).Area;
        plot(b(:,2), b(:,1),'r','LineWidth',2);
    end
    tmp = sprintf('Number of bubbles is %d', B(k).len);
    title(['Contrast agent in red. ', tmp])
%     subplot(1,2,2);
%     hist(s(:), 20);
%     title('Size distribution of bubbles')
    pbaspect([1 y_aspect 1]);
    frame = getframe;
    writeVideo(vidObj2, frame);
end
close(vidObj2)
%




%%
%%
%Make video object
save_path = 'C:\Users\Snorre\Documents\masteroppgave\Masteroppgave\';
name = 'subtracted_all_frames';
vidObj = VideoWriter([save_path, name,'.avi']);
vidObj.FrameRate = 5;
open(vidObj);

for i = 1:size(linear_sub, 3)
    imagesc([0 BmodeWidth], [BmodeDepthOffset, BmodeDepth],log_compress_2(linear_sub(:,:,i), 'compress'))
    title('Substracted frames 2014-05-01-09-40-14. 2014-05-01-09-39-20 as background')
    colormap('gray');
    axis image;
    currframe = getframe;
    writeVideo(vidObj, currframe)
end
close(vidObj);
%%
% Look at thresholding
% imagesc(linear_sub(:,:, 50))



% %%
% %compare
% figure(1), imshow(d_tmp_100)
% figure(2), imshowpair(d_log, d100, 'montage')
% title(['subtracted in log-space(divided).       ', 'subtracted in real-space, then coonverted into log-space'])
% %%
% %Do the same for filtered
% %undo log compress
% rf_background = log_compress_2(f_bg, 'undo');
% %%
% %subtract log decompressed
% d_tmp_100 = im_sub(rf100, rf_background);
% %subtract compressed
% d_log_f = im_sub(im100, f_bg);
% %%
% %log compress
% d100_f = log_compress_2(d_tmp_100, 'do');
% 
% %%
% %compare
% figure(3);
% imshowpair(d_log_f, d100_f, 'montage')
% title(['subtracted in log-space(divided) Filtered background.       ', 'subtracted in real-space, then converted into log-space. Filtered background'])
% 
% figure(4);
% imshowpair(d_log_f, d_log, 'montage')
% title(['Subtracted in log-space. Filtered background                    ', 'Subtracted in Log-space without filtered backgound'])
% 
% %%
% %threshold
% d = d_log;
% % threshold = graythresh(d);
% threshold = 0.8;
% d(d<5) = 0;
% imagesc(d);
% %%
% %convert to bw
% bw = im2bw(d);
% %%
% %Clear small objects
%  bw = bwareaopen(bw,10);
% 
% %%
% %get objects
% [B,L] = bwboundaries(bw);
% stats = regionprops(bw, 'area');%get area of objects
% 
% %%
% %plot
% figure(1);
% subplot(1,2,1);
% % imagesc([0, 23],[0,18],im100)
% imagesc(im100)
% colormap('gray')
% axis image;
% hold on;
% s = zeros(1, length(B));
% for k = 1:length(B)
%     b = B{k};
%     s(k)=stats(k).Area;
%     plot(b(:,2), b(:,1),'r','LineWidth',2);
% end
% 
% a = sprintf('Number of bubbles is %d', length(B));
% title(['Contrast agent in red. ', a])
% 
% subplot(1,2,2);
% hist(s(:), 20);
% title('Size distribution of bubbles')
