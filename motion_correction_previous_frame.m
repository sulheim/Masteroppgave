function motion_correction_previous_frame(fnameBase, type, frame_indexes)
%Perform motion correction using previous(1,2,3??) frame(s) for reference
    if nargin > 3;
        error('Too many inputs. Maximum 2 input variables.');
    elseif nargin < 1;
        error('Too few inputs. Minimium 1 input variable.');
    end
    %%
    %get file
    disp(fnameBase)
    matfile = load(fnameBase);
    data = matfile.matfile.frames;
    dim = size(data,3);
    
        %%
    %set default values if not given in input
    %This should probably be modified to handle iq data as well
    default_frame_indexes = 1:dim;
    default_type = 'affine';
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
   corrected_frames = zeros(512, 512, length(frame_indexes)); 
   %%
   %Run through all frames in frame_number and correct
   %Try Motion correction with previous image
   
   %%
   mse_before = zeros(1, numel(frame_indexes));
   mse_after = zeros(1, numel(frame_indexes));
   
   mse_before_prev = zeros(1, numel(frame_indexes));
   mse_after_prev = zeros(1, numel(frame_indexes));
   tic
   figure(1); 

   %%
   %Get reference frame
   ref_frame = sum(data(:,:,1:3), 3)/3;
   prev_BG = ref_frame;
   %%
   
   %Loop through frames
   for i = frame_indexes
       txt = sprintf('Working on frame %d', i);
       disp(txt)
       
       %Get RF data for current frame and compress and resize

       curr_BG = data(:,:,i);
      
       %Calculate mse before correction
       mse_before(i) = mse(ref_frame, curr_BG);
       mse_before_prev(i) = mse(prev_BG, curr_BG);
       
       if mse_before(i) >= 0.001
           [aligned_BG, optimization_data] = align_image(prev_BG, curr_BG, type, 2000); 
       else
           aligned_BG = curr_BG;
           optimization_data = 0;
       end
       
       mse_after(i) = mse(ref_frame, aligned_BG);
       mse_after_prev(i) = mse(prev_BG, aligned_BG);
         
       %%%Check that correction is good
       if mse_after_prev(i)<=mse_before_prev(i)
           corrected_frames(:,:,i) = aligned_BG;
           prev_BG = aligned_BG;
       else
           corrected_frames(:,:,i) = curr_BG;
           disp('Corrected image is worse than original!')
           prev_BG = curr_BG;
       end
       
       if mod(i, 10)== 0
           t = toc;
           remaining_time = round((t/(i-frame_indexes(1)))*(length(frame_indexes)-i));
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
   corrected_data.mse_before_prev = mse_before_prev;
   corrected_data.mse_after_prev = mse_after_prev;
   corrected_data.param = matfile.matfile.param;
   
   save_path = ['C:\Users\Snorre\Documents\masteroppgave\Masteroppgave\corrected_data\', name, 'motion_corrected_', type, '_prevframe2000'];
   save(save_path, 'corrected_data')
end

