function  subtraction_fun(motion_corrected_file_name, background_idxs, varargin)
%Function for subtracting background from all image frames;
%Varargin may be 'background_file_name', 'subtraction_idxs';

%Load in motion  corrected frames
    motion_corrected_file_base = 'C:\Users\Snorre\Documents\masteroppgave\Masteroppgave\corrected_data\';
    motion_corrected = load([motion_corrected_file_base, motion_corrected_file_name]);
    motion_corrected.corrected_data.frames = single(motion_corrected.corrected_data.frames);

    %Set default parameters
    subtraction_idxs = single(motion_corrected.corrected_data.frame_indexes);
    for k=1:2:length(varargin), % overwrite default parameter
        eval([varargin{k},'=varargin{',int2str(k+1),'};']);
    end

%Load in background file_name if it exists.
%If background_file not exist, a background is estimated from the file 
% motion_corrected
    if exist('background_file_name', 'var')
        background_file = load([motion_corrected_file_base, background_file_name]);
    else
        background_file.corrected_data.frames = [];
        subtraction_idxs(background_idxs)=[];
    end
   
    
%Concatenate files
    frames = single(cat(3, background_file.corrected_data.frames, motion_corrected.corrected_data.frames));
%clear files
    clear background_file.corrected_data.frames;
    clear motion_corrected.corrected_data.frames;
%%
%get background and subtracted images
    [linear_sub, background] = do_subtraction(frames, 'type', 'linear', 'background_idxs', background_idxs);
    
%%
    disp('Saving, Dont Quit')
    [~, save_name, ~] = fileparts(motion_corrected_file_name);
    save_lin = ['C:\Users\Snorre\Documents\masteroppgave\Masteroppgave\corrected_data\', save_name, '__linear_subtracted_',...
        num2str(subtraction_idxs(1))','_to_', num2str(subtraction_idxs(end))];
    sub.subtracted = linear_sub;
    sub.background = background;
    sub.sub_idxs = subtraction_idxs;
    save(save_lin, 'sub');     
end
