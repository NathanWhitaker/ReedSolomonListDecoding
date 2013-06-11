function [Corrected_Image] = Image_Reconstruction(m,t,encoded_k,filename,Corrected_Sudan_Image_Data,Corrected_Std_Image_Data,errors)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  System Parameters  %%%%%%%%%%%%%%%%%%%%
p = 2;   % Base Prime
n = p^m-1;
k = n-(2*t);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  System Sections  %%%%%%%%%%%%%%%%%%%%%
X = gf(2,m);
x_col = X.^(0:n-1)';
x_mat = gf(ones(n,1),m);
for i=1:encoded_k-1,
  x_mat = [x_mat x_col.^i];
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  System Sections  %%%%%%%%%%%%%%%%%%%%%
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
dimensions = dlmread(sprintf('%s/Dimensions.txt',directory));
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
Sudan_Image_Data = gf(zeros(encoded_k,size(Corrected_Sudan_Image_Data,2)),m);

for i=1:size(Corrected_Sudan_Image_Data,2),
	Sudan_Image_Data(:,i) = factor_reference(:,Corrected_Sudan_Image_Data(1,i)+1,Corrected_Sudan_Image_Data(2,i)+1);
end;
Sudan_Image_Data = Sudan_Image_Data.x;
Sudan_Image_Data = uint8(Sudan_Image_Data(1,:) + (n+1)*Sudan_Image_Data(2,:));
Sudan_Image = reshape(Sudan_Image_Data,dimensions);


Std_Image_Data = Corrected_Std_Image_Data;
Std_Image_Data = uint8(Std_Image_Data(1,:) + (n+1)*Std_Image_Data(2,:));
Std_Image = reshape(Std_Image_Data,dimensions);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
imwrite(Sudan_Image,strcat(sprintf('%s/',directory),file_split{1},'_reconstucted_',sprintf('%d',errors),'_errors','.',extension{1}));
imwrite(Std_Image,strcat(sprintf('%s/',directory),file_split{1},'_reconstucted_std_',sprintf('%d',errors),'_errors','.',extension{1}));
end
