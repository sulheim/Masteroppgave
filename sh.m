function out = sh(n,x);
% spherical hankel function of the second kind.
 out = sj(n,x)-i*sn(n,x);
%  out = sj(n,x)-(-1)^(n+1)*i*sj(-n,x);