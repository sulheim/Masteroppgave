function [avg_frame, param, ref_frames] = make_ref_frame(fnameBase, frame_idxs,ext)
    %make compressed and resized data from RF_data
    frames = zeros(512);
    ref_frames = zeros(512, 512, numel(frame_idxs));
    k = 1;
    for i=frame_idxs
        switch ext
            case '.rf'
                [tmp, param] = ReadRF(fnameBase, '.bmode', i);
            case '.iq'
                [tmp, param] = get_RF_from_IQ(fnameBase, i);
        end
        tmp = log_compress(tmp);
        frames = frames + imresize(tmp,[512, 512]);
        ref_frames(:,:,k) = imresize(tmp,[512, 512]);
        k = k + 1;
    end
avg_frame = frames./numel(frame_idxs);
end
