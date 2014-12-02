load ('C:\Users\Snorre\Documents\masteroppgave\Masteroppgave\corrected_data\2014-05-02-10-44-41_all_singlemotion_corrected_goodaffine_to_2014-05-02-10-39-41_linear_subtracted_1_to_100')

for j=1:100,
    figure(1);
    X = interp2(sub.subtracted(348:358,280:296,j),4,'cubic');
    imagesc(X,[0 6.5e4]);
    title(['M1 ',int2str(j)]);
    axis image
    axis off
    colormap('gray');
    M1(j) = max(max(X));
    pause(0.1);
end;

figure(2);
plot(M1);
axis([0 100 0 6.5e4]);

for j=1:100,
    figure(1);
    X = interp2(sub.subtracted(392:410,295:320,j),4,'cubic');
    imagesc(X,[0 7.2e4]);
    title(['M2 ',int2str(j)]);
    axis image
    axis off
    colormap('gray');
    M2(j) = max(max(X));
    pause(0.1);
end;

figure(3);
plot(M2);
axis([0 100 0 7.2e4]);

for j=1:100,
    figure(1);
    X = interp2(sub.subtracted(364:378,194:210,j),4,'cubic');
    imagesc(X,[0 4e4]);
    title(['M3 ',int2str(j)]);
    axis image
    axis off
    colormap('gray');
    M3(j) = max(max(X));
    pause(0.1);
end;

figure(4);
plot(M3);
axis([0 100 0 4e4]);

for j=1:100,
    figure(1);
    X = interp2(sub.subtracted(322:332,312:322,j),4,'cubic');
    imagesc(X,[0 2e4]);
    title(['M4 ',int2str(j)]);
    axis image
    axis off
    colormap('gray');
    M4(j) = max(max(X));
    pause(0.1);
end;

figure(5);
plot(M4);
axis([0 100 0 2e4]);

for j=1:100,
    figure(1);
    X = interp2(sub.subtracted(443:452,29:45,j),4,'cubic');
    imagesc(X,[0 5e4]);
    title(['M5 ',int2str(j)]);
    axis image
    axis off
    colormap('gray');
    M5(j) = max(max(X));
    pause(0.1);
end;

figure(6);
plot(M5);
axis([0 100 0 5e4]);

for j=1:100,
    figure(1);
    X = interp2(sub.subtracted(445:460,250:264,j),4,'cubic');
    imagesc(X,[0 11e4]);
    title(['M6 ',int2str(j)]);
    axis image
    axis off
    colormap('gray');
    M6(j) = max(max(X));
    pause(0.1);
end;

figure(7);
plot(M6);
axis([0 100 0 11e4]);

for j=1:100,
    figure(1);
    X = interp2(sub.subtracted(330:340,195:210,j),4,'cubic');
    imagesc(X,[0 3e4]);
    title(['M7 ',int2str(j)]);
    axis image
    axis off
    colormap('gray');
    M7(j) = max(max(X));
    pause(0.1);
end;

figure(8);
plot(M7);
axis([0 100 0 2.5e4]);