function motion_correction_previous_frame(fnameBase, type, frame_indexes)
%Perform motion correction using previous(1,2,3??) frame(s) for reference
    if nargin > 3;
        error('Too many inputs. Maximum 2 input variables.');
    elseif nargin < 1;
        error('Too few inputs. Minimium 1 input variable.');
    end
    %%
    %get number of frames in file
    if exist('frame_indexes', 'var')
        total_number_of_frames = length(frame_indexes);
    else
        total_number_of_frames = frame_counter(fnameBase);
    end
        %%
    %set default values if not given in input
    %This should probably be modified to handle iq data as well
    default_frame_indexes = 1:total_number_of_frames;
    default_type = 'rigid';
    switch nargin
        case 1
            frame_indexes = default_frame_indexes;
            type = default_type;
        case 2
            frame_indexes = default_frame_indexes;
    end
    [pathstr,name,ext] = fileparts(fnameBase);
    
   %%
   %Make array for storing corrected BG_arrays. This may rather be a
   %cell arry?
   corrected_frames = zeros(512, 512, numel(frame_indexes)); 
   %%
   %Run through all frames in frame_number and correct
   %Try Motion correction with previous image
   
   %%
   mse_before = zeros(1, numel(frame_indexes));
   mse_after = zeros(1, numel(frame_indexes));
   
   tic
   figure(1); 
   
   %%Get first frame
    %Get reference frame data
   [ref_BG, ~, corrected_frames(:,:, 1:3)] = make_ref_frame(fnameBase, 1:3, ext);
   
   prev_BG = ref_BG;
   %%
   %Loop through frames
   for i = frame_indexes(4:end)
       txt = sprintf('Working on frame %d', i);
       disp(txt)
       
       %Get RF data for current frame and compress and resize
       switch ext
           case '.rf'
               [curr_RF, ~] = ReadRF(fnameBase, '.bmode', i); 
           case '.iq'
               curr_RF = get_RF_from_IQ(fnameBase, i);
       end
       curr_BG = imresize(log_compress(curr_RF), [512, 512]);
      
       %Calculate mse before correction
       mse_before(i) = mse(ref_BG, curr_BG);
       
       if mse_before(i) >= 0.001
           [aligned_BG, optimization_data] = align_image(prev_BG, curr_BG, type, 50); 
       else
           aligned_BG = curr_BG;
           optimization_data = 0;
       end
       
       mse_after(i) = mse(ref_BG, aligned_BG);
         
       %%%Check that correction is good
       if mse_after(i)<=mse_before(i)
           corrected_frames(:,:,i) = aligned_BG;
           prev_BG = aligned_BG;
       else
           corrected_frames(:,:,i) = curr_BG;
           disp('Corrected image is worse than original!')
           prev_BG = curr_BG;
       end
       
       if mod(i, 10)== 0
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
   save_path = ['C:\Users\Snorre\Documents\masteroppgave\Masteroppgave\corrected_data\', name, 'motion_corrected_', type, '_prevframe'];
   save(save_path, 'corrected_data')
end

