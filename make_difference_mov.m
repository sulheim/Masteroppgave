%Make movie with differences
function make_difference_mov(fname)
    %%
    %get corrected data
    Base = 'C:\Users\Snorre\Documents\masteroppgave\Masteroppgave\corrected_data\';
    matfile = load([Base, fname, '.mat']);
    matfile = matfile.corrected_data.frames;
    [~,~,corr_size] = size(matfile);

    %%
    %Get original data
    file = fname(1:(strfind(fname, 'm')-1));
%     fnameBase = ['C:\Users\Snorre\Documents\masteroppgave\Masteroppgave\mat_data\', file, '.mat'];
    fnameBase = 'C:\Users\Snorre\Documents\masteroppgave\Masteroppgave\corrected_data\2014-04-28-10-21-25motion_corrected_affine_prevframe.mat';
    disp(fnameBase)
    original_data = load(fnameBase);    
%     original_data = original_data.matfile;
    original_data = original_data.corrected_data.frames;
    [~,~,orig_size] = size(original_data);

    %Check that size of matrices are the same
%     if (orig_size ~= corr_size)
%         error('not same size on corrected and original data')
%     end

    %%
    %Make video object
    %     vidObj = VideoWriter([save_path, f,'motion_corrected_diff.avi']);
        s = [Base, file, 'motion_corrected_diff_affine_orig_2.avi'];
        vidObj = VideoWriter(s);
        vidObj.FrameRate = 5;
        open(vidObj);
    %%
    % make ref frame
    ref_frame = (original_data(:,:,1)+original_data(:,:,2)+original_data(:,:,3))/3.0;
%     for i =1:orig_size
    size(matfile)
    size(original_data)
    for i = 30:100 
        imshowpair(matfile(:,:,i), original_data(:,:,i), 'ColorChannels', 'red-cyan');
        im = getframe;
        writeVideo(vidObj, im)
    end
    close(vidObj)

end