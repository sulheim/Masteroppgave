function intensity = random_intensity(intensity_dist)
%Draw a random intensity from an intensity distribution
%using the rejection method with f(x) = 1/length(intensity_dist);
%Rejection method is described in
%http://web.phys.ntnu.no/~ingves/Teaching/TFY4235/Download/TFY4235_Slides_2014.pdf
%or \cite{Simonsen2014}
    l = length(intensity_dist);
    f = 1/l;%This should be a function which is larger than p(x) for all x
    %F =x/l;%Cumulative function
    F_inv =@(y)l*y;
    reject = true;
    while reject
        r1 = rand();%Draw a randoum number from the Uniform distribution
        x0 = F_inv(r1); 
        r2 = rand()*f; %random number from uniform distribution [0, f(x)];
        if r2<p(x)
            reject = false;
        else
            reject = true;
        end
    end
    intensity = x0;
end

