%Code for Figures 5 and 7.
sigma = 0.04;
dropdiameter = 2e-6;
r0 = bubradius(dropdiameter,0);
Patm = 101e3;
Pair = 92e3;
Pd = Pair/Patm;
Pblood = 0e3;
La = 1.7e-2;
Da = 2.05e-9;
Df = 6.9e-10;
delta = Da/Df;
Lf = 2.02e-4;
mu = 2*sigma/Patm/r0;
v = Pblood/Patm;
Xf = 1;
y = [Xf*(mu+v+1),(1-Xf)*(mu+v+1),1];
[T,Y] = ode45(@rigid6,[0 5400],y);
figure(1);
subplot(2,1,1)
[hAx,hLine1,hLine2] = plotyy(T*r0^2/Df/4,Y(:,3)*r0*2,T*r0^2/Df/4,4/3*pi*(Y(:,3)*r0).^3);
legend('Diameter', 'Volume')
xlabel('Time(s)')
ylabel(hAx(1), 'Dimeter(m)')
ylabel(hAx(2), 'Volume(m^3)')
ylim(hAx(2), [0 4*10^-15])
set(hAx(2), 'YTick', [0:4]*1e-15);
title('Initial size: 2 microns')

%%%%%%%%%%
sigma = 0.04;
dropdiameter = 4e-6;
r0 = bubradius(dropdiameter,0);
Patm = 101e3;
Pair = 92e3;
Pd = Pair/Patm;
Pblood = 0e3;
La = 1.7e-2;
Da = 2.05e-9;
Df = 6.9e-10;
delta = Da/Df;
Lf = 2.02e-4;
mu = 2*sigma/Patm/r0;
v = Pblood/Patm;    
Xf = 1;
y = [Xf*(mu+v+1),(1-Xf)*(mu+v+1),1];
[T,Y] = ode45(@rigid6,[0 5400],y);
subplot(2,1,2)
[hAx,hLine1,hLine2] = plotyy(T*r0^2/Df/4,Y(:,3)*r0*2,T*r0^2/Df/4,4/3*pi*(Y(:,3)*r0).^3);
legend('Diameter', 'Volume')
xlabel('Time(s)')
ylabel(hAx(1), 'Dimeter(m)')
ylabel(hAx(2), 'Volume(m^3)')
ylim(hAx(2), [0 4*10^-14])
set(hAx(2), 'YTick', [0:4]*1e-14);
title('Initial size: 4| microns')