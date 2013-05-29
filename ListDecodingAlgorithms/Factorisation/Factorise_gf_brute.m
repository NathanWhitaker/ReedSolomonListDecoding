function [ factor ] = Factorise_gf_brute( poly,m,k)
%FACTORISE_GF_BRUTE Summary of this function goes here
%   Detailed explanation goes here
n = 2^m-1;
factor = [];
%for i=1:size(poly,3),
%    factor = [factor poly(:,:,i)];
%end;        
zers = gf(zeros(size(poly,1),1),m);
for j=1:size(poly,2),
    poly_div = poly(:,j);
    if(gf_poly_deg(poly_div,m) <= k),
        factor = [factor poly_div];
    end;
    irreducible = 0;
    if (isequal(poly_div,zers)),
        irreducible = 1;
    end;
    while(~irreducible),            
        for i=0:n,
            x_powers = gf(i,m).^(0:size(poly_div,1)-1);
            eval = x_powers * poly_div;
            if (eval == 0),
                new_factor = zers;
                new_factor(2) = 1;
                new_factor(1) = i;
                [poly_div, r] = Euclid(poly_div,new_factor,m);
                factor = [factor new_factor]; %poly_div
                if(gf_poly_deg(poly_div,m) <= k),
                    factor = [factor poly_div];
                end;
                break;
            end;
            if (i==n),
                irreducible = 1;
                factor = [factor poly_div];
            end;
        end;
    end;
end;

end

