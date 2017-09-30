function [ output_array ] = gaussian_filter( input_array, sigma_x, sigma_y )
% compute 2D gaussian filter without NaNs

if nargin == 2
    sigma_y = sigma_x;
end

[nrow, ncol] = size(input_array);
output_array = NaN(nrow, ncol);
ind_nan = isnan(input_array);


% weight array computation
[nc, nr] = meshgrid(1:ncol, 1:nrow);
d2x = (nc - 1).^2;
d2y = (nr - 1).^2;
d2 = d2x/(sigma_x^2) + d2y/(sigma_y^2);
w22 = 1./exp(d2/2);  
w21 = fliplr(w22(:, 2:end));
w12 = flipud(w22(2:end, :));
w11 = rot90(w22(2:end, 2:end),2);
w_big = [w11 w12; w21 w22];

for r = 1:nrow
    r_min = nrow - r + 1;
    r_max = r_min + nrow - 1;
    for c = 1:ncol        
        c_min = ncol - c + 1;
        c_max = c_min + ncol - 1;
        w = w_big(r_min:r_max, c_min:c_max);     
        w(ind_nan) = 0;        
        m = w.*input_array;
        m(ind_nan) = 0;
        output_array(r, c) = sum(m(:))/sum(w(:));
    end
end

end