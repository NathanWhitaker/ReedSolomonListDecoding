function [dec_data] = Run_MyAlgorithm(m,t,Corrupted_Data,inv_factors,comb,x_mat)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
p = 2;   % Base Prime
n = (p^m)-1; % Codeblock Size
k = n - (2*t); % Message Width
dec_data = gf(zeros(k,size(Corrupted_Data,2)),4);
parfor i=1:size(Corrupted_Data,2),
    fprintf('%d\r\n',i);
    [dec_data(:,i), ~] = MyAlgorithm(m,t,Corrupted_Data(:,i),inv_factors,comb,x_mat);
end;
end

