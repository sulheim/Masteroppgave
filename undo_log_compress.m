function y = undo_log_compress(x, do_or_undo)
%undo the log compression performed with log_compress:
%An alternative to this elemtwise approac is to save the angles from
%log_compress. But these angles then have to be transformed as well...
%attempt!!!
switch do_or_undo
    case 'undo'
        y = ((10.^(x./20))-1)*1e3;
    case 'do'
        y = 20.*log10(x/1e3+1);
end

