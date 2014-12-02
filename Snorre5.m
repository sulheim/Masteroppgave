load C:\Users\Snorre\Documents\masteroppgave\Masteroppgave\corrected_data\2014-05-01-09-42-54_all_singlemotion_corrected_goodaffine_1000__linear_subtracted_1_to_100

for j=1:100,
    figure(1);
    X = interp2(sub.subtracted(293:300,222:230,j),4,'cubic');
    imagesc(X,[0 3.5e4]);
    title(['M1 ',int2str(j)]);
    axis image
    axis off
    colormap('gray');
    M1(j) = max(max(X));
    pause(0.1);
end;

figure(2);
plot(M1);
axis([0 100 0 3.5e4]);

for j=1:100,
    figure(1);
    X = interp2(sub.subtracted(297:303,264:276,j),4,'cubic');
    imagesc(X,[0 8e4]);
    title(['M2 ',int2str(j)]);
    axis image
    axis off
    colormap('gray');
    M2(j) = max(max(X));
    pause(0.1);
end;

figure(3);
plot(M2);
axis([0 100 0 8e4]);

for j=1:100,
    figure(1);
    X = interp2(sub.subtracted(314:326,246:262,j),4,'cubic');
    imagesc(X,[0 1e4]);
    title(['M3 ',int2str(j)]);
    axis image
    axis off
    colormap('gray');
    M3(j) = max(max(X));
    pause(0.1);
end;

figure(4);
plot(M3);
axis([0 100 0 1e4]);

for j=1:100,
    figure(1);
    X = interp2(sub.subtracted(376:382,342:358,j),4,'cubic');
    imagesc(X,[0 7e4]);
    title(['M4 ',int2str(j)]);
    axis image
    axis off
    colormap('gray');
    M4(j) = max(max(X));
    pause(0.1);
end;

figure(5);
plot(M4);
axis([0 100 0 7e4]);
