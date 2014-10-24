%run mirt2D_register
%%
%Load image and ref_image
file = load('C:\Users\Snorre\Documents\masteroppgave\Masteroppgave\mat_data\2014-04-28-10-21-25.mat');
im = file.matfile(:,:,100);
refim= file.matfile(:,:,1);
%%
 % Main settings
main.similarity='SSD';  % similarity measure, e.g. SSD, CC, SAD, RC, CD2, MS, MI 
main.subdivide=3;       % use 3 hierarchical levels
main.okno=5;            % mesh window size
main.lambda = 0.05;    % transformation regularization weight, 0 for none
main.single=1;          % show mesh transformation at every iteration

% Optimization settings
optim.maxsteps = 100;   % maximum number of iterations at each hierarchical level
optim.fundif = 1e-4;    % tolerance (stopping criterion)
optim.gamma = 1;       % initial optimization step size 
optim.anneal=0.8;       % annealing rate on the optimization step    
 

[res, newim]=mirt2D_register(refim,im, main, optim);

figure,imshow(refim); title('Reference (fixed) image');
figure,imshow(im);    title('Source (float) image');
figure,imshow(newim); title('Registered (deformed) image');