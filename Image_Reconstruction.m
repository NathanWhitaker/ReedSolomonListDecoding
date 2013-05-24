function [image_data] = Image_Reconstruction(m,t,filename,data)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  System Parameters  %%%%%%%%%%%%%%%%%%%%
p = 2;   % Base Prime
n = (p^m)-1; % Codeblock Size
k = n - (2*t); % Message Width
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  System Sections  %%%%%%%%%%%%%%%%%%%%%
file_split=regexp(filename,'\x2E','split'); %%Split by "."
extension = file_split(2);
file_split=regexprep(file_split(1),'\x20','_');
directory = strcat(sprintf('./Data_m_%d_t_%d_',m,t),file_split);
directory = directory{1};
dimensions = dlmread(sprintf('%s/Dimensions.txt',directory));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Data Manipulation  %%%%%%%%%%%%%%%%%%%%%
data_removed_parity = data(1:k,:);
data_stream_lower = data_removed_parity(:,1:round(size(data,2)/2));
data_stream_upper = data_removed_parity(:,round(size(data,2)/2)+1:size(data,2));
data_stream = data_stream_lower + (p^m)*data_stream_upper;
data_reshape = reshape(data_stream,dimensions);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Data Encoding     %%%%%%%%%%%%%%%%%%%%%
extension{1}
imwrite(data_reshape,strcat(sprintf('%s/',directory),file_split{1},'_reconstructed','.',extension{1}),extension{1});
image_data = data_reshape;
end
