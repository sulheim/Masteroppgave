function diff = im_sub(A,B, type)
    %subtract one image from another, an set all values less than 0 to 0 in
    %the difference matrix. Type is either 'repmat' or 'loop'
    switch type
        case 'repmat'
            if size(A,3)~=size(B, 3)
                B = repmat(B, 1,1,size(A, 3));
            end
            diff = A-B;
            diff = single(max(0, diff));
        case 'loop'
            diff = zeros(size(A));
            for k = 1:size(A,3)
                diff(:,:,k) = single(max(A(:,:,k)-B, 0));
            end
    end
end
