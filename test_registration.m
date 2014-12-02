%test_optimization
function [reg_im_array, matfile, similarity_before, similarity_after] = test_registration(method, origin)
    switch origin
        case 'RF'
            base = 'D:\Phase shift project\Ultrasound image data\';
            file = '2014-04-28-10-21-25.iq';
            fnameBase = [base, file];
            %%
            [~, ~, ext] = fileparts(fnameBase);
            frame_indexes = 1:10;
            dim = length(frame_indexes);
            matfile = zeros(512, 512, length(frame_indexes));
            k = 1;
            %%
            for i = frame_indexes
                switch ext
                   case '.rf'
                       [tmp_RF, ~] = ReadRF(fnameBase, '.bmode', i); 
                   case '.iq'
                       tmp_RF = get_RF_from_IQ(fnameBase, i);
                end
                matfile(:,:,k) = imresize(log_compress(tmp_RF), [512, 512], 'bilinear');

                k = k+1;
            end
        case 'mat'
            %TEMPORARLY
            %LASSSST IN MATFILE
            tmp = load('C:\Users\Snorre\Documents\masteroppgave\Masteroppgave\mat_data\2014-04-28-10-21-25.mat');
            fullfile = tmp.matfile;
            matfile = fullfile(:,:,1:5:100);
            dim = length(matfile);
    end
    matfile = mat2gray(matfile);
    %Make array for storing similarity measures. mse, ssd, cc, CD2
    similarity_label = {'mse', 'ssd', 'cc', 'CD2'};
    similarity_before = zeros(dim, 4);
    similarity_after = zeros(dim, 4);
    
    %Make ref frame
    tmp = mat2gray(fullfile(:,:,1:3));
    ref_frame = sum(tmp, 3)/3;
    %%
    %Filtering?
    %%
    %choose method and perform optimization
    switch method
        case 'demon'
            [reg_im_array, similarity_before, similarity_after] = run_demon(ref_frame, matfile, similarity_before, similarity_after);
        case 'thin plate spline'
            %NOT WORKING
            error('Thin plate spline is not working')
            optimize_matitk(method, ref_frame, matfile)
        case 'FAIR'
            error('Will look at it')
    end

        
    %Plot similarity
    x = 1:dim;
    length(x)
    length(similarity_before(:,1))
    length(similarity_after(:,1))
    figure(1);
    subplot(2,2,1), plot(x,similarity_before(:,1), x, similarity_after(:,1)); title(similarity_label{1}); legend('Before registration', 'After registration');
    subplot(2,2,2), plot(x,similarity_before(:,2), x, similarity_after(:,2)); title(similarity_label{2}); legend('Before registration', 'After registration');
    subplot(2,2,3), plot(x,similarity_before(:,3), x, similarity_after(:,3)); title(similarity_label{3}); legend('Before registration', 'After registration');
    subplot(2,2,4), plot(x,similarity_before(:,4), x, similarity_after(:,4)); title(similarity_label{4}); legend('Before registration', 'After registration');
    
    figure(2); imshow(reg_im_array(:,:,end))
    figure(3); imshowpair(reg_im_array(:,:,end), ref_frame, 'montage')
end

%     %
%     Istatic = matfile(:,:,1);
%     Imoving = matfile(:,:,2);
% 
%     imshowpair(Istatic, Imoving, 'Colorchannels', 'red-cyan');
%     [Ireg,Bx,By,Fx,Fy] = register_images(Imoving,Istatic, struct('Similarity', 'p','Registration', 'NonRigid'));
%     %%
%     figure,
%     subplot(2,2,1), imshow(Imoving); title('moving image');
%     subplot(2,2,2), imshow(Istatic); title('static image');
%     subplot(2,2,3), imshow(Ireg); title('registerd moving image');
%     % Show also the static image transformed to the moving image
%     Ireg2=movepixels(Istatic,Fx,Fy);
%     subplot(2,2,4), imshow(Ireg2); title('registerd static image');
% 

    

