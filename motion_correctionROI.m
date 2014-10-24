function [ output_args ] = Untitled3(fnameBase, type, frame_indexes, ref_frame_idx)
%Make motion correction after ROI is chosen

    if nargin > 4;
        error('Too many inputs. Maximum 3 input variables.');
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
    default_ref_frame_idx = 1:3;
    default_frame_indexes = 1:total_number_of_frames;
    default_type = 'rigid';
    switch nargin
        case 1
            frame_indexes = default_frame_indexes;
            ref_frame_idx = default_ref_frame_idx;
            type = default_type;
        case 2
            ref_frame_idx = default_ref_frame_idx;
            frame_indexes = default_frame_indexes;
        case 3
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
   %%
   %Make mask
   imagesc(ref_frame.BG);
   h = imfreehand(gca);
   mask = createMask(h);
   m_ref = ref_frame.BG.*mask;
   %%
    metric = registration.metric.MeanSquares();
    optimizer = registration.optimizer.RegularStepGradientDescent();
%     
    optimizer.MaximumIterations = 50;
    optimizer.MaximumStepLength = 0.01;
    optimizer.MinimumStepLength = 1e-4;
   
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
       tmp_BG = imresize(log_compress(tmp_RF), [512, 512], 'bilinear');
       
       %Calculate mse before correction
       mse_before(i) = mse(ref_frame.BG, tmp_BG);
        
       if mse_before(i) >= 0.01
           tmp_m = tmp_BG.*mask;
           tform = imregtform(tmp_m, m_ref, type, optimizer, metric); 
           aligned_BG  = imwarp(tmp_BG, tform,'OutputView',imref2d(size(tmp_BG)));

       else
           aligned_BG = tmp_BG;
           optimization_data = 0;
       end

       mse_after(i) = mse(ref_frame.BG, aligned_BG);
       %%%Check that correction is good
       if mse_after(i)<=mse_before(i)
           corrected_frames(:,:,i) = aligned_BG;
       else
           corrected_frames(:,:,i) = tmp_BG;
           disp('Corrected image is worse than original!')
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
   save_path = ['C:\Users\Snorre\Documents\masteroppgave\Masteroppgave\corrected_data\', name, 'motion_corrected_ROI',type];
   save(save_path, 'corrected_data')


end

