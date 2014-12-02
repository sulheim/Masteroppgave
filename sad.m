function res = sad(im1, im2)
%SUM OF ABSOLUTE DIFFERENCES
    d = abs(im1-im2);
    res = sum(d(:));
end

