function [BER_Probability] = BER_Testing_nw( m,t,enc_k,Number_of_Tests,BER )
matlabpool open
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  System Parameters  %%%%%%%%%%%%%%%%%%%%
p = 2;   % Base Prime
n = (p^m)-1; % Codeblock Size
k = n - (2*t); % Message Width
[inv_factors,x_mat,comb] = InvGen(m,t);
Test_Num = Number_of_Tests;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Data Generation  %%%%%%%%%%%%%%%%%%%%%
enc_data = gf(zeros(n,Test_Num),m);%x_mat * factors;
BER_Probability = zeros(1,1);
for i=1:size(BER,2),
    i
	Bit_Error_Count = round(BER(i)*Test_Num*n*m);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Error Generation  %%%%%%%%%%%%%%%%%%%%
    Corruption = reshape(gf(zeros(n,Test_Num),m),1,[]);
    All_Locations = randperm(Test_Num*n*m,Bit_Error_Count)-1;
	if  (isempty(All_Locations)),
		break;
	end;
    Error_Values = gf(2.^(mod(All_Locations,m)),m);
    Error_Locations = floor(All_Locations/m);
    for j=1:Bit_Error_Count
        j
        Corruption(Error_Locations(j)+1) = Corruption(Error_Locations(j)+1) + Error_Values(j);
    end;
    Corruption = reshape(Corruption,n,[]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Data Corruption  %%%%%%%%%%%%%%%%%%%%%
    Corrupted_Data = enc_data + Corruption;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Data Decoding  %%%%%%%%%%%%%%%%%%%%%
    Decoded_Data_Whitaker = Run_WhitakerAlgorithm(m,t,Corrupted_Data,inv_factors,comb,x_mat);
    
    BER_Probability = 1 - double((sum(sum((Decoded_Data_Whitaker(1:enc_k,:)   + enc_data(1:enc_k,:) )==0)~=0))/Test_Num);
	dlmwrite('NW_BER_Result.txt', [BER_Probability' BER(i)'],'precision','%1.10f','-append');
end;
matlabpool close;
end

