function RGB = mat2RGB(mat, varargin)
    convert_const = 350;
    to_uint8 = true;
    for k=1:2:length(varargin), % overwrite default parameter
        eval([varargin{k},'=varargin{',int2str(k+1),'};']);
    end;
    
    if to_uint8
        mat = mat./max(mat(:)).*convert_const;
        mat(mat>255)=255;
        mat = uint8(mat);
    end
    
    RGB(:,:,1) = mat;
    RGB(:,:,2) = mat;
    RGB(:,:,3) = mat;
end