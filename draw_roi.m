function roi_mask = draw_roi(img)
    %Draw Region of interst for bubble counting inside tumour
    figure(10)
    imagesc(img);
    colormap('gray');
%     h = imfreehand(gca);
    h = impoly(gca);
    roi_mask = createMask(h);
    close(10)
end

  