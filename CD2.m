function res = CD2(im1, im2, alpha)
%Measure similiarity using the CD2 algorithm
% CD2 similarity measure: Cohen, B., Dinstein, I.: New maximum likelihood motion estimation schemes for
% noisy ultrasound images. Pattern Recognition 35(2),2002
%ref mirt2D_similarity.m
    switch nargin
        case 1
            error('Too few input arguments. Need two images')
        case 2
            alpha = 0.1;%Default value of alpha.
    end
    f = (im1-im2)/alpha;
    res = 2*sum(log(cosh(f(:))));
end


