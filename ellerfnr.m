function [sigmae, sigmas, fr] = ellerfnr(R0,f)
% Calculation of damping constants after :
% A. J. Eller, 1970, "Damping constants of pulsating bubbles",
% JASA, vol. 47, #5, PT(2).
% Note: parameters in cgs units.
% R0 : Bubble radius, should be specified in cm.
% f : Acoustic frequency, in hertz.
% Below are the constants for air bubbles in blood plasma.
P0 = 1.013e6; % microbar for cgs units.
rho = 1.03; % g/cm3.
c = 1.542e5; % cm/sec.
mu = 0.018; % g/cm/sec.
gamma = 1.403;
D1 = 0.20; % cm2/sec.
w = 2.*pi.*f; % Angular frequency.
X = R0 .* sqrt(2.*w./D1);
dth = 3.*(gamma-1).*( (X.*(sinh(X)+sin(X))-2.*(cosh(X)-cos(X)))./...
 (X.^2.*(cosh(X)-cos(X)) + 3.*(gamma-1).*X.*(sinh(X)-sin(X))) );
n = gamma ./ (1+dth.^2) ./ (1+3.*(gamma-1)./X.*((sinh(X)-sin(X))./...
    (cosh(X)-cos(X))));
drad = rho.*R0.^3.*w.^3./(3.*n.*P0.*c);
dvis = 4.*w.*mu./(3.*n.*P0);
d = dth + drad + dvis;
eta = sqrt(rho.*w.^2.*R0.^2./(3.*n.*P0));
fr = 1./(2.*pi.*R0).*sqrt(3.*n.*P0./rho);
sigmas = 4.*pi.*R0.^2 ./ (((fr./f).^2 - 1).^2 + (fr./f).^4.*d.^2);
sigmae = sigmas .* (d./drad);