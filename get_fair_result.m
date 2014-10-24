function new_im = get_fair_result(wc, T, xc, omega, m)
    %Make registered image from wc values
    if nargin == 2
        omega = [0,1,0,1];
        m = [512, 512];
        xc = getCellCenteredGrid(omega, m);%Get coordinates for all cell centers
        yc = trafo(wc, xc);
        [T, ~] = inter('coefficients', T, T, omega);
        new_im = reshape(inter(T, omega, yc), m);
    else
        yc = trafo(wc, xc);
        new_im = reshape(inter(T, omega, yc), m);
    end
    