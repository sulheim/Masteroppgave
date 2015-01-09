function dy = rigid6(t,y)
sigma = 0.07;
dropdiameter = 2e-6;
r0 = bubradius(dropdiameter,0);
Patm = 101e3;
Pair = 92e3;
Pblood = 0e3;
Pd = Pair/Patm;
La = 1.7e-2;
Da = 2.05e-9;
Df = 6.9e-10;
delta = Da/Df;
Lf = 2.02e-4;
mu = 2*sigma/Patm/r0;
v = Pblood/Patm;
Xf = 1;
dy = zeros(3,1);    % a column vector
dy(1) = -3.*Lf.*y(1)./y(3).^2;
dy(2) = -3.*delta*La./y(3).^2.*(y(2)-Pd.*y(3).^3);
dy(3) = ( -3*delta*La*(y(2)-Pd.*y(3).^3)/y(3).^2 - 3*Lf/y(3).^2*(mu*y(3).^2+(1+v)*y(3).^3-y(2)) ) ./ ...
    ( (2*mu*y(3) + 3*(1+v)*y(3).^2) );