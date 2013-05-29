function [Corrected_Image] = Image_Reconstruction(m,t,encoded_k,filename,Corrected_Image_Data)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  System Parameters  %%%%%%%%%%%%%%%%%%%%
p = 2;   % Base Prime
n = p^m-1;
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Data Manipulation  %%%%%%%%%%%%%%%%%%%%%
Corrected_Image_Data = Corrected_Image_Data.x;
Corrected_Image = Corrected_Image_Data(1,:) + (n+1)*Corrected_Image_Data(2,:);
Corrected_Image = uint8(reshape(Corrected_Image,dimensions));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Data Encoding     %%%%%%%%%%%%%%%%%%%%%
imwrite(Corrected_Image,strcat(sprintf('%s/',directory),file_split{1},'_reconstucted','.',extension{1}));
end
