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
    default_ref_frame_idx = 1:3;
    default_frame_indexes = 1:total_number_of_frames;
    switch nargin
        case 1
            frame_indexes = default_frame_indexes;
            ref_frame_idx = default_ref_frame_idx;
        case 2
            ref_frame_idx = default_ref_frame_idx;
    end
    
    [pathstr,name,ext] = fileparts(fnameBase);

    
   %%
   %Make array for storing corrected BG_arrays. This may rather be a
   %cell arry?
   corrected_frames = zeros(512, 512, numel(frame_indexes)); 
   %%
   %Get reference frame data
   ref_frame.frame_idx = ref_frame_idx;
   [ref_frame.BG, ref_frame.param, corrected_frames(:,:, ref_frame_idx)] = make_ref_frame(fnameBase, ref_frame.frame_idx, ext);
   
%%
   %Run through all frames in frame_number and correct
   %Try Motion correction before and after compression
   %Motion corection with first image or previous image
   
   %%
   mse_before = zeros(1, numel(frame_indexes));
   mse_after = zeros(1, numel(frame_indexes));
   
   tic
   figure(1); 
   for i = frame_indexes
       txt = sprintf('Working on frame %d', i);
       disp(txt)
       
       %Get RF data for current frame and compress and resize
       switch ext
           case '.rf'
               [tmp_RF, ~] = ReadRF(fnameBase, '.bmode', i); 
           case '.iq'
               tmp_RF = get_RF_from_IQ(fnameBase, i);
       end
       tmp_BG = imresize(log_compress(tmp_RF), [512, 512]);
       
       %Calculate mse before correction
       mse_before(i) = mse(ref_frame.BG, tmp_BG);
        
       if mse_before(i) >= 0.01
           [aligned_BG, optimization_data] = align_image(ref_frame.BG, tmp_BG, 50); 
           
       else
           aligned_BG = tmp_BG;
           optimization_data = 0;
       end
       corrected_frames(:,:,i) = aligned_BG;
       mse_after(i) = mse(ref_frame.BG, aligned_BG);
       
       if i == frame_indexes(1)
           time_estimate = round(toc)*(numel(frame_indexes)-1);
           tmp_s = sprintf(['Estimated time is ', secs2hms(time_estimate)]);
           disp(tmp_s)
       end
       
       if mod(i, 10)==0
           t = toc;
           remaining_time = round((t/i)*(total_number_of_frames-i));
           disp(['Time left: ', secs2hms(remaining_time)])
       end
           
       %Plot optimization data 
       plot(optimization_data, 'erasemode','background')
       drawnow;
   end
  
   corrected_data.frames = corrected_frames;
   corrected_data.frame_indexes = frame_indexes;
   corrected_data.mse_before = mse_before;
   corrected_data.mse_after = mse_after;
   save_path = ['C:\Users\Snorre\Documents\masteroppgave\Masteroppgave\corrected_data\', name, 'motion_corrected'];
   save(save_path, 'corrected_data')
end


   


