% review3.m
fax = 10.^[5:0.01:7.8];
a = [0.5 1.5 4].*1e-4; % 3 micron diameter.
[se1,ss1,fr]=ellerfnr(a(1),fax);
sa1 = se1-ss1;
[se3,ss3,fr3]=ellerfnr(a(2),fax);
sa3 = se3-ss3;
[se8,ss8,fr8]=ellerfnr(a(3),fax);
sa8 = se8-ss8;
figure(1);
loglog(fax,ss1,'r',fax,ss3,'g',fax,ss8,'b');
axis([5e5 15e6 1e-10 1e-4]);
h = gca;
set(h,'linewidth',2);
hc = get(h,'children');
legend( [num2str(2e4*a(1)),'\mu m'],[num2str(2e4*a(2)),'\mu m'],[num2str(2e4*a(3)),'\mu m'])
if length(hc)>=1,
 for j=1:length(hc),
 set(hc(j),'linewidth',2);
 end;
end;
xlabel('frequency (Hz)');
ylabel('Scattering cross section (cm2)');
title('1, 3 and 8 micron air bubble in plasma');
figure(2);
loglog(fax,se3,'r',fax,ss3,'g',fax,sa3,'b');
axis([5e5 15e6 1e-10 1e-4]);
h = gca;