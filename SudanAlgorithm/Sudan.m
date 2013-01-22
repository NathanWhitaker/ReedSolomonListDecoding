function [ List ] = Sudan(X,m,n,k)
%SUDAN Summary of this function goes here
%   Detailed explanation goes here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% System Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%
d = 2*m+2;
t = (n-k)/2;
l = ceil(sqrt((n+1)/(m+1))) - 1;
alpha = gf(2,m);
%c_kj = gf(zeros(m+l*d+1,l+1)); %% Coefficient matrix for Q function

Y = gf(1,m);
limit = 0;
for j=0:l,
    limit = limit + m+(l-j)*d+1;
end;
limit = 4000;%2^limit;
fprintf('Test requires %d iterations\r',limit);
List_size = 0;
List = gf(zeros(m+l*d+1,l+1,1)); %% List of Coefficient matricies, k possible
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Q(X,Y) Relationship between X and Y %%%%%%%%%
tStart = tic;
for comb=1:limit, %% combination number
    c_kj = assign_c_kj(comb,l,m,d);
    i = 1;
    Q = gf(0,m);
    while((i <= n) && (Q == 0)),
        Q = Q_Weighted_Sum(X(i),Y,c_kj,m,l,d);
        Y = Y * alpha;
        i = i + 1;
    end;
    %fprintf('Value for iteration %d is %d at input value %d\r',comb,Q.x,i);
    if ((Q == 0) && (i == n+1)), %% Q values for coefficients used are zero for all inpus
        List_size = List_size + 1;
        if List_size == 1,
            f = comb;
        end;
        fprintf('Value for iteration %d\r',comb)
        fprintf('Value for normalised %d\r',comb/f)
        List(:,:,List_size) = c_kj; %% Add coefficent matrix to list recorded
    end;
end;
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
                msg
            else
                fprintf('factor : does not fit\r');
                gfpretty(factors(:,j,1)');
            end;
        end;
     end;
end;
fprintf('List Size is : %d s\r',List_size);
fprintf('Total Time : %d s\r',toc(tStart));