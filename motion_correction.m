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
   tic
   [ref_frame.RF, ref_frame.param] = ReadRF(fnameBase, '.bmode', ref_fram.ref_frame_idx);
   ref_frame.BG = 20.*log10(abs(hilbert(ref_frame.RF))/1e3+1);
   time_estimate = toc*numel(frame_indexes);
   sprintf('Estimated time is %d seconds', time_estimate)
   
   
   %%
   %Make array for storing corrected BG_arrays. This may rather be a
   %cell arry?
   corrected_frames = zeros(ref_frame.param.BmodeNumSamples, ref_frame.param.BmodeNumLines, numel(frame_indexes));
   %Run through all frames in frame_number and correct
   %Try Motion correction before and after compression
   %Motion corection with first image or previous image
   for i = frame_indexes;
       [tmp_RF, ~] = ReadRF(fnameBase, '.bmode', 
       tmp_BG = 20.*log10(abs(hilbert(tmp_RF))/1e3+1);
       %IF_STATEMENT? If difference is larger than x, do align images
       corrected_frames(:,:,i) = align_image(ref_frame.BG, tmp_BG);
   end
   
   %%save struct
   corrected_data.frames = corrected_frames;
   corrected_data.frame_indexes = frame_indexes;
   save_fn = ['motion_corrected', fnameBase];
   save(save_fn, corrected_data)
end

   


