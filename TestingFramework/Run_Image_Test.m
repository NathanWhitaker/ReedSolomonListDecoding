function [dec_data] = Run_Image_Test(m,t,encoded_k,Corrupted_Data)
%function [ bench_data,Bench_Result,enc_data, actual_error_location] = Run_Test( m,t )
%RUN_TEST Summary of this function goes here
%   Detailed explanation goes here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  System Parameters  %%%%%%%%%%%%%%%%%%%%
p = 2;   % Base Prime
n = (p^m)-1; % Codeblock Size
k = n - (2*t); % Message Width
AddPath;
%matlabpool('open','AttachedFiles','Run_Test.m')
Corrupted_Data_gf = gf(Corrupted_Data,m);
Test_count = size(Corrupted_Data,2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Iterative Testing  %%%%%%%%%%%%%%%%%%%%
tStart = tic;
dec_data = gf(zeros(encoded_k,Test_count),m);
i=0;
parfor Test_Num=1:Test_count,
    tStart_i = tic;
    fprintf('\rTest : %d \r',Test_Num);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Algorithm Calls   %%%%%%%%%%%%%%%%%%%%
    %Bench_Data = double(Corrupted_Data_gf(:,Test_Num)); %double(Benchmark(corrupted_data_gf,m,t,n));
    [List_Sudan, Factor_Sudan] = Sudan(Corrupted_Data_gf(:,Test_Num),m,k);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Data Charactistics  %%%%%%%%%%%%%%%%%% 
    if (size(List_Sudan,2) == 0),
        fprintf('List Empty\r\n');
    else
        try
            dec_data(:,Test_Num) = List_Sudan(1:encoded_k);
        catch
            i = [i Test_Num];
            fprintf('Huh!? \r\n');
        end;
    end;
    fprintf('Test %d Time : %d s\r\n',Test_Num,toc(tStart_i));
end;
dec_data = dec_data.x;
i
fprintf('Total Time : %d s\r\n',toc(tStart));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
        
