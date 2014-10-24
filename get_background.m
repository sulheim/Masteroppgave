function background = get_background(files)
    %Take maximumvalue for each pixel for those files
    background = max(files(:,:,1), files(:,:,2));
    for i = 3:size(files,3)
            background = max(background, files(:,:,i));
    end
end