function out = sj(n,x)
% spherical bessel function
 if ((n==0) & (x == 0)),
 out=1,
 else
 out = (pi/2/x).^0.5 .* besselj(n+0.5,x);
 end;
