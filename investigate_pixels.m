%investigate_pixels

fig = figure('units','normalized','outerposition',[0 0 1 1]);
image(RGB);
prompt = 'Type in array with pixel X-values';
x = input(prompt);
prompt = 'Type in array with pixel Y-values';
y = input(prompt);
n = length(x);
a=zeros(n,1000);
c_list = hsv(20);
r = randi([0 20]);
c = c_list(r,:);
for k = 1:length(subtracted_arr)
    for g = 1:n
        a(g, k) = subtracted_arr(y(g),x(g),k);
    end
end
close(fig);
%%
figure(1);
for g = 1:n
    semilogy(1:1000, a(g,:), 'color', c)
    title('Subtracted intensities')
    hold on;
end
%%
% 
gc(n, 1000)=0;
for k = 2:1000
    gc(:, k) = get_correlation(a(:, k), a(:, k-1), 'Min_intensity', 100);
end

%%
figure(2);
hold on;
for g = 1:n
    plot(gc(g,:), 'color', c)
    title('correlation')
end
%%

ac = 1;
b = ones(1,40);
b = b.*(1/40);
yc= zeros(n,1000);
for g =1:n
    yc(g,:) = filter(b, ac, gc(g, :));
end
%%
    
figure(3);
hold on;
for g = 1:n
    plot(yc(g,:), 'color', c)
    title('Running average')
end