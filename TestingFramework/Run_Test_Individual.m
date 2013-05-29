function [Bench_Result] = Run_Test_Individual( m,t,Test_Num )
%function [ bench_data,Bench_Result,enc_data, actual_error_location] = Run_Test( m,t )
%RUN_TEST Summary of this function goes here
%   Detailed explanation goes here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  System Parameters  %%%%%%%%%%%%%%%%%%%%
p = 2;   % Base Prime
n = (p^m)-1; % Codeblock Size
k = n - (2*t); % Message Width
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Test Data Retrieval %%%%%%%%%%%%%%%%%%
directory = sprintf('./Data_m_%d_t_%d',m,t);
enc_data = dlmread(sprintf('%s/Encoded_Data.txt',directory));
error_count = dlmread(sprintf('%s/Error_Count.txt',directory));
actual_error_location = dlmread(sprintf('%s/Error_Location.txt',directory));
error_value = dlmread(sprintf('%s/Error_Value.txt',directory));
Test_count = size(enc_data,2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Iterative Testing  %%%%%%%%%%%%%%%%%%%%
tStart = tic;

Bench_Result = zeros(Test_count,1);
bench_data = zeros(n,Test_count);
corrupted_data = enc_data;
for i=1:error_count,
    corrupted_data(actual_error_location(i,Test_Num),Test_Num) = error_value(i,Test_Num);
end;
corrupted_data_gf = gf(corrupted_data(:,Test_Num),m);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Algorithm Calls   %%%%%%%%%%%%%%%%%%%%
fprintf('\r\rTest : %d \r',Test_Num);
bench_data(:,Test_Num) = double(Benchmark(corrupted_data_gf,p,m,t,n,k));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Data Charactistics  %%%%%%%%%%%%%%%%%% 
Bench_Result(Test_Num) = sum(abs(enc_data(:,Test_Num) - bench_data(:,Test_Num))'); % Non-zero difference in decoding

fprintf('Total Time : %d s\r',toc(tStart));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


end

