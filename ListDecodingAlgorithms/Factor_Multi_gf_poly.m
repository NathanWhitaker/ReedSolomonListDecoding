function [ Factor_List ] = Factor_Multi_gf_poly( Multi_Polynomial )
%FACTOR_MULTI_GF_POLY Summary of this function goes here
%   Detailed explanation goes here
poly = double(Multi_Polynomial.x);
poly_count = size(poly,2);
Multi_Factor_List = zeros(size(poly,1),size(poly,1),poly_count);
for i = 1:poly_count
    Multi_Factor_List(:,:,i) = Factor_gf_poly(gf(poly(:,i)));
end
count = 1;
for i = 1:poly_count,
    j = 1;
    while(j <= size(poly,1)) 
        Multi_Factor_List(:,j,i);
        if (bi2de(Multi_Factor_List(:,j,i)') == 0),
            break;
        end;
        j = j + 1;
    end;
    if (j <= size(poly,1)),
        if (bi2de(Multi_Factor_List(:,j,i)') == 0),
            count = max(j,count);
        end;
    end;
end;
Factor_List = Multi_Factor_List(:,1:count-1,:);

