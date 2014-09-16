%run through all avi files in folder
files = dir('C:\Users\Snorre\Documents\masteroppgave\Masteroppgave\corrected_data\*.mat');
for file = files
   disp(['Working on file ', file.name])
   %%%Plot mse
   l = load(['C:\Users\Snorre\Documents\masteroppgave\Masteroppgave\corrected_data\', file.name]);
   [~,fname, ~] = fileparts(file.name);
   figure; hold on;
   x = 1:numel(l.corrected_data.mse_before);
   plot(x, l.corrected_data.mse_before,'--', x, l.corrected_data.mse_after, ':');
   xlabel('Frame number');
   ylabel('Mean square error');
   title(['Comparison of MSE before and after motion correction. ',fname]);
   legend('Before correction', 'After correction');
   saveas(gcf, ['C:\Users\Snorre\Documents\masteroppgave\Masteroppgave\mse_plots\','MSE_plot_', fname])
   close(gcf);
   
   
end
