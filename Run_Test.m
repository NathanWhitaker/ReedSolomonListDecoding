function [bench_data] = Run_Test(m,t,choice)
%function [ bench_data,Bench_Result,enc_data, actual_error_location] = Run_Test( m,t )
%RUN_TEST Summary of this function goes here
%   Detailed explanation goes here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  System Parameters  %%%%%%%%%%%%%%%%%%%%
p = 2;   % Base Prime
n = (p^m)-1; % Codeblock Size
k = n - (2*t); % Message Width
AddPath;
%matlabpool('open','AttachedFiles','Run_Test.m')
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
for Test_Num=1:Test_count,
    for i=1:error_count(Test_Num),
        corrupted_data(actual_error_location(i,Test_Num),Test_Num) = error_value(i,Test_Num);
    end;
end;
for Test_Num=1:1,
    corrupted_data_gf = gf(corrupted_data(:,Test_Num),m);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Algorithm Calls   %%%%%%%%%%%%%%%%%%%%
    fprintf('\rTest : %d \r',Test_Num);
    Bench_Data(:,Test_Num) = double(Benchmark(corrupted_data_gf,m,t,n));
    List_Sudan             = Sudan(corrupted_data_gf,m,k,choice);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Data Charactistics  %%%%%%%%%%%%%%%%%% 
    Bench_Result(Test_Num) = sum(abs(enc_data(:,Test_Num) - bench_data(:,Test_Num))'); % Non-zero difference in decoding
%     if (Bench_Result(Test_Num) ~= 0),
%         fprintf('Test %d FAILED \r',Test_Num);
%     else
%         fprintf('Test %d SUCCESSFUL \r',Test_Num);
%     end;
end;
fprintf('Benchmark Result : ');
Bench_Data
%fprintf('Sudan Result : ');
%List_Sudan
% failure_count = 0
% for Test_Num=1:Test_count,
%     if (Bench_Result(Test_Num) ~= 0),
%         fprintf('Test %d failed \r',Test_Num);
%         failure_count = failure_count + 1;
%     end;
% end;
% fprintf('Number of Failed Tests : %d\r',failure_count);
% fprintf('Number of Passed Tests : %d\r',(Test_count-failure_count));
fprintf('Total Time : %d s\r\n',toc(tStart));
%matlabpool close
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


end

