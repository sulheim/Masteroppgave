function corr = im_corr(old_corr_val,new_corr_val, correlation, N)
%Calculates correlation
    corr = correlation - (old_corr_val-new_corr_val)/N;
end

