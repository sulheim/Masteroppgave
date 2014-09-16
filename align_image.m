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
    default_max_step_length = 0.01;
    %giviing max_iter the defualtvalue if it is not given as input
    switch nargin
        case 2
            max_iter = default_max_iter;
            max_step_length = default_max_step_length;
        case 3
            max_step_length = default_max_step_length;
    end
    %%
    %Resize
%     fixed = imresize(fixed, [512, 512], 'bicubic');
%     moving = imresize(moving, [512, 512], 'bicubic');
    %make optimizer and metric objects
    metric = registration.metric.MeanSquares();
    optimizer = registration.optimizer.RegularStepGradientDescent();
%     
    optimizer.MaximumIterations = max_iter;
    optimizer.MaximumStepLength = max_step_length;
    optimizer.MinimumStepLength = 1e-4;
    %Plotting is commented out
%     initial_mse = mse(fixed, moving);
%     sprintf('Initial ms is: %d', initial_mse)
%     %perform optimization
%     figure; imshowpair(fixed, moving, 'ColorChannels','red-cyan')
%     title('Difference before fix')
    [evalc_output, aligned_image]  = evalc('imregister(moving, fixed, ''affine'', optimizer, metric, ''DisplayOptimization'', true)');
%     figure; imshowpair(fixed, aligned_image, 'ColorChannels','red-cyan')
%     title('difference after fix')
%     final_mse = mse(fixed, aligned_image);
%     sprintf('Final ms is: %d', final_mse)
    %Fix evalcvalues
    optimization_data = evalc2decimal(evalc_output);
end
    
    

