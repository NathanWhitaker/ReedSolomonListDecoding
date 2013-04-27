function [ A_rref ] = gf_red_row_etch( A )
%GF_RED_ROW_ETCH Summary of this function goes here
%   Detailed explanation goes here
Mat = A;
for i=1:min(size(Mat))
    if(Mat(i,i) == 0),
        j=i+1;
        while((Mat(j,i) == 0) && (j<size(Mat,1))),
            j=j+1;
        end;
        if(Mat(j,i) == 0),
            error('No Pivot');
        else
            Mat([i j],:) = Mat([j i],:);
        end;
    end;
    Mat(i,:) = Mat(i,:)/Mat(i,i);
    for j=1:size(Mat,1),
        if(i ~= j),
            Mat(j,:) = Mat(j,:) + Mat(i,:)*Mat(j,i);
        end;
    end;
end;
A_rref = Mat;
end

