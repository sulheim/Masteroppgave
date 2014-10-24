f_base ='D:\Phase shift project\Ultrasound image data\2014-05-01-09-40-14.iq';
[rf, param] = get_RF_from_IQ(f_base, 500);
fs = 16*1e6;

%%
%plot spectrum
n=length(rf(:, 135));
k = 1:n;
T = n/fs;
frq = k/T;
frq = frq(1:end/2);
Y = fft(rf(:,135))/n;
plot(frq, abs(Y(1:end/2)))
%%
%plot spectrum of envelope
e = abs(hilbert(rf(:,135)));
e2 = e.^2;
A = abs(fft(e2)).^2;
A=A([end/2+1:end 1:end/2]);
plot(frq,A(n/2+1:n))

%%%%%%%%%%%%%%%DECIMATION%%%%%%%%%%%%%%%%%%
%From the graph above, it seems appropriate to say that the bandwidth of
%the envelope is 0.6 Mhz, thus the signal can be decimated by a factor
%8/0.6 ~12. Thus 6016/12 500 < 512, and thus 512 samples should be ok.


%%
plot(rf(:, 135),'bo')
%%
rf_2 = imresize(rf, [512, 256]);
hold on;
rf_3 = imresize(rf_2, size(rf));
plot(rf_3(:, 135), 'r-')
%%
e = abs(hilbert(rf));
e2 = abs(hilbert(rf));
e2 = imresize(imresize(e2, [1028,512]), size(rf));
figure;
plot(e(:, 135),'b*')
hold on;
plot(e2(:, 135), 'r')

%%
L = length(rf(:,135));
RF = fft(rf(:, 135));
A_RF = abs(RF).^2;
L_RF = length(RF);
%%
e2 = e.^2;
E = fft(e2(:,135));

A_E = abs(E).^2;


