function [ c_kj_new ] = assign_c_kj(comb,l,m,d)
%ASSIGN_C_KJ Summary of this function goes here
%   Detailed explanation goes here
coeff_vector = de2bi(comb)'; %% Column vector of comb in binary
limit = zeros(l+1,1);
c_kj_new = gf(zeros(m+l*d+1,l+1),m);
for j=0:l,
    limit(j+1) = m+(l-j)*d+1;
end;
coeff_vector = padarray(coeff_vector,[0 sum(limit)],'post'); %% append with zeros so large enough to be broken down
c_kj_new(:,1) = gf(coeff_vector(1:limit(1)),m); %% Same width as matrix
for i=2:l+1,
    selection = coeff_vector(sum(limit(1:i-1))+1:sum(limit(1:i)))';
    padamount = size(c_kj_new,1) - size(selection,1);
    c_kj_new(:,i) = padarray(selection,[padamount 0],'post'); %% pad to correct width
end
end
