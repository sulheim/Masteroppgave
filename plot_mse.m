function  plot_mse(filename)
%Plot mse before and after correction and save
    l = load(['C:\Users\Snorre\Documents\masteroppgave\Masteroppgave\corrected_data\', filename, '.mat']);
    figure;
    x = 1:numel(l.corrected_data.mse_before);
    plot(x, l.corrected_data.mse_before,'--', x, l.corrected_data.mse_after, 'r-');
    xlabel('Frame number');
    ylabel('Mean square error');
    title(['Comparison of MSE before and after motion correction. ',filename]);
    legend('Before correction', 'After correction');
    saveas(gcf, ['C:\Users\Snorre\Documents\masteroppgave\Masteroppgave\mse_plots\','MSE_plot_', filename, '.jpg'])
    close(gcf);   
end

