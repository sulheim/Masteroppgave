function [sigmae, sigmas, fr] = sonazoidl(R0,f)
% Calculation of damping constants
% Note: parameters in cgs units.
% R0 : Bubble radius, should be specified in cm.
% f : Acoustic frequency, in hertz.
% Below are the constants for blood plasma.
P0 = 1.01e6;% microbar for cgs units. (maybe change to 1.013)
rho = 1.03; % g/cm3.
c0 = 1.542e5; % cm/sec.
mu = 0.018; % g/cm/sec. Value for plasma
gamma = 1.403; % .
D1 = 0.07; % cm2/sec.
w = 2.*pi.*f; % Angular frequency.
mus = 8.0; % dyne.s/cm2 shell viscosity.
ds = 4e-7; % cm shell thickness.
ds = 0;
Gs = 500e6; % dyne/cm2
Ld = sqrt(D1./2./w);
Tor = (1+i).*R0./2./Ld;
Phi = 1./gamma.*(1 + 3.*(gamma-1)./Tor.^2.*( Tor.*coth(Tor)-1 ) );
kappa = real(1./Phi);
Kp = kappa.*P0+4.*Gs.*ds/R0;
w0 = 1./R0.*sqrt( (3.*Kp)./rho );
fr = w0./2./pi;
deltac = w.^2.*R0./(w0.*c0);
deltaeta = 4.*mu./w0./rho./R0.^2;
deltath = 3.*P0./w./w0./rho./R0.^2.*imag(1./Phi);
deltas = 12.*mus.*ds./w0./rho./R0.^3;
deltatot = deltac + deltaeta + deltath + deltas;
Omega = w./w0;
sigmas = 4.*pi.*R0.^2.*Omega.^4./((1-Omega.^2).^2+(Omega.*deltatot).^2);
sigmae = sigmas .* (deltatot./deltac);