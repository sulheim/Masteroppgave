function total_frames = frame_counter(fnameBase)
%frame_counter get the total number of frames in a bmode-file. data_type is
%iq or rf 
    %%
    data_type = strsplit(fnameBase, '.');
    data_types = {'iq', 'rf'};
    if ~ismember(data_type{2}, data_types)
        error('Data type has to be either rf or iq');
    end
    
    fname = [fnameBase, '.bmode'];
    fnameXml = [fnameBase, '.xml'];
    ModeName = '.bmode';
    %%
    switch data_type{2}
        case 'iq'
            param = VsiParseXml(fnameXml,ModeName);
        case 'rf'
            param = VsiParseRFXml(fnameXml, ModeName);
    end
    %%
    % Parse the XML parameter file - DO NOT CHANGE

    BmodeNumFocalZones = param.BmodeNumFocalZones;
    BmodeNumSamples = param.BmodeNumSamples; 
    BmodeNumLines = param.BmodeNumLines; 

    %%
    % This is to strip the header data in the files - DO NOT CHANGE
    size = 2; % bytes
    file_header = 40; % bytes
    line_header = 4; % bytes
    frame_header = 56; % bytes  
    Nlines = BmodeNumFocalZones*BmodeNumLines;
    %%
    frame_header_length = frame_header + Nlines*line_header;
    frame_data_length = 2*size*BmodeNumSamples*Nlines;
    frame_length = frame_data_length + frame_header_length;
    
    %%
    %read in file and get total number of bytes in file
    fid = fopen(fname, 'r');
    fseek(fid, 0, 1);
    number_of_bytes = ftell(fid);
    %%
    %Convert number of bytes to number of frames
    total_frames = (number_of_bytes - file_header)/frame_length;
    total_frames = round(total_frames);
end

