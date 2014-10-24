function [new_im, similarity, wOpt] = fair_registration(im, ref_im, levels, distance_measure)
%Do image registration using fair algorithm
    %initialize fair
    im = mat2gray(im);
    ref_im = mat2gray(ref_im);
    %%
    %Initialize interpolation scheme and coefficients
    inter('set', 'inter', 'splineInter');%Choose spline interpolation
    viewOptn = {'viewImage','viewImage2D','colormap','gray(256)'};
    viewImage('reset',viewOptn{:});
    %%
    %Initialize distance measure
    distance('set', 'distance', 'SSD');
    %Initialize transformation and a starting guess
    trafo('reset', 'trafo', 'affine2D');
    w0 = trafo('w0'); %Starting gues for wc
    wStop = w0;
    beta = 0; M = []; wRef = [];
    omega = [0, 1, 0, 1];
    %%
  
    for level = levels
        %Initializing for each level
        m = [1, 1]*(2^level);
        Tm = imresize(im, m);
        Rm = imresize(ref_im, m);
        [T, R] = inter('coefficients', Tm, Rm, omega);
        xc = getCellCenteredGrid(omega, m);%Get coordinates for all cell centers
        Rc = inter(R, omega, xc);
        beta = 0; M = []; wRef = [];
        fctn = @(wc) PIRobjFctn(T,Rc,omega,m,beta,M,wRef,xc,wc);
        
        if level == levels(1)
            fctn([]);   % report status
        end
        
        %set upplots an initialize
%         FAIRplots('reset','mode','PIR-Gauss-Newton','omega',omega,'m',m,'fig',1,'plots',1);
        %%
%         FAIRplots('init',struct('Tc',T,'Rc',R,'omega',omega,'m',m)); 
        
        % -- solve the optimization problem -------------------------------------------
        [wOpt,his] = GaussNewton(fctn,w0,'Plots',@FAIRplots,'solver',[],'maxIter',100, 'yStop', wStop, 'Plots', 0);
        his.str{1} = sprintf('Iteration history: distance = %s, y = %s', distance, trafo);
%         plotIterationHistory(his,'J',[1,2,3,4,5],'fig',20+level);  
        w0 = wOpt;       
    end
    new_im = get_fair_result(wOpt, im);
    distance_func = str2func(distance_measure);
    similarity = distance_func(new_im, ref_im);

end

