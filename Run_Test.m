function [failed_list] = Run_Test(m,t)
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
%for Test_Num=1:Test_count,
%    for i=1:error_count(Test_Num),
%        corrupted_data(actual_error_location(i,Test_Num),Test_Num) = error_value(i,Test_Num);
%    end;
%end;
failed_list = 0;
parfor Test_Num=1024:Test_count,
	tStart_i = tic;
	fprintf('\rTest : %d \r',Test_Num);
    corrupted_data_gf = gf(corrupted_data(:,Test_Num),m);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Algorithm Calls   %%%%%%%%%%%%%%%%%%%%
    Bench_Data = double(corrupted_data_gf.x); %double(Benchmark(corrupted_data_gf,m,t,n));
    List_Sudan = double(Sudan(corrupted_data_gf,m,k));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Data Charactistics  %%%%%%%%%%%%%%%%%% 
	Buffer = zeros(size(Bench_Data,1),1);
	if (size(List_Sudan,2) == 0),
		fprintf('List Empty\r\n');
		Bench_Data
		failed_list = [failed_list Test_Num];
    else
        if(~isequal(List_Sudan,Bench_Data)),
            failed_list = [failed_list Test_Num];
            fprintf('Incorrect Result\r\n');
        end;
		[Bench_Data Buffer List_Sudan List_Sudan-Bench_Data]
	end;
fprintf('Total Time : %d s\r\n',toc(tStart_i));
end;
fprintf('Total Time : %d s\r\n',toc(tStart));
failed_list = failed_list(:,2:size(failed_list,2));
dlmwrite(sprintf('failed.txt'),failed_list');
%matlabpool close
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end     
        
