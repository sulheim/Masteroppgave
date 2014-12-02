function run_program(file_name, background_idxs, background_file_name, corr_arr_file)
    [~, name, ~] = fileparts(file_name);
    
    %%
    %1. Make matfile from RF_data
    name_2 = [name, '_all_single', '.mat'];
    if exist(['C:\Users\Snorre\Documents\masteroppgave\Masteroppgave\mat_data\', name_2], 'file')
        disp('mat-file exists')
    else
        disp('Making mat-file')
        RF2mat(file_name);
    end
    
    
    close all;
    %%
    %If a background file is given, this should be used for the background
    %subtraction, and also the reference frame. This reference has to be
    %motion corrected.
    %Check if This file exist
    if exist('background_file_name', 'var')
        background = true;
        [~, b_name, b_ext] = fileparts(background_file_name);
        b_name2 = [ b_name, '_all_singlemotion_corrected_goodaffine.mat'];
        if exist(['C:\Users\Snorre\Documents\masteroppgave\Masteroppgave\corrected_data\', b_name2], 'file')
            disp('background file exist')
        else
            disp('Correct background file')
            RF2mat(background_file_name);
            motion_correction([b_name, '_all_single.mat'])
        end
    else
        background = false;
    end
    
    close all;
    clearvars -except b_name b_name2 background name name2 file_name background_file_name background_idxs
    %%
    %2. Motion_correction
    if background
        name_3 = [name, '_all_singlemotion_corrected_goodaffine_to_', b_name, '.mat'];
        if exist(['C:\Users\Snorre\Documents\masteroppgave\Masteroppgave\corrected_data\' name_3], 'file')
            disp('File has already been motion corrected')
        else
            disp('Motion_correction')
            motion_correction(name_2, 'ref_frame_file_name', b_name2)
        end
    else
        name_3 = [name, '_all_singlemotion_corrected_goodaffine.mat'];
        if exist(['C:\Users\Snorre\Documents\masteroppgave\Masteroppgave\corrected_data\' name_3], 'file')
            disp('File has already been motion corrected')
        else
            motion_correction(name_2)
        end
    end
    
    close all;
    
    %%
    %3. Subtract background
    sub_file = rdir(['C:\Users\Snorre\Documents\masteroppgave\Masteroppgave\corrected_data\', name, '_all_singlemotion_corrected_goodaffine*_linear_subtracted*.mat']);
    if isempty(sub_file)
        if background
            disp('Background_subtraction')
            subtraction_fun(name_3, background_idxs, 'background_file_name', [b_name, '_all_singlemotion_corrected_goodaffine.mat'])
        else
            subtraction_fun(name_3, background_idxs)
        end
    else
        disp('File has already been subtracted!')
    end
        
    close all;
    %%
    %4. Count bubbles
    %Check for correlation array
    if exist('corr_arr_file', 'var')
        c = load(['C:\Users\Snorre\Documents\masteroppgave\Masteroppgave\Phaseshiftcounting\', corr_arr_file, '_PS_count']);
        corr_arr = c.m.corr_arr;
    else
        corr_arr =[];
    end
    
    file = dir(['C:\Users\Snorre\Documents\masteroppgave\Masteroppgave\Phaseshiftcounting\', name,'_count_and_color*.avi']);
    if isempty(file)
        disp('counting bubbles!')
        file2 = rdir(['C:\Users\Snorre\Documents\masteroppgave\Masteroppgave\corrected_data\', name,'_all_singlemotion_corrected_goodaffine*_linear_subtracted*.mat']);
        count_PS_bubbles(name_3, file2.name, 'init_corr_arr', corr_arr)
    else
        disp('File exists, are bubbles counted??')
    end
    disp('All done')
    
end