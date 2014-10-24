function [new_array, similarity_before, similarity_after] = run_demon(ref_frame, im_array, similarity_before, similarity_after)
%Run MATITK Demon image registration
%http://matitk.cs.sfu.ca/usageguide
    dim = size(im_array, 3);
    ref_array = repmat(ref_frame, 1, 1, dim);

    %Calculate similarity before optimization
    similarity_before = make_sim(similarity_before, ref_array, im_array, dim);
    
    %Perform registration
    new_array = matitk('RD', [128, 7, 50, 1.0], ref_array, im_array, [],[]);
   
    %Calculate similarity after optimization
    similarity_after = make_sim(similarity_after, ref_array, new_array, dim); 
end

function sim = make_sim(sim, ref_array, im_array, dim)
    for k = 1:dim
        k
        %mse
        sim(k, 1) = mse(ref_array(:,:,k), im_array(:,:,k));
        %ssd
        sim(k, 2) = ssd(ref_array(:,:,k), im_array(:,:,k));
        %cc
        sim(k, 3) = corr2(ref_array(:,:,k), im_array(:,:,k));
        %CD2
        sim(k, 4) = CD2(ref_array(:,:,k), im_array(:,:,k));
    end
end