function [ ] = CL_im( i )
matlabpool('open','AttachedFiles','Run_Image_Test.m');
Corrupted_Data = Image_Encoder(4,2,6,'images/CL.bmp',i,1);
Corrected_Data = Run_Image_Test(4,6,2,Corrupted_Data);
Image_Reconstruction(4,6,2,'CL.bmp',Corrected_Data,i);
matlabpool close

