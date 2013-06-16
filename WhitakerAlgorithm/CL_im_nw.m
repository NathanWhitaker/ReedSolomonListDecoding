function [ ] = CL_im_nw()
matlabpool open
[inv_factors,x_mat,comb] = InvGen(4,6);
for i=12:15,
	Corrupted_Data = Image_Encoder(4,2,6,'images/CL.bmp',i,1);
	Corrected_Whitaker_Data = Run_WhitakerAlgorithm(4,6,Corrupted_Data,inv_factors,comb,x_mat);
	Image_Reconstruction_nw(4,6,'images/CL.bmp',Corrected_Whitaker_Data,i)
end;
matlabpool close

