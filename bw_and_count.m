function [B, rp] = bw_and_count(subtracted, intensity_min, size_min)
    %Convert subtracted image to bw, then find bubbles and count
    bw = subtracted > intensity_min;
    %Clear small objects
    bw = bwareaopen(bw, size_min);
    %Find boundaries
    B = bwboundaries(bw);
    rp = regionprops(bw);
end