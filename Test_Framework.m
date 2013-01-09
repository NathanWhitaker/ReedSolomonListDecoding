%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  System Parameters  %%%%%%%%%%%%%%%%%%%%
close all; clear all;
p = 2;   % Base Prime
m = 8;   % Symbol Bit Width
t = 8;  % Half Parity Count
n = (p^m)-1; % Codeblock Size
k = n - (2*t); % Message Width
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  System Sections  %%%%%%%%%%%%%%%%%%%%%
tStart = tic;
tic
hEnc = comm.RSEncoder(n,k); % Create Encoder
fprintf('\r');
fprintf('Framework Initialisation : %d s\r',toc);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Data Generation  %%%%%%%%%%%%%%%%%%%%%
tic
data = randi([0 n-1], k,1); % Generate Message Data
enc_data = step(hEnc,data); % Encode Data
fprintf('Framework Data Generation : %d s\r',toc);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Error Generation  %%%%%%%%%%%%%%%%%%%%
tic
error_count = randi([0 t],1);
actual_error_location = randi([1 n],[error_count 1]);
error_value = randi([1 n],[error_count 1]);
corrupted_data = enc_data;
for i=1:error_count,
    corrupted_data(actual_error_location(i)) = error_value(i);
end;
corrupted_data_gf = gf(corrupted_data,m);
clear data hEnc hChan hDec
fprintf('Framework Error Generation : %d s\r',toc);
fprintf('Framework Initialisation Time : %d s\r',toc(tStart));
fprintf('\r');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Algorithm Calls   %%%%%%%%%%%%%%%%%%%%
bench_data = Benchmark(corrupted_data_gf,p,m,t,n,k);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Data Charactistics  %%%%%%%%%%%%%%%%%% 
fprintf('Actual Error Locations : %g \r',actual_error_location);
fprintf('\r');



B_A_D = sum(abs(enc_data - bench_data)'); % Non-zero difference in decoding
fprintf('Bench Absolute Difference Sum : %d\r',B_A_D);
fprintf('Total Time : %d s\r',toc(tStart));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
