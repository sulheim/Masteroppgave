%compare manual and auto count
close all;
clear all;
%Load excel sheet(tom D)
excel = 'C:\Users\Snorre\Dropbox\counting sheet.xlsx';%Dropbox folder
%Set row numbers
row_numbers = 21:145;%;16:145;
[num,~,~] = xlsread(excel, 1, ['H', num2str(row_numbers(1)),':L', num2str(row_numbers(end))], 'basic');

%%
new_row_numbers = find(~isnan(num(:,5)));
N_auto = num(new_row_numbers, 1);
n_auto = num(new_row_numbers, 2);
N_man = num(new_row_numbers, 4);
n_man = num(new_row_numbers, 5);
%%
x = 1:16;
%plot bar of N
fig = figure('Color','w'); 
bar(x, [N_auto, N_man], 'grouped')
legend('Automatic counting', 'Manual counting')
xlabel('Animal number')
ylabel('Number of counted bubbles')
title('Counted number of stuck bubbles within ROI')
ax = get(gca); 
cat = ax.Children;
%set the first bar chart style
set(cat(2),'FaceColor','r','BarWidth',2); 
%set the second bar chart style
set(cat(1),'FaceColor','b', 'BarWidth',2);
set(gca,'Xtick', 1:16)
set(gca,'XtickLabel', 1:16)

%%
%Plot n
fig2 = figure('Color','w');
bar(x, [n_auto, n_man], 'grouped')
legend('Automatic counting', 'Manual counting')
xlabel('Animal number')
ylabel('Number desnity of counted bubbles(#/mm^2)')
title('Number density (#/mm^2) of stuck bubbles within ROI')
ax = get(gca); 
cat = ax.Children;
%set the first bar chart style
set(cat(2),'FaceColor','r','BarWidth',2); 
%set the second bar chart style
set(cat(1),'FaceColor','b', 'BarWidth',2);
set(gca,'Xtick', 1:16)
set(gca,'XtickLabel', 1:16)

