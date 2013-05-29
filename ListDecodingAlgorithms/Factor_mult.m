function [ res_factor ] = Factor_mult(factor_1,factor_2,m)
%FACTOR_MULT Summary of this function goes here
%   Detailed explanation goes here
% The factorisation of the polynomial is achieved through the use of the 
% factorisation function that is contained within MuPad. This is used by
% passing the polynomial as a string to this function which is used inline
% and the result is then parsed to retrieve the factors found

res_factor = gf(zeros(size(factor_1,1),size(factor_1,2)),m);

for i=1:size(factor_2),
	if(factor_2(i) ~= 0),
		extra_factor = circshift(factor_1,i-1);
		extra_factor(1:i-1) = 0;
		res_factor = res_factor.x + factor_2(i)*gf(extra_factor,m);
	end;
end;

end
