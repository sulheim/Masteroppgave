%Test theory of downsampling
%Test theory
RF_line = RF(1,:);
a_line = abs((hilbert(RF(1,:)))).^2;
figure(1); plot(a_line)

%%FFT
FFT_RF = fft(RF_line);
FFT_a = fft(a_line);
figure(2);
plot(abs(FFT_RF).^2)
figure(3); plot(abs(FFT_a).^2)
