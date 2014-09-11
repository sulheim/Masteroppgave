function optimization_data = evalc2decimal(T)
%eval2decimal converts the string obtained with evalc to an array
%containing all decimal number unlike 0
    T = regexp(T, '\d(\.\d\d\d\d\s)', 'match');
    optimization_data = zeros(numel(T), 1);
    for i = 1:numel(T)
        optimization_data(i) = str2double(T{i});
    end
end



