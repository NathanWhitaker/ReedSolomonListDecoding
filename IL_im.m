function [ ] = IL_im(i)
matlabpool('open','AttachedFiles','Run_Image_Test.m');
%for i=1:15,
	[Corrupted_Data Corrupted_Data_Std] = Image_Encoder(4,2,6,'images/IL.bmp',i,1);
	Corrected_Std_Data = Run_Std_Image_Test(4,6,2,Corrupted_Data_Std.x);
	Corrected_Sudan_Data = Run_Image_Test(4,6,2,Corrupted_Data);
	Image_Reconstruction(4,6,2,'IL.bmp',Corrected_Sudan_Data,Corrected_Std_Data,i);
%end;
matlabpool close

