function BG = log_compress(RF)
%compress the RF data with logarithmic expression
BG = 20.*log10(abs(hilbert(RF))/1e3+1);
end

