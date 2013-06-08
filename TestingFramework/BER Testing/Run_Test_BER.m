function [dec_data] = Run_Test_BER(m,t,Corrupted_Data)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  System Parameters  %%%%%%%%%%%%%%%%%%%%
p = 2;   % Base Prime
n = (p^m)-1; % Codeblock Size
k = n - (2*t); % Message Width
AddPath;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Test Data Retrieval %%%%%%%%%%%%%%%%%%
Test_count = size(Corrupted_Data,2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Iterative Testing  %%%%%%%%%%%%%%%%%%%%
tStart = tic;
dec_data = gf(zeros(n,Test_count),m);
parfor Test_Num=1:Test_count,
    fprintf('\rTest : %d \r',Test_Num);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Algorithm Calls   %%%%%%%%%%%%%%%%%%%%
    [List_Sudan, ~] = Sudan(Corrupted_Data(:,Test_Num),m,k);
    if (~isempty(List_Sudan)),
        dec_data(:,Test_Num) = List_Sudan;
    end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Data Charactistics  %%%%%%%%%%%%%%%%%% 
end;
fprintf('Total Time : %d s\r\n',toc(tStart));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
        
