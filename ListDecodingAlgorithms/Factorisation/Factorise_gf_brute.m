function [ factor ] = Factorise_gf_brute( poly,m,k)
n = 2^m-1;
factor = [];      
zers = gf(zeros(size(poly,1),1),m);
one = zers;
one(1) = 1;
%% For each polynomial that is passed in
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
        factors_found = [];
        factor_product = one;
		%% Evaluate polynomial at every point in finite field
        for i=0:n,
            x_powers = gf(i,m).^(0:size(poly_div,1)-1);
            eval = x_powers * poly_div;
			%% If zero then factor found and appended to factor list
            if (eval == 0),
                new_factor = zers;
                new_factor(2) = 1;
                new_factor(1) = i;
                factors_found = [factors_found new_factor];
                factor_product = Factor_mult(factor_product,new_factor,m);
                factor_product = factor_product(:,size(factor_product,2));
            end;
            if (i==n),
                if isempty(factors_found),
                    irreducible = 1;
                    factor = [factor poly_div];
                    break;
                end;
                factor = [factor factors_found];
				%% Divide polynomial by factors that have been identified in the most recent pass
                [poly_div, r] = Euclid(poly_div,factor_product,m);
                if(gf_poly_deg(poly_div,m) == 0),
                    factor = [factor poly_div];
                    irreducible = 1;
                    break;
                end;
            end;
        end;
    end;
end;
end

