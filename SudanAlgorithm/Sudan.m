function [ List ] = Sudan(Y,m,n,k)
%SUDAN Summary of this function goes here
%   Detailed explanation goes here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% System Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%
d = k-1;
t = (n-k)/2;
l = ceil(sqrt((n+1)/(m+1))) - 1;
o = 0;
X = gf(2,m) .^ (o:n-1+o); %%X is the alpha list
limit = 0;
D = double(ceil(sqrt(2*k*n)));
y_limit = double(ceil(D/k));
for j=0:D,
    limit = limit + double(floor((D - j)/k));
end;
iteration_limit = 2^(limit)-1; %%Only x based polynomials evaluated prevents overflow
fprintf('Test requires %d iterations\r',iteration_limit);
List_size = 0;
List = gf(zeros(m+l*d+1,l+1,1)); %% List of Coefficient matricies, k possible
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Q(X,Y) Relationship between X and Y %%%%%%%%%
tStart = tic;
for comb=1:iteration_limit, %% combination number
    c_kj = assign_c_kj(comb,l,m,d,n,k); %% Generate the Coefficient list
    i = 1; %%First symbol reseting
    Q = gf(0,m);
    while((i <= n) && (Q == 0)), %Only test whilst all values tested are zeros
        Q = Q_Weighted_Sum(X(i),Y(i),c_kj,m,l,d,k); %Evaluate Q function
        i = i + 1;  %Evaluate the next symbol
    end;
    if ((Q == 0) && (i == n+1)), %% Q values for coefficients used are zero for all inpus
        List_size = List_size + 1;
        fprintf('Value for iteration %d\r',comb)
        List(:,:,List_size) = c_kj; %% Add coefficent matrix to list recorded
    end;
end;
fprintf('Average Time : %d\r',toc(tStart)/iteration_limit);
tried_factors = zeros(size(List,1),size(List,2),1);
for i=1:size(List,3),
    factors = Factor_Multi_gf_poly(List(:,:,i));
    for j=1:size(factors,2),
        if ~(ismember(factors(:,j,1)',tried_factors','rows')),
            tried_factors = [tried_factors factors(:,j,1)];
            [count,msg] = Eval_msg_poly_factor(X,factors(:,j,1),m,t);
            fprintf('count : %d\r', count);
            if( t <= count),
                fprintf('factor : fits\r');
                gfpretty(factors(:,j,1)');
                fprintf('Generated Message :\r');
                msg.x
            else
                fprintf('factor : does not fit\r');
                gfpretty(factors(:,j,1)');
            end;
        end;
     end;
end;
fprintf('List Size is : %d s\r',List_size);
fprintf('Total Time : %d s\r',toc(tStart));