function motion_correction(fname, frame_numbers, ref_frame)
%Motion_correction aligns all images to the reference image, to remove
%motion from movies. fname is filename to the RF file.

    if nargin > 3;
        error('Too many inputs. Maximum 3 input variables.');
    elseif nargin < 1;
        error('Too few inputs. Minimium 1 input variable.');
    end
    
    switch nargin
        case 3
            


