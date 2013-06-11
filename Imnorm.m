function [] = Imnorm(m,encoded_k,t,filename,errors)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  System Parameters  %%%%%%%%%%%%%%%%%%%%
p = 2;   % Base Prime
n = (p^m)-1; % Codeblock Size
k = n-(2*t);
Std_Dec = comm.RSDecoder('CodewordLength',n,'MessageLength',k);
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Data Encoding     %%%%%%%%%%%%%%%%%%%%%
file_split=regexp(filename,'\/','split');
filename = file_split{size(file_split,2)};
file_split=regexp(filename,'\x2E','split'); %%Split by "."
extension = file_split{2};
file_split=regexprep(file_split(1),'\x20','_');
file_split = file_split{1};
directory = strcat(sprintf('Data/Data_m_%d_k_%d_t_%d_',m,encoded_k,t),file_split);
dimensions = dlmread(sprintf('%s/Dimensions.txt',directory));
Encoded_name = strcat(directory,'/Encoded_Data.txt');
enc_data = dlmread(Encoded_name);
Test_Num =size(enc_data,2);
for j=1:errors,
	data = dlmread(strcat(directory,'/Corrupted_Data_',sprintf('%d',j),'_errors.txt'));
	difference = sum(sum(sum((enc_data(1:2,:) - data(1:2,:)) ~= 0)))
	Corrected_Image_Data = gf(zeros(encoded_k,Test_Num),m);
	for i=1:Test_Num,
		%%fprintf('Error : %d, Test_Num : %d\r\n',j,i);
		Corrected_Data = step(Std_Dec, data(:,i));
		Corrected_Image_Data(:,i) = factor_reference(:,Corrected_Data(1)+1,Corrected_Data(2)+1);
	end;	
	difference_2 = sum(sum(sum((enc_data(1:2,:) - Corrected_Image_Data(1:2,:)) ~= 0)))
	Corrected_Image_Data = Corrected_Image_Data.x;
	Corrected_Image_Data = uint8(Corrected_Image_Data(1,:) + (n+1)*Corrected_Image_Data(2,:));
	Corrected_Image = uint8(reshape(Corrected_Image_Data,dimensions));
	imwrite(Corrected_Image,strcat(sprintf('%s/',directory),file_split,'_reconstucted_std_',sprintf('%d',j),'_errors','.',extension));
end;
        
end
