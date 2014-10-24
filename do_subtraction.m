function [subtracted, background] = do_subtraction(file, varargin)% type, background_idxs, sub_idxs)
%Make a background from the given indexes, and subtract the background from
%the frames given by sub_idxs. If type is equal to 'linear', the frames are
%are also decompressed. Varargins may be type(linear or log),
%background_idxs, sub_idxs. 
    %set default values
%     disp(length(varargin))
    type = 'linear';
    background_idxs = 1:10;
    for k=1:2:length(varargin), % overwrite default parameter
        eval([varargin{k},'=varargin{',int2str(k+1),'};']);
    end;
    
    if ~exist('sub_idxs', 'var')
            sub_idxs = 1:size(file, 3);
            sub_idxs(background_idxs) = [];
    end
    %%
    %Linearise
    switch type
        case 'linear'
            file = log_compress_2(file, 'decompress');
        case 'log'
        otherwise
            error('type has to be either linear og log')
    end
    %Get background
    background = get_background(file(:,:,background_idxs));
    %%
    %filter background
    fun = @(x) max(x(:));
    background = nlfilter(background, [3 3], fun);
    close all;
    
    %%
    files_4_subtraction = file(:,:, sub_idxs);
    subtracted = im_sub(files_4_subtraction, background);%subtract background from all data images
end

