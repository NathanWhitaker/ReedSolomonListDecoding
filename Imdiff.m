function [ Difference_Per ] = Imdiff(filename,m,encoded_k,t,errors)
n = 2^m-1;
file_split=regexp(filename,'\/','split');
filename = file_split{size(file_split,2)};
file_split=regexp(filename,'\x2E','split'); %%Split by "."
extension = file_split{2};
file_split=regexprep(file_split(1),'\x20','_');
file_split = file_split{1};
directory = strcat(sprintf('Data/Data_m_%d_k_%d_t_%d_',m,encoded_k,t),file_split);
directory_w = strcat(sprintf('Data/Data_m_%d_k_%d_t_%d_',m,(n-2*t),t),file_split);
original_name = strcat(directory,'/',file_split,'_original.',extension);
Original = imread(original_name);
Corrupted_Percentages = zeros(1,errors);
Sudan_Percentages = 1000*ones(1,errors);
Std_Percentages = 1000*ones(1,errors);
Whitaker_Percentages = 1000*ones(1,errors);
count = prod(size(Original));
for i=1:errors,
    
    try
        Test_Corrupted = strcat(directory,'/',file_split,'_corrupted_',sprintf('%d',i),'_errors.',extension)
        Corrupted_Image = imread(Test_Corrupted);
        Corrupted_Differences = sum(sum(sum((Original-Corrupted_Image) ~= 0)));
        Corrupted_Percentages(i) = Corrupted_Differences*100/count;
    catch
        fprintf('Image Missing');
    end;
    
    try
	Test_Sudan_Name = strcat(directory,'/',file_split,'_reconstucted_',sprintf('%d',i),'_errors.',extension)
	Sudan_Image = imread(Test_Sudan_Name);
	Sudan_Differences = sum(sum(sum((Original-Sudan_Image) ~= 0)));
	Sudan_Percentages(i) = Sudan_Differences*100/count;
	catch
        fprintf('Image Missing');
    end;
    
    try
	Test_Std_Name = strcat(directory,'/',file_split,'_reconstucted_std_',sprintf('%d',i),'_errors.',extension)
	Std_Image = imread(Test_Std_Name);
	Std_Differences = sum(sum(sum((Original-Std_Image) ~= 0)));
	Std_Percentages(i) = Std_Differences*100/count;
    catch
        fprintf('Image Missing');
    end;
    
    try
    Test_Whitaker_Name = strcat('WhitakerAlgorithm/',directory_w,'/',file_split,'_reconstucted_whitaker_',sprintf('%d',i),'_errors.',extension)
	Whitaker_Image = imread(Test_Whitaker_Name);
	Whitaker_Differences = sum(sum(sum((Original-Whitaker_Image) ~= 0)));
	Whitaker_Percentages(i) = Whitaker_Differences*100/count;
    catch
        fprintf('Image Missing');
    end;

end;

Difference_Per = 100 - [Corrupted_Percentages; Sudan_Percentages; Std_Percentages; Whitaker_Percentages]';
end

