function [BG, angle] = log_compress(RF)
%compress the RF data with logarithmic expression
h = hilbert(RF);
BG = 20.*log10(abs(h)/1e3+1);
angle = 20.*log(ang(h)/1e3+1);
end

