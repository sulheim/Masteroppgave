function [aligned_image, optimization_data] = align_image(fixed, moving, max_iter, max_step_length)
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
    
    initial_rms = rms(rms(fixed -moving));
    sprintf('Initial rms is: %d', initial_rms)
    initial_ms = mean(mean((fixed-moving).^2));
    sprintf('Initial ms is: %d', initial_ms)
    %perform optimization
    [evalc_output, aligned_image]  = evalc('imregister(moving, fixed, ''affine'', optimizer, metric, ''DisplayOptimization'', true)');
    final_rms = rms(rms(imsubtract(fixed, aligned_image)));
    sprintf('Final rms is: %d', final_rms)
    final_ms = mean(mean(fixed-aligned_image).^2);
    sprintf('Final ms is: %d', final_ms)
    %Fix evalcvalues
    optimization_data = evalc2decimal(evalc_output);
    sprintf(evalc_output)
end
    
    

