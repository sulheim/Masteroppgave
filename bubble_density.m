function density = bubble_density(N,roi_mask, BmodeWidth, BmodeDepth, BmodeDepthOffset)
%Calculate the density of bubbles (#/mm2) 
    plane_height = 200; %(mm)
    pixel_width = BmodeWidth/512;%mm/pixel
    pixel_height = (BmodeDepth-BmodeDepthOffset)/512;%mm/pixel
    
    %Get area
    area = sum(roi_mask(:))*pixel_width*pixel_height;%mm2
%     volume = area*plane_height;
%     density = N/volume;
    density = N/area; 
end

