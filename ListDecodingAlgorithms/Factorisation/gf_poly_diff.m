function [ diff_poly ] = gf_poly_diff( poly,m )
%GF_POLY_DIFF Summary of this function goes here
%   Detailed explanation goes here
diff_poly = gf(zeros(size(poly,1),1),m);
diff_poly(1:size(diff_poly,1)-1,1) = poly(2:size(diff_poly,1),1); %% Shift down, first part of diff
power_diff = mod(1:size(diff_poly,1),2^m);
diff_poly = diff_poly.*power_diff';
end

