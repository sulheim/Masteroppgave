function res = mse(A, B)
%Calculate the mean square error between two matrices
tmp =abs(A-B).^2;
res = sum(tmp(:))/numel(tmp);
end

