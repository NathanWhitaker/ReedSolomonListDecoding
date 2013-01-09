function [] = Test_Generation( m,t,Number_of_Tests )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  System Parameters  %%%%%%%%%%%%%%%%%%%%
p = 2;   % Base Prime
n = (p^m)-1; % Codeblock Size
k = n - (2*t); % Message Width
Test_Num = Number_of_Tests;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  System Sections  %%%%%%%%%%%%%%%%%%%%%
hEnc = comm.RSEncoder(n,k); % Create Encoder
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Data Generation  %%%%%%%%%%%%%%%%%%%%%
data = randi([0 n-1], k,Test_Num); % Generate Message Data
enc_data = zeros(n,Test_Num);
for i=1:Test_Num,
    enc_data(:,i) = step(hEnc,data(:,i)); % Encode First Column of Data
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Error Generation  %%%%%%%%%%%%%%%%%%%%
error_count = randi([0 t],[1 Test_Num]);
error_location = randi([1 n],[t  Test_Num]);
error_value = randi([1 n],[t Test_Num]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Data Export  %%%%%%%%%%%%%%%%%%%%%%%%%
directory = sprintf('./Data_m_%d_t_%d',m,t);
if ~exist(directory, 'dir')
  mkdir(directory);
end
dlmwrite(sprintf('%s/Encoded_Data.txt',directory),enc_data);
dlmwrite(sprintf('%s/Error_Count.txt',directory), error_count);
dlmwrite(sprintf('%s/Error_Location.txt',directory), error_location);
dlmwrite(sprintf('%s/Error_Value.txt',directory), error_value);
end

