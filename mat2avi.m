function mat2avi(fnameBase)
%This function construct an .avi file from the motion corrected data. Input
%is name of file.
save_path = 'C:\Users\Snorre\Documents\masteroppgave\Masteroppgave\corrected_data\';
[~, name, ~] = fileparts(fnameBase);
matfile = load(fnameBase);
%%
%Make video object
    vidObj = VideoWriter([save_path, name,'.avi']);
    vidObj.FrameRate = 10;
    open(vidObj);
%%
    frames = matfile.corrected_data.frames;
    frame_idxs = matfile.corrected_data.frame_indexes;
    N = numel(frame_idxs);
    gray = mat2gray(frames);
    for k = 1:N
        writeVideo(vidObj, gray(:,:,k));
    end
    close(vidObj)
end

