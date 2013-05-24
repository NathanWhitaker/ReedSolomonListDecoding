function [ A ] = gf_red_row_etch( Mat )
%GF_RED_ROW_ETCH Summary of this function goes here
%   Detailed explanation goes here
A = Mat;
for i=1:min(size(A)),
    if(A(i,i) == 0),
        j = i+1;
        while((A(j,i) == 0) &&(j <= min(size(A)))),
            j = j + 1;
        end;  
        if(j>min(size(A))),
            break;
        end;
        temp = A(i,:);
        A(i,:) = A(j,:);
        A(j,:) = temp;
    end;
    %%Normalise to 1
    A(i,:) = A(i,:)/A(i,i);
    for j=1:min(size(A)),
        if(i==j),
            continue;
        end;
        A(j,:) = A(j,:) - A(j,i)*A(i,:);
    end;    
end;
end

