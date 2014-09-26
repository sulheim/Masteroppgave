function motion_correction(fnameBase, frame_indexes, ref_frame_idx)
%Motion_correction aligns all images to the reference image, to remove
%motion from movies. fname is filename to the RF file. ref_frame is first
%image in sequence.

    if nargin > 3;
        error('Too many inputs. Maximum 3 input variables.');
    elseif nargin < 1;
        error('Too few inputs. Minimium 1 input variable.');
    end
    
    %%
    %get number of frames in file
    total_number_of_frames = frame_counter(fnameBase);
    %%
    %set default values if not given in input
    %This should probably be modified to handle iq data as well
    default_ref_frame_idx = 1;
    default_frame_indexes = 1:total_number_of_frames;
    switch nargin
        case 1
            frame_indexes = default_frame_indexes;
            ref_frame_idx = default_ref_frame_idx;
        case 2
            ref_frame_idx = default_ref_frame_idx;
    end
    
   %%
   %Get reference frame data
   ref_frame.frame_idx = ref_frame_idx;
   [ref_frame.RF, ref_frame.param] = ReadRF(fnameBase, '.bmode', ref_frame.frame_idx);
   ref_frame.BG = log_compress(ref_frame.RF);
   

   
   %%
   %Make array for storing corrected BG_arrays. This may rather be a
   %cell arry?
   corrected_frames = zeros(512, 512, numel(frame_indexes));
   %Run through all frames in frame_number and correct
   %Try Motion correction before and after compression
   %Motion corection with first image or previous image
   
   %%
   %Make movie object
   vidObj = VideoWriter(['C:\Users\Snorre\Documents\masteroppgave\Masteroppgave\','testvid','.avi']);
   vidObj.FrameRate = 2;
   open(vidObj);
   %%
   tic
   for i = frame_indexes
       sprintf('Working on frame %d', i)
       [tmp_RF, ~] = ReadRF(fnameBase, '.bmode', i); 
       tmp_BG = log_compress(tmp_RF);

       %IF_STATEMENT? If difference is larger than x, do align images
       [aligned_BG, optimization_data] = align_image(ref_frame.BG, tmp_BG, 50); 
       corrected_frames(:,:,i) = aligned_BG;
       figure(2147483646); image([0 ref_frame.param.BmodeWidth(1)],[3 21], aligned_BG)
%        axis image;
       colormap('gray');
       title([fnameBase,' ',int2str(i)],'interpreter','none');
       drawnow;
       currFrame = getframe;
       writeVideo(vidObj,currFrame);
       if i == frame_indexes(1)
           time_estimate = toc*(numel(frame_indexes)-1);
           sprintf('Estimated time is %d seconds', time_estimate)
       end
       %Plot optimization data
       figure(i); plot(optimization_data, 'erasemode','background')
   end
   close(vidObj);
   %%save struct
   corrected_data.frames = corrected_frames;
   corrected_data.frame_indexes = frame_indexes;
   [~, name, ext] = fileparts(fnameBase);
   save_fn = sprintf(name, 'motion_corrected', ext);
   save(save_fn, 'corrected_data')
end

   


