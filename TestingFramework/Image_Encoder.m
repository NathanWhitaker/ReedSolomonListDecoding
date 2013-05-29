function [Corrupted_Data] = Image_Encoder(m,encoded_k,t,filename,error_count,decode_count)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  System Parameters  %%%%%%%%%%%%%%%%%%%%
p = 2;   % Base Prime
n = (p^m)-1; % Codeblock Size
k = n-(2*t);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  System Sections  %%%%%%%%%%%%%%%%%%%%%
X = gf(2,m);
x_col = X.^(0:n-1)';
x_mat = gf(ones(n,1),m);
for i=1:encoded_k-1,
	x_mat = [x_mat x_col.^i];
end;
clear X x_col i
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Data Generation  %%%%%%%%%%%%%%%%%%%%%
factor_reference = gf(zeros(encoded_k,n+1,n+1),m);
for i=0:n,
    for j=0:n,
        factor = gf([j i],m)';
        poly_value = x_mat(1:encoded_k,:) * factor;
        poly_value = poly_value.x;
        factor_reference(:,poly_value(1)+1,poly_value(2)+1) = factor;
    end;
end;
clear factor poly_value 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Data Encoding     %%%%%%%%%%%%%%%%%%%%%
Original_Image = imread(filename);
dimensions = size(Original_Image);
data_stream = reshape(Original_Image,1,[]);
data_stream_lower = min(n,mod(data_stream,(n+1)));
data_stream_upper = max(0,floor(double(data_stream)/(n+1)));
factors = [data_stream_lower;data_stream_upper];
Test_Num =size(data_stream,2);
enc_data = gf(zeros(n,Test_Num),m);
for i=1:Test_Num,
    enc_data(:,i) = x_mat * factors(:,i);
end;
clear x_mat i
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Error Generation  %%%%%%%%%%%%%%%%%%%%
error_location = randi([1 n],[error_count  Test_Num]);
error_value = gf(randi([1 n],[error_count Test_Num]),m);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Data Corruption  %%%%%%%%%%%%%%%%%%%%%
Corrupted_Data = enc_data;
Corrupted_Image_Data = gf(zeros(encoded_k,Test_Num),m);
for i=1:Test_Num,
     for j=1:error_count,
         location = error_location(j,i);
         Corrupted_Data(location,i) = Corrupted_Data(location,i) + error_value(j,i);
     end;
    Corrupt_Index = Corrupted_Data.x;
    Corrupted_Image_Data(:,i) = factor_reference(:,Corrupt_Index(1,i)+1,Corrupt_Index(2,i)+1);
end; 
clear i j Corrupt_Index factor_reference i j error_location error_value
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Corrupted Data Reconstruction %%%%%%%%
Corrupted_Image_Data = Corrupted_Image_Data.x;
Corrupted_Image = Corrupted_Image_Data(1,:) + (n+1)*Corrupted_Image_Data(2,:);
Corrupted_Image = uint8(reshape(Corrupted_Image,dimensions));
clear Corrupted_Image_Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Data Export       %%%%%%%%%%%%%%%%%%%%%
file_split=regexp(filename,'\/','split');
filename = file_split{size(file_split,2)};
file_split=regexp(filename,'\x2E','split'); %%Split by "."
extension = file_split(2);
file_split=regexprep(file_split(1),'\x20','_');
directory = strcat(sprintf('./Data/Data_m_%d_k_%d_t_%d_',m,encoded_k,t),file_split);
directory = directory{1}; %cell to string
if ~exist(directory, 'dir')
  mkdir(directory);
end
imwrite(Original_Image,strcat(sprintf('%s/',directory),file_split{1},'_original','.',extension{1}));
imwrite(Corrupted_Image,strcat(sprintf('%s/',directory),file_split{1},'_corrupted','.',extension{1}));
dlmwrite(sprintf('%s/Corrupted_Data.txt',directory), Corrupted_Data.x);
dlmwrite(sprintf('%s/Dimensions.txt',directory), dimensions);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Split Decode Over Multiple Computers %%
if (decode_count<=1),
    dlmwrite(sprintf('%s/Encoded_Data.txt',directory),enc_data.x);
else
    Sub_Test_Count = ceil(Test_Num/decode_count);
    for i=1:decode_count,
        encode_sub = enc_data(:,(i-1)*Sub_Test_Count+1:min(i*Sub_Test_Count,Test_Num));
        dlmwrite(sprintf('%s/Encoded_Data_%d.txt',directory,i),encode_sub.x);
    end;
end;
        
end
