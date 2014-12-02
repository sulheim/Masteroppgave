function y = log_compress_2(x, compress_or_decompress)
%undo the log compression performed with log_compress:

switch compress_or_decompress
    case 'decompress'
%         y = ((10.^(x./20))-1)*1e3;
%         y = (10.^(4*x));%approx same compression
        y = 1e3.*(10.^(x./10)-1);

    case 'compress'
%         y = 20.*log10(x/1e3+1);
%         y = 0.25.*log10(x);
        y = 10.*(log10(0.001.*x + 1));
end

