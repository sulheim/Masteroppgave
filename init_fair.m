%initialize fair
%%
%Initialize interpolation scheme and coefficients
inter('set', 'inter', 'splineInter');%Choose spline interpolation
%%
%Initialize distance measure
distance('set', 'distance', 'SSD');
%Initialize transformation and a starting guess
trafo('reset', 'trafo', 'affine2D');
w0 = trafo('w0'); %Starting gues for wc
omega = [0,1,0,1];