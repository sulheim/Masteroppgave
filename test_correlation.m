%x, y, a
a=zeros(4,1000);
% y = [319 319 319 293];
% x = [283 284 285 270];
% x = randi([230,315], [1,4]);
% y = randi([233, 403], [1,4]);
x = [226 270 223 307];
y = [389 292 344 336];
color = {'g--', 'k--', 'r-', 'b*'};

for k = 1:1000
    for g = 1:4
        a(g, k) = subtracted_arr(y(g),x(g),k);
    end
end
%%
figure(1);
for g = 1:4
    semilogy(1:1000, a(g,:), color{g})
    title('Subtracted intensities')
    hold on;
end
%%
% 
gc(4, 1000)=0;
for k = 2:1000
    gc(:, k) = get_correlation(a(:, k), a(:, k-1), 'Min_intensity', 100);
end

%%
figure(2);
hold on;
for g = 1:4
    plot(gc(g,:), color{g})
    title('correlation')
end
%%

ac = 1;
b = ones(1,40);
b = b.*(1/40);
yc= zeros(4,1000);
for g =1:4
    yc(g,:) = filter(b, ac, gc(g, :));
end
%%
    
figure(3);
hold on;
for g = 1:4
    plot(yc(g,:), color{g})
    title('Running average')
end