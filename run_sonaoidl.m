%run sonazoidl
close all;
% radius = [20 30 40];
radius = 0.5*[20 30 40]*1e-4;
frq = 10.^(4:0.001:9);
sigmas = zeros(3, length(frq));
sigmae = zeros(3, length(frq));
f0 =  zeros(3, length(frq));
%%
for r = 1:length(radius)
    for f = 1:length(frq)
%        [sigmae(r,f), sigmas(r, f), f0(r,f)] = sonazoidl(radius(r), frq(f));
       [sigmae(r,f), sigmas(r, f), f0(r,f)] = ellerfnr(radius(r), frq(f));
    end
end
%%
%plot
figure('color', 'w')
loglog(frq, sigmas(1,:), 'r', 'linewidth', 2)
hold on;
loglog(frq, sigmas(2, :), 'g','linewidth', 2)
loglog(frq, sigmas(3, :), 'b','linewidth', 2)
axis([5e4 1e8 1e-8 1e-2]);
legend([num2str(2e4*radius(1)),' \mum'],[num2str(2e4*radius(2)),' \mum'],[num2str(2e4*radius(3)),' \mum'])
title('20, 30, and 40 micron air bubbles in plasma')
xlabel('frequency(Hz)')
ylabel('Scattering cross section(cm^2)')
saveas(1, 'C:\Users\Snorre\Documents\masteroppgave\Masteroppgave\figurer\large_bubbles_cross_section', 'png');
% %%
% figure('color', 'w')
% loglog(frq, sigmae(1,:), 'r')
% hold on;
% loglog(frq, sigmae(2, :), 'g')
% loglog(frq, sigmae(3, :), 'b')
% axis([0.5e6 1.5e7 1e-10 1e-4])
% legend('20 \mu m','40 \mu m','40 \mu m') 
% title('20, 30, and 40 micron air bubbles in plasma')
% xlabel('frequency(Hz)')
% ylabel('Scattering cross section(cm^2)')
% saveas(2, 'C:\Users\Snorre\Documents\masteroppgave\Masteroppgave\figurer\large_bubbles_cross_section', 'png');
