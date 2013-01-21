function [ Factor_List ] = Factor_gf_poly( Polynomial )
%FACTORISATION Summary of this function goes here
%   Detailed explanation goes here
poly = double(Polynomial.x);
k = size(poly,1);
Factor_List = zeros(1,k);
Factor_Count = 0;
%if (poly(:,2:size(poly,2)) == 0), %% only dependent on x
i = 1;
divider = 0;
dividend = double(poly(:,1)');
while(i <= bi2de(dividend)),
    i = i + 1; 
    divider = de2bi(i);
    [quot, remd] = gfdeconv(dividend,divider,2);
    if (remd == 0),
        padamount = k - size(divider,2);
        divider = padarray(divider,[0 padamount],'post'); %% pad to correct width
        if ~(ismember(divider,Factor_List,'rows')),
            Factor_Count = Factor_Count + 1;
            Factor_List(Factor_Count,:) = divider;
        end;
        dividend = quot;
        i = 1;
    end;
end;
%end;
Factor_List = Factor_List';
end

