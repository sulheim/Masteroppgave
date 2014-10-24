%time_correlation
%subtraction
clear all;
close all;
fnameBase = 'C:\Users\Snorre\Documents\masteroppgave\Masteroppgave\corrected_data\2014-05-01-09-40-14_all_singlemotion_corrected_goodaffine_1000.mat';
a = load(fnameBase);
frames1 = a.corrected_data.frames;
%%
% get background file
bg_file = load('C:\Users\Snorre\Documents\masteroppgave\Masteroppgave\corrected_data\2014-05-01-09-39-20_all_singlemotion_corrected_goodaffine_1000.mat');
bg_frames = bg_file.corrected_data.frames;
% imshowpair(frames1(:,:,1), bg_frames(:,:,1), 'ColorChannels', 'red-cyan')
frames = cat(3, bg_frames, frames1(:,:,240:1:250));
clear frames1;
%%
%get background and subtracted images
[linear_sub, background] = do_subtraction(frames, 'type', 'linear', 'background_idxs', 1:size(bg_frames,3));
% imshow(log_compress_2(background,'compress'));

%%
[l1, l2, l3] = size(linear_sub);
correlation = ones(l1, l2);
%%
for k = 2:5
    correlation = correlation.*get_correlation(linear_sub(:,:,k-1), linear_sub(:,:,k));
end

%%
hist(correlation(:), 20)
axis([0.1 1 0 100])
bw = correlation >0.7;
bw_o = bwareaopen(bw, 2);%Clear small objects. Maybe not smart. rather make mask and add intensty threshold
rp = regionprops(bw_o);
%%
%Dilate centroids and apply threshold??
%%
imagesc(frames(:,:,102));
colormap('gray')
hold on;
for m = 1:size(B2, 1)
        b = B2{m};
        plot(b(:,2), b(:,1),'r','LineWidth',2);
end
