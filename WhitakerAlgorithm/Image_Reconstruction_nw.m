function [Whitaker_Image] = Image_Reconstruction_nw(m,t,filename,Corrected_Whitaker_Image_Data,errors)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  System Parameters  %%%%%%%%%%%%%%%%%%%%
p = 2;   % Base Prime
n = p^m-1;
k = n-(2*t);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  System Sections  %%%%%%%%%%%%%%%%%%%%%
file_split=regexp(filename,'\/','split');
filename = file_split{size(file_split,2)};
file_split=regexp(filename,'\x2E','split'); %%Split by "."
extension = file_split(2);
file_split=regexprep(file_split(1),'\x20','_');
directory = strcat(sprintf('./WhitakerAlgorithm/Data/Data_m_%d_k_%d_t_%d_',m,k,t),file_split);
directory = directory{1}; %cell to string
if ~exist(directory, 'dir')
  mkdir(directory);
end
dimensions = dlmread(sprintf('%s/Dimensions.txt',directory));
factor_reference = gf(zeros(k,n+1,n+1),m);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Data Encoding     %%%%%%%%%%%%%%%%%%%%%
Whitaker_Image_Data = Corrected_Whitaker_Image_Data.x;
Whitaker_Image_Data = uint8(Whitaker_Image_Data(1,:) + (n+1)*Whitaker_Image_Data(2,:));
Whitaker_Image = reshape(Whitaker_Image_Data,dimensions);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
imwrite(Whitaker_Image,strcat(sprintf('%s/',directory),file_split{1},'_reconstucted_whitaker_',sprintf('%d',errors),'_errors','.',extension{1}));
end

