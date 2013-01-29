function [ factors ] = Factorise_gf(X,Y,p,m,poly )
%FACTORISE Summary of this function goes here
%   Detailed explanation goes here
limit = floor(sqrt(p^m-1));
full_str = '';
for i=0:limit, %% Y Powers
    str = '';
    for j=0:limit, %% X Power
        a = (limit+1)*i + j + 1;
        coeff = poly((limit+1)*i + j + 1);
        str = strcat(str, sprintf(' %d*X^%d*Y^%d +',coeff.x,j,i));
    end;
    full_str = strcat(full_str, str);
end
poly_str = full_str(1:size(full_str,2)-1); %% Remove trailing "+"
factor_param = sprintf('poly(%s, IntMod(%d))',poly_str,(p^(m+1)+1));
factor_sym = feval(symengine,'factor',factor_param);
factor_str = char(factor_sym);
start_fact = strfind(factor_str,'poly');
end_fact = strfind(factor_str,', [X, Y]');

factor_count = min(size(start_fact,2),size(end_fact,2));
factors = gf(zeros((limit+1)^2,factor_count),m);
for i=1:factor_count,
    factor_str(start_fact(i)+5:end_fact(i)-1);
    factors(:,i) = Str_to_Fact(factor_str(start_fact(i)+5:end_fact(i)-1),p,m);
end;
end