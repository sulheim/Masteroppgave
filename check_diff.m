%check_diff
close all;
clear all;
set(0,'defaultTextUnits','Normalized');
% specify filename here ------------------
fnameBase = 'D:\Phase shift project\Ultrasound image data\2014-05-02-09-42-04.rf';
[pathstr,name,ext] = fileparts(fnameBase);
%%
%get number of frames in file
total_number_of_frames = frame_counter(fnameBase);
%%
%Get reference frame data
ref_frame.frame_idx = 1:3;
[ref_frame.BG, ref_frame.param, ~] = make_ref_frame(fnameBase, ref_frame.frame_idx);

%%
mse_array = zeros(1, total_number_of_frames);


for i = 1:total_number_of_frames
   s = sprintf('Working on frame %d', i);
   disp(s)
   [tmp_RF, ~] = ReadRF(fnameBase, '.bmode', i); 
   tmp_BG = log_compress(tmp_RF);
   tmp_BG = imresize(tmp_BG, [512, 512]);
   
   mse_array(i) = mse(ref_frame.BG, tmp_BG);
end
figure; plot(mse_array);
title('Plot of mean square error with respect to frame 1')
xlabel('Frame number')
ylabel('Mean square error')
savestring = sprintf(['mse_plot', name,'.jpg']);
saveas(gcf, savestring)


   