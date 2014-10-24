function corr = multi_corr2(corr_arr, method, N)
    N = size(corr_arr, 3);
    switch method
        case 1
            tmp = corr_arr(:,:,1).^(1/N);
            for k = 2:N
                tmp = tmp.*(corr_arr(:,:,k).^(1/(N+1-k)));
            end
            corr = single(tmp);
        case 2%Average
            tmp = sum(corr_arr, 3)./N;
            corr = single(tmp);
        case 3
           tmp = nthroot(prod(corr_arr, 3), N);
           corr = single(tmp);
        case 4
            w = 1.25:0.25:6;
            for k = 1:N
                tmp_arr = corr_arr(:,:,k).*w(k);
            end
            tmp = sum(tmp_arr, 3)./sum(w);
            corr = single(tmp);
    end
    
end
