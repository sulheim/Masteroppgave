function correlation = image_std(subtracted)
%Determines the standard deviation of each pixel 
    N = size(subtracted, 3);
    mean = sum(subtracted,3)./N;
    tmp = sqrt(sum((subtracted - repmat(mean, 1, 1, N)).^2, 3)./(N-1));
    correlation = single(tmp);
end

