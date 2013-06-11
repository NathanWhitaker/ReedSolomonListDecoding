function [ Difference_Per ] = Imdiff(filename,m,encoded_k,t,errors)
file_split=regexp(filename,'\/','split');
filename = file_split{size(file_split,2)};
file_split=regexp(filename,'\x2E','split'); %%Split by "."
extension = file_split{2};
file_split=regexprep(file_split(1),'\x20','_');
file_split = file_split{1};
directory = strcat(sprintf('Data/Data_m_%d_k_%d_t_%d_',m,encoded_k,t),file_split);
original_name = strcat(directory,'/',file_split,'_original.',extension);
Original = imread(original_name);
Sudan_Percentages = [];
Std_Percentages = [];
Difference_Per = [];
count = prod(size(Original));
for i=1:errors,
	Test_Sudan_Name = strcat(directory,'/',file_split,'_reconstucted_',sprintf('%d',i),'_errors.',extension)
	Sudan_Image = imread(Test_Sudan_Name);
	Sudan_Differences = sum(sum(sum((Original-Sudan_Image) ~= 0)));
	Sudan_Percentages = [Sudan_Percentages Sudan_Differences*100/count];
	
	Test_Std_Name = strcat(directory,'/',file_split,'_reconstucted_std_',sprintf('%d',i),'_errors.',extension)
	Std_Image = imread(Test_Std_Name);
	Std_Differences = sum(sum(sum((Original-Std_Image) ~= 0)));
	Std_Percentages = [Std_Percentages Std_Differences*100/count];
end;
Difference_Per = [Sudan_Percentages; Std_Percentages]';
end

