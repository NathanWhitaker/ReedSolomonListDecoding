function [ c_kj_new ] = assign_c_kj(comb,l,m,d,n,k)
%ASSIGN_C_KJ Summary of this function goes here
%   Detailed explanation goes here
D = double(ceil(sqrt(2*k*n)));
y_limit = double(floor(D/k));
limits = zeros(y_limit+1,1);
c_kj_new = gf(zeros(D+1,y_limit + 1),m);
for j=0:y_limit,
    limits(j+1) = double(floor(D-k*j));
end;

cum_limits = [1 ; cumsum(limits)]; %% 1 Required for first interation 
coeff_vector = padarray(de2bi(comb)',[cum_limits(y_limit+1)+2 - size(de2bi(comb),1) 0],'post');%% Column vector of comb in binary

for i=1:y_limit+1,
    selection = coeff_vector(cum_limits(i):cum_limits(i+1))';
    padamount = size(c_kj_new,1) - size(selection,2);
    c_kj_new(:,i) = padarray(selection,[0 padamount],'post'); %% pad to correct width
end

%% Calculation of Limits
%This gives the maximum values that i is able to achieve with different j values
%This enables the input value to be split into the appropriate powers of X

%% Padding of input vector
%This allows for the vector to be addressed completly without concern for
%overflowing index

%% For loop operation
%Select the appropriate part of the input binary number, this is then
%padded such that it fits the matrix specification. This is then placed
%into the coefficient matrix

%% Previous Algorithm
%for j=0:l,
%    limit(j+1) = m+(l-j)*d+1;
%end;
%coeff_vector = padarray(coeff_vector,[0 sum(limit)],'post'); %% append with zeros so large enough to be broken down
%c_kj_new(:,1) = gf(coeff_vector(1:limit(1)),m); %% Same width as matrix
%for i=2:l+1,
%    selection = coeff_vector(sum(limit(1:i-1))+1:sum(limit(1:i)))';
%    padamount = size(c_kj_new,1) - size(selection,1);
%    c_kj_new(:,i) = padarray(selection,[padamount 0],'post'); %% pad to correct width
%end
end
