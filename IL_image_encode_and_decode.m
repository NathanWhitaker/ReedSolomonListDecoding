matlabpool('open','AttachedFiles','Run_Image_Test.m');
for i=1:10,
    Corrupted_Data = Image_Encoder(4,2,6,'images/IL.bmp',i,1);
    Corrected_Data = Run_Image_Test(4,6,2,Corrupted_Data);
    Image_Reconstruction(4,6,2,'IL.bmp',Corrected_Data,i);
end;
matlabpool close