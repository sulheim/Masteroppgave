%test subtraction
%Load files
clear all;
close all;
base = 'C:\Users\Snorre\Documents\masteroppgave\Masteroppgave\corrected_data\';
name = '2014-05-01-09-40-14_all_singlemotion_corrected_goodaffine_1000.mat';
fnameBase =[base, name];
load(fnameBase);
frames = corrected_data.frames;
%%
%Define constants
min_intensity = 10;
min_size = 6;
background_idxs = 1:20;
subtracted_idxs = 21:1:40;
%%
%Make empty arrays
% subtracted = zeros(512, 512, length(subtracted_idxs));
% B = zeros(200, length(subtracted_idxs));
% rp = zeros(200, length(subtracted_idxs));
%%
%Get subtracted 
subtracted = do_subtraction(frames, background_idxs, subtracted_idxs);

%%
%%
%Make video object
    save_path = 'C:\Users\Snorre\Documents\masteroppgave\Masteroppgave\Phaseshiftcounting\';
    [~,name, ~]= fileparts(name);
    vidObj = VideoWriter([save_path, name,'.avi']);
    vidObj.FrameRate = 5;
    open(vidObj);
%%
%get bw and count
l =size(subtracted, 3);
%Preallocate B
element = struct('boundaries',cell(0), 'rp', struct([]), 'len', 0);
B(1, l) = element;
%%
%run throug alle elements in subtracted
for k = 1:l
    [b, rp] = bw_and_count(subtracted(:,:,k), min_intensity, min_size);
    B(k).boundaries = b;
    B(k).rp = rp;
    B(k).len = min(length(b), length(rp));
end

%%
%Plot boundary on top of image

for k = 1:l
    k
%     h = figure(1);
%     subplot(1,2,1);
    imagesc([0 23],[2 18], frames(:,:,subtracted_idxs(k)))
    colormap('gray')
    axis image;
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
    frame = getframe;
    writeVideo(vidObj, frame);
end
close(vidObj)


