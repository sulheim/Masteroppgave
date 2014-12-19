% Review1.m
% Calculation of scattering cross-sections.
% Steel and air.
G = [1.4e6 1.7e12 2.93e10 2.44e10];
Gt = ((G-G(4))./3./G).^2;
p = [0.0011387 7.7 1.09 1.030];
pt = 1./3.*((p-p(4))./(2.*p+p(4))).^2;
P0 = 1.013e6; % microbar for cgs units.
rho = 1.03; % g/cm3. density of plasma
gamma = 1.403;
R0 = 1.5e-4; % 3 micron diameter
% Estimation of resonance freq. using approximation formula.
estimf = 1./2./pi./R0.*sqrt(3.*gamma.*P0./rho);
% Now numerically search for precise values.
for j=1:length(R0),
    f(j) = fminbnd(['-(sonazoidl(',num2str(R0(j),16),',x))'],...
    estimf(j)./4,estimf(j).*3.0,optimset('TolX',1e-10,'Display','off'));
end;
[sigmae, sigmas, fr] = sonazoidl(R0,f);
% Now numerically search for precise values.
for j=1:length(R0),
    fa(j) = fminbnd(['-(ellerfnr(',num2str(R0(j),16),',x))'],...
    estimf(j)./4,estimf(j).*3.0,optimset('TolX',1e-10,'Display','off'));
end;
[sigmaeair, sigmasair, frair] = ellerfnr(R0,fa);
% For Rayleigh's model. Sonazoid bubble resonance frequency.
air = 4.*pi.*(R0).^2.*(2.*pi.*f./1.542e5.*R0).^4.*(Gt(1)+pt(1));
mild_steel = 4.*pi.*(R0).^2.*(2.*pi.*f./1.542e5.*R0).^4.*(Gt(2)+pt(2));
rbc = 4.*pi.*(R0).^2.*(2.*pi.*f./1.542e5.*R0).^4.*(Gt(3)+pt(3));
% For Rayleigh's model. Air bubble resonance frequency.
airfa = 4.*pi.*(R0).^2.*(2.*pi.*fa./1.542e5.*R0).^4.*(Gt(1)+pt(1));
mild_steelfa = 4.*pi.*(R0).^2.*(2.*pi.*fa./1.48e5.*R0).^4.*(Gt(2)+pt(2));
rbcfa = 4.*pi.*(R0).^2.*(2.*pi.*fa./1.542e5.*R0).^4.*(Gt(3)+pt(3));
% Including resonance effects. Sonazoid bubble, and air bubble.
disp(['Rayleigh model air to steel :',num2str(air./mild_steel)]);
fa,
disp('Increase when including resonance effects, air : ');
sigmasair./airfa
disp('Air ratio to steel: ');
sigmasair./mild_steelfa
disp('Air ratio to rbc: ');
sigmasair./rbcfa
f,
disp('Increase when including resonance effects, sonazoid : ');
sigmas./air
disp('Sonazoid ratio to steel: ');
sigmas./mild_steel
disp('Sonazoid ratio to rbc: ');
sigmas./rbc