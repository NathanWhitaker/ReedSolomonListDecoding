function [ factors ] = Factorise_gf(poly,m,x_limit,y_limit )
%FACTORISE Summary of this function goes here
%   Detailed explanation goes here
% The factorisation of the polynomial is achieved through the use of the 
% factorisation function that is contained within MuPad. This is used by
% passing the polynomial as a string to this function which is used inline
% and the result is then parsed to retrieve the factors found
full_str = '';
for i=0:y_limit, %% Y Powers
    str = '';
    for j=0:x_limit, %% X Power
        in = (x_limit+1)*i + j + 1;
        coeff = poly((x_limit+1)*i + j + 1);
        if coeff ~= 0, %% Prevent filling polynomial string with zero coefficients
            str = strcat(str, sprintf(' %d*X^%d*Y^%d +',coeff.x,j,i));
        end;
    end;
    full_str = strcat(full_str, str);
end
poly_str = full_str(1:size(full_str,2)-1); %% Remove trailing "+"
base = str2double(char(feval(symengine,'nextprime',sprintf('%d',2^m))));
factor_param = sprintf('poly(%s, [Y, X], IntMod(%d))',poly_str,base); %% Add additional strings that are required
factor_sym = feval(symengine,'factor',factor_param);
factor_str = char(factor_sym);

start_fact = strfind(factor_str,'poly');
if (size(start_fact,1) > 0),
    clean_fact = 0;
    for i=1:size(start_fact,2),
        if ((factor_str(start_fact(i)+5:start_fact(i)+6)) == sprintf('X%d',m)),
            %% False Positive
        else
            if clean_fact == 0,
                start_fact_clean = start_fact(i);
                clean_fact = 1;
            else
                start_fact_clean = [start_fact_clean start_fact(i)];
            end;
        end;
    end;
    end_fact = strfind(factor_str,', [');

    factor_count = min(size(start_fact_clean,2),size(end_fact,2));
    factors = gf(zeros((x_limit+1)*(y_limit+1),factor_count),m);

    for i=1:factor_count,
        factors(:,i) = Str_to_Fact(factor_str(start_fact_clean(i)+5:end_fact(i)-1),m,x_limit,y_limit,base);
    end;
else
    factors = gf(zeros((x_limit+1)*(y_limit+1),1),m);
    factors(1) = gf(mod(str2double(factor_str),(2^m-1)),m);
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%% Identify Repeated Factors %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% find all polynomial powers up to 20 digits
power_fact   = regexp(factor_str,'\^\d{0,20}', 'match');
pow_fact_loc = regexp(factor_str,'\^\d{0,20}');
%% remove the ^ symbols contatined
power_fact   = str2double(regexprep(power_fact,'\^',''));

for i=1:size(pow_fact_loc,1),
	if(pow_fact_loc(i) > max(start_fact)),
		%% power is for last factor
		new_factor = factors(:,size(factors,2));
		ori_factor = new_factor;
	else
		%% power for factor one less then minimum distance
		[C,I] = min(abs(start_fact - pow_fact_loc(i)));
		new_factor = factors(:,max(I(1) - 1,1));
		ori_factor = new_factor;
	end;
    for j=1:power_fact(i)-1,
        new_factor = Factor_mult(new_factor,ori_factor,m);
        factors = [factors new_factor];
    end;
end
