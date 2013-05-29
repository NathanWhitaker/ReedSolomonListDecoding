function [image_data] = Image_Reconstruction(m,t,k,filename,data)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  System Parameters  %%%%%%%%%%%%%%%%%%%%
p = 2;   % Base Prime
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  System Sections  %%%%%%%%%%%%%%%%%%%%%
file_split=regexp(filename,'\x2E','split'); %%Split by "."
extension = file_split(2);
file_split=regexprep(file_split(1),'\x20','_');
directory = strcat(sprintf('./Data/Data_m_%d_k_%d_t_%d_',m,k,t),file_split);
directory = directory{1};
dimensions = dlmread(sprintf('%s/Dimensions.txt',directory));
%map = dlmread(sprintf('%s/Map.txt',directory));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Data Manipulation  %%%%%%%%%%%%%%%%%%%%%
data_stream = data(1,:) + (p^m)*data(2,:);
data_reshape = reshape(data_stream,dimensions);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Data Encoding     %%%%%%%%%%%%%%%%%%%%%
extension{1}
imwrite(double(data_reshape),strcat(sprintf('%s/',directory),file_split{1},'_reconstructed','.',extension{1}),extension{1});
image_data = data_reshape;
end
