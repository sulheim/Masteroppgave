%check_diff
close all;
clear all;
set(0,'defaultTextUnits','Normalized');
% specify filename here ------------------
fnameBase = 'D:\Phase shift project\Ultrasound image data\2014-05-02-09-47-04.rf';

%%
%get number of frames in file
total_number_of_frames = frame_counter(fnameBase);
%%
%Get reference frame data
ref_frame.frame_idx = 1;
[ref_frame.RF, ref_frame.param] = ReadRF(fnameBase, '.bmode', ref_frame.frame_idx);
ref_frame.BG = log_compress(ref_frame.RF);
ref_frame.BG = imresize(ref_frame.BG, [512, 512]);
%%
%Make movie object
vidObj = VideoWriter(['C:\Users\Snorre\Documents\masteroppgave\Masteroppgave\','diffvid2','.avi']);
vidObj.FrameRate = 4;
open(vidObj);
%%
mse_array = zeros(1, total_number_of_frames);
figure; set(gcf, 'Color','white')
% set(gca, 'nextplot','replacechildren', 'Visible','off');

for i = 1:total_number_of_frames
   s = sprintf('Working on frame %d', i);
   disp(s)
   [tmp_RF, ~] = ReadRF(fnameBase, '.bmode', i); 
   tmp_BG = log_compress(tmp_RF);
   tmp_BG = imresize(tmp_BG, [512, 512]);
   
   mse_array(i) = mse(ref_frame.BG, tmp_BG);
   imshowpair(ref_frame.BG, tmp_BG, 'ColorChannels','red-cyan');
   title([fnameBase,' ',int2str(i)],'interpreter','none');
   writeVideo(vidObj,getframe);
end

close(gcf)
close(vidObj)
figure; plot(mse_array);
title('Plot of mean error with respect to frame 1')
xlabel('Frame number')
ylabel('Mean square error')

   