function [] = Image_Encoder(m,t,filename)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  System Parameters  %%%%%%%%%%%%%%%%%%%%
p = 2;   % Base Prime
n = (p^m)-1; % Codeblock Size
k = n - (2*t); % Message Width
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  System Sections  %%%%%%%%%%%%%%%%%%%%%
X = gf(2,m);
x_col = X.^(0:n-1)';
x_mat = gf(ones(n,1),m);
for i=1:k-1,
	x_mat = [x_mat x_col.^i];
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Data Generation  %%%%%%%%%%%%%%%%%%%%%
data = imread(filename);
dimensions = size(data);
data_stream = reshape(data,1,[]);
data_stream_lower = mod(data_stream,(n+1));
data_stream_upper = floor(data_stream/(n+1));
data_stream_concat= [data_stream_lower data_stream_upper];
Test_Num =ceil(size(data_stream_concat,2)/k);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Data Encoding     %%%%%%%%%%%%%%%%%%%%%
enc_data = gf(zeros(n,Test_Num),m);
for i=0:ceil(Test_Num/k)-1,
		for j=1:k,
    	enc_data(:,i+1) = enc_data(:,i+1) + data_stream_concat(k*i+j)*x_mat(:,j); 
		end;  
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Error Generation  %%%%%%%%%%%%%%%%%%%%
error_count = randi([0 2*t],[1 Test_Num]);
error_location = randi([1 n],[t  Test_Num]);
error_value = randi([1 n],[t Test_Num]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Data Export  %%%%%%%%%%%%%%%%%%%%%%%%%
file_split=regexp(filename,'\x2E','split'); %%Split by "."
extension = file_split(2);
file_split=regexprep(file_split(1),'\x20','_');
directory = strcat(sprintf('./Data_m_%d_t_%d_',m,t),file_split);
directory = directory{1}; %cell to string
if ~exist(directory, 'dir')
  mkdir(directory);
end
dlmwrite(sprintf('%s/Encoded_Data.txt',directory),enc_data.x);
dlmwrite(sprintf('%s/Error_Count.txt',directory), error_count);
dlmwrite(sprintf('%s/Error_Location.txt',directory), error_location);
dlmwrite(sprintf('%s/Error_Value.txt',directory), error_value);
dlmwrite(sprintf('%s/Dimensions.txt',directory),dimensions);
imwrite(data,strcat(sprintf('%s/',directory),file_split{1},'_original','.',extension{1}),extension{1});
end
