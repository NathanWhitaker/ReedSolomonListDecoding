function [ factor ] = Factorise_gf_brute( poly,m,k)
n = 2^m-1;
factor = [];      
zers = gf(zeros(size(poly,1),1),m);
one = zers;
one(1) = 1;
eval_matrix = [];
for i=0:n,
    eval_matrix = [eval_matrix gf(i,m).^(0:size(poly,1)-1)'];
end;
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
        factor_product = one;
        eval = find((eval_matrix' * poly_div)'==0);
        if isempty(eval),
            irreducible = 1;
            factor = [factor poly_div];
            break;
        end;
		%% If zero then factor found and appended to factor list
        new_factors = gf(zeros(size(poly,1),size(eval,2)),m);
        new_factors(2,:) = 1;
        new_factors(1,:) = eval-1;
        factor_product = Factor_mult(factor_product,new_factors,m);
        factor = [factor new_factors];
		%% Divide polynomial by factors that have been identified in the most recent pass
        [poly_div, r] = Euclid(poly_div,factor_product,m);
        if (gf_poly_deg(poly_div,m) <= 1),
            irreducible = 1;
            factor = [factor poly_div];
            break;
        end;
    end;
end;
end