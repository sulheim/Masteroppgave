function [RF, param] = get_RF_from_IQ(fnameBase, frame_idx)
%This function converts IQ data to RF data
    [Idata,Qdata,param] = VsiBModeIQ(fnameBase, '.bmode', frame_idx);
    % Setup the Rx frequency
    fs= param.BmodeRxFrequency;
    f_rf = fs; % reconstruct to the original Rx freq in the param file
    if strcmp(param.BmodeQuad2x,'true') 
        fs = fs*2; % actual Rx freq is double because of Quad 2x
        IntFac = 8;
    else
        IntFac = 16;
    end
    fs_int = fs*IntFac;

    %IntFac is a factor applied to enlarge the size of image for interpolation
    %of IQ data. Number of datapoints in lateral direction is the same, but the
    %number of datapoints in axial direction is multiplied by a factor IntFac

    % Initialize
    IdataInt = zeros(param.BmodeNumSamples*IntFac, param.BmodeNumLines);
    QdataInt = zeros(param.BmodeNumSamples*IntFac, param.BmodeNumLines);
    RfData = zeros(param.BmodeNumSamples*IntFac, param.BmodeNumLines);
    t = [0:1/fs_int:((param.BmodeNumSamples*IntFac)-1)/fs_int];

    % Interpolate I/Q and reconstruct RF
    for i=1:param.BmodeNumLines
        IdataInt(:,i) = interp(Idata(:,i), IntFac);
        QdataInt(:,i) = interp(Qdata(:,i), IntFac);
        % phase term in complex exponential modified for rev. 1.1
        RfData(:,i) = real(complex(IdataInt(:,i), QdataInt(:,i)).*exp(sqrt(-1)*(2*pi*f_rf*t')));
    end

    if strcmp(param.BmodeQuad2x,'true')
        RfData= -RfData;  
    end

    RF = RfData;
end

