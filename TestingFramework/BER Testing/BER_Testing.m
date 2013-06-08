function [BER_Probability] = BER_Testing( m,t,enc_k,Number_of_Tests,BER )
matlabpool('open','AttachedFiles','BER_Testing.m');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  System Parameters  %%%%%%%%%%%%%%%%%%%%
p = 2;   % Base Prime
n = (p^m)-1; % Codeblock Size
k = n - (2*t); % Message Width
Std_Dec = comm.RSDecoder('CodewordLength',n,'MessageLength',k);
Test_Num = Number_of_Tests;
X = gf(2,m);
x_col = X.^(0:n-1)';
x_mat = gf(ones(n,1),m);
for i=1:enc_k-1,
	x_mat = [x_mat x_col.^i];
end;
clear X x_col i
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Data Generation  %%%%%%%%%%%%%%%%%%%%%
factors = gf(randi([0 n-1], enc_k,Test_Num),m); % Generate Message Data
enc_data = x_mat * factors;
BER_Probability = zeros(2,size(BER,2));
for i=1:size(BER,2),
    Bit_Error_Count = round(BER(i)*Test_Num*n*m);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Error Generation  %%%%%%%%%%%%%%%%%%%%
    Corruption = reshape(gf(zeros(n,Test_Num),m),1,[]);
    All_Locations = randperm(Test_Num*n*m)-1;
    Error_Values = gf(2.^(mod(All_Locations(1:Bit_Error_Count),m)),m);
    Error_Locations = floor(All_Locations(1:Bit_Error_Count)/m);
    for j=1:Bit_Error_Count
        j
        Corruption(Error_Locations(j)+1) = Corruption(Error_Locations(j)+1) + Error_Values(j);
    end;
    Corruption = reshape(Corruption,n,[]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Data Corruption  %%%%%%%%%%%%%%%%%%%%%
    Corrupted_Data = enc_data + Corruption;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Data Decoding  %%%%%%%%%%%%%%%%%%%%%
    Decoded_Data_Std = [];
    Corrupted_Data_Int = Corrupted_Data.x;
    for j=1:Test_Num,
        Decoded_Data_Std = [Decoded_Data_Std step(Std_Dec,Corrupted_Data_Int(:,j))];
    end;
    Decoded_Data_Sudan = Run_Test_BER(m,t,Corrupted_Data);
    
    BER_Probability(1,i) = 1 - double((sum(sum((Decoded_Data_Std(1:k,:)   + enc_data(1:k,:) )==0)~=0))/Test_Num);
    BER_Probability(2,i) = 1 - double((sum(sum((Decoded_Data_Sudan(1:k,:) + enc_data(1:k,:) )==0)~=0))/Test_Num);
end;
dlmwrite('BER_Result.txt', [BER_Probability' BER'],'precision','%1.10f');
matlabpool close;
end

