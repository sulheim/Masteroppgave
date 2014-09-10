function aligned_image = align_image(fixed, moving, max_iter, max_step_length)
%Align the moving image to the fixed image using intensity based image
%registration
    if nargin > 4;
        error('Too many inputs. Maximum 4 input variables.');
    elseif nargin < 2;
        error('Too few input arguments. You need to specify two images as input arguments')
    end
    
    %Set default value to max_iter
    default_max_iter = 100;
    default_max_step_length = 0.001;
    %giviing max_iter the defualtvalue if it is not given as input
    switch nargin
        case 2
            max_iter = default_max_iter;
            max_step_length = default_max_step_length;
        case 3
            max_step_length = default_max_step_length;
    end
    %make optimizer and metric objects
    metric = registration.metric.MeanSquares();
    optimizer = registration.optimizer.RegularStepGradientDescent();
%     
    optimizer.MaximumIterations = max_iter;
    optimizer.MaximumStepLength = max_step_length;
    
    %perform optimization
    aligned_image = imregister(moving, fixed, 'affine', optimizer, metric, 'DisplayOptimization', true);
    
end
    
    

