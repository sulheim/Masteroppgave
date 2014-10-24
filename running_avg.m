function corr = running_avg(correlation,corr_arr, c0, N)
%Get running average at each pixel
    tmp = correlation + (corr_arr(:,:,end)-c0)./N;
    corr = single(tmp);
end

