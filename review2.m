% Review2.m
G = [1.4e6 1.7e12 2.93e10 2.44e10];
p = [0.0011387 7.7 1.09 1.030];
z = [0.0004 46 1.79 1.59];
z-z(4);
ang = [0:pi/64:2.*pi];
sd1 = ( -cos(ang).*((p(1)-p(4))./(2.*p(1)+p(4))) +...
    ( (G(1)-G(4))./3./G(1) )).^2;
sd2 = ( -cos(ang).*((p(2)-p(4))./(2.*p(2)+p(4))) +...
    ( (G(2)-G(4))./3./G(2) )).^2;
sd3 = ( -cos(ang).*((p(3)-p(4))./(2.*p(3)+p(4))) +...
    ( (G(3)-G(4))./3./G(3) )).^2;
a = 1.5e-4;
% a = 15e-4;
lambda = 154200./3.5e6;
k = 2.*pi./lambda;
sdka = k^4.*a^6.*sd2;
sdkair = k^4.*a^6.*sd1;
figure(1);
polar(ang,sdka);
title('Differential scattering cross section: steel 3 micron');
h = gca;
set(h,'linewidth',2);
hc = get(h,'children');
if length(hc)>=1,
 for j=1:length(hc),
 set(hc(j),'linewidth',2);
 end;
end;
figure(2);
polar(ang,sdkair);
title('Differential scattering cross section: air 3 micron');
h = gca;
set(h,'linewidth',2);
hc = get(h,'children');
if length(hc)>=1,
 for j=1:length(hc),
 set(hc(j),'linewidth',2);
 end;
end;
drawnow;
%%
% Frequency
fax=3.5e6;
% Radius of bubble.
radius=[15].*1e-4;
% Backscatter angle.
rtheta = ang;
numsteps=length(rtheta);
rho = 1.03;
rho_ = 7.7; % steel
c = 154200;
c_ = 590000; % steel
% Number of terms.
nm=32;
for k=1:length(radius);
    r0=radius(k);
    for j=1:numsteps,
         f=fax;
         theta=rtheta(j);
         z0 = 2*pi*f*r0/c;
         z0_ = 2*pi*f*r0/c_;
         for m=0:nm,
             am = -i^m*(2*m+1) .* ...
             ( ...
             rho_*z0*sj(m+1,z0)*sj(m,z0_) - ...
             rho*z0_*sj(m,z0)*sj(m+1,z0_) + ...
             (rho-rho_)*m*sj(m,z0)*sj(m,z0_) ...
             ) ./ ...
             ( ...
             rho_*z0*sph_hankel2(m+1,z0)*sj(m,z0_) - ...
             rho*z0_*sph_hankel2(m,z0)*sj(m+1,z0_) + ...
             (rho-rho_)*m*sph_hankel2(m,z0)*sj(m,z0_) ...
             );
             Pm = legendre(m,cos(theta));
             eval(['sterm',int2str(j),'(m+1) = (-1)^m * am .* Pm(1,1) * i^(m+1);']);
         end;
        eval(['fx',int2str(nm),'(j,k) = (c/2/pi/f)^2 * abs(',...
        'sum(sterm',int2str(j),') )^2;']);
    end; % j.
end; % k.
figure(3);
polar(rtheta.',fx32);
title('Differential scattering cross section: steel 60 micron');
h = gca;
set(h,'linewidth',2);
hc = get(h,'children');
if length(hc)>=1,
 for j=1:length(hc),
 set(hc(j),'linewidth',2);
 end;
end;
drawnow;
% Frequency
fax=3.5e6;
% Radius of bubble.
radius=[30].*1e-4;
% Backscatter angle.
rtheta = ang;
numsteps=length(rtheta);
rho = 1.03;
rho_ = 0.0014;
c = 154200;
c_ = 33300; % air
% Number of terms.
nm=32;
for k=1:length(radius);
     r0=radius(k);
     for j=1:numsteps,
         f=fax;
         theta=rtheta(j);
         z0 = 2*pi*f*r0/c;
         z0_ = 2*pi*f*r0/c_;
         for m=0:nm,
             am = -i^m*(2*m+1) .* ...
             ( ...
             rho_*z0*sj(m+1,z0)*sj(m,z0_) - ...
             rho*z0_*sj(m,z0)*sj(m+1,z0_) + ...
             (rho-rho_)*m*sj(m,z0)*sj(m,z0_) ...
             ) ./ ...
             ( ...
             rho_*z0*sph_hankel2(m+1,z0)*sj(m,z0_) - ...
             rho*z0_*sph_hankel2(m,z0)*sj(m+1,z0_) + ...
             (rho-rho_)*m*sph_hankel2(m,z0)*sj(m,z0_) ...
             );
             Pm = legendre(m,cos(theta));
             eval(['sterm',int2str(j),'(m+1) = (-1)^m * am .* Pm(1,1) * i^(m+1);']);
         end;
        eval(['fx',int2str(nm),'(j,k) = (c/2/pi/f)^2 * abs(',...
        'sum(sterm',int2str(j),') )^2;']);
     end; % j.
end; % k.
figure(4);
polar(rtheta.',fx32);
title('Differential scattering cross section: air 30 micron');
h = gca;
set(h,'linewidth',2);
hc = get(h,'children');
if length(hc)>=1,
     for j=1:length(hc),
        set(hc(j),'linewidth',2);
     end;
end;