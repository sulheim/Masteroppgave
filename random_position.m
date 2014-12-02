function [x_pos, y_pos] = random_position(roi_mask, N)
%Draw a random position within ROI
    x_pos = zeros(1,N);
    y_pos = zeros(1,N);
    [ly, lx] = size(roi_mask);
    for k = 1:N
        outside_roi = true;
        while outside_roi
            y = unidrnd(ly);
            x = unidrnd(lx);
            outside_roi = ~roi_mask(y,x);
        end
        x_pos(k) = x;
        y_pos(k) = y;
    end
end


