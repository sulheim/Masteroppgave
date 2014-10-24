%test FAIR
%Use FAIR image registration to do image registratioen.  Referance: http://www.siam.org/books/fa06/
%%
clear all;
close all;
%%
viewOptn = {'viewImage','viewImage2D','colormap','gray(256)'};
viewImage('reset',viewOptn{:});
%%
%Load in testdata
file = load('testdata100-10-21-25.mat');
ref_im = double(im2uint8(mat2gray(file.matfile(:,:,1))));
im = double(im2uint8(mat2gray(file.matfile(:,:,80))));
%%
%get multilevel

%%
%Initialize interpolation scheme and coefficients
inter('set', 'inter', 'splineInter');%Choose spline interpolation
level = 4;%level of coarseness in optimization scheme
m = [128, 128];%[512 512]; %Number of cells at this level. Should be [32 32]
omega = [0, m(1), 0, m(2)]; %Domain of image. Maybe just[0, 1, 0, 1]?
Tm = imresize(im, m);
Rm = imresize(ref_im, m);
[T, R] = inter('coefficients', Tm, Rm, omega);
xc = getCellCenteredGrid(omega, m);%Get coordinates for all cell centers
Rc = inter(R, omega, xc);
%%
%Initialize distance measure
distance('set', 'distance', 'SSD');
%Initialize transformation and a starting guess
trafo('reset', 'trafo', 'affine2D');
w0 = trafo('w0'); %Starting gues for wc

%%
%set upplots an initialize
FAIRplots('reset','mode','PIR-Gauss-Newton','omega',omega,'m',m,'fig',1,'plots',1);
%%
FAIRplots('init',struct('Tc',T,'Rc',R,'omega',omega,'m',m)); 
%%

% build objective function
% note: T  is template image
%       Rc is sampled reference
%       optional Tikhonov-regularization is disabled by setting m = [], wRef = []
%       beta = 0 disables regularization of Hessian approximation
beta = 0; M = []; wRef = [];
fctn = @(wc) PIRobjFctn(T,Rc,omega,m,beta,M,wRef,xc,wc); 
fctn([]);   % report status

% -- solve the optimization problem -------------------------------------------
[wc,his] = GaussNewton(fctn,w0,'Plots',@FAIRplots,'solver',[],'maxIter',100);
his.str{1} = sprintf('Iteration history: distance = %s, y = %s', distance, trafo);
plotIterationHistory(his,'J',[1,2,3,4,5],'fig',20+level); 


