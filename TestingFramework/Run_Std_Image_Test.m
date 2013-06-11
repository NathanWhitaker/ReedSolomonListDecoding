function [dec_data] = Run_Std_Image_Test(m,t,encoded_k,Corrupted_Data)
%function [ bench_data,Bench_Result,enc_data, actual_error_location] = Run_Test( m,t )
%RUN_TEST Summary of this function goes here
%   Detailed explanation goes here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  System Parameters  %%%%%%%%%%%%%%%%%%%%
p = 2;   % Base Prime
n = (p^m)-1; % Codeblock Size
k = n - (2*t); % Message Width
Std_Dec = comm.RSDecoder('CodewordLength',n,'MessageLength',k);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Iterative Testing  %%%%%%%%%%%%%%%%%%%%
Data = zeros(k,size(Corrupted_Data,2));
for i=1:size(Corrupted_Data,2),
	i
	Data(:,i) = step(Std_Dec,Corrupted_Data(:,i));
end;
dec_data = Data(1:encoded_k,:);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
        
