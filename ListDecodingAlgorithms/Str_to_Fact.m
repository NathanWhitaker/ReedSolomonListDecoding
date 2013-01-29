function [ factor_vect ] = Str_to_Fact( factor_str,p,m )
%STR_TO_FACT Summary of this function goes here
%   Detailed explanation goes here
limit = floor(sqrt(p^m-1));

factor_vect = gf(zeros((limit+1)^2,1),m);
r=regexp(factor_str,'\x20\x2B\x20','split');
for i=1:size(r,2),
    coeff = cell2mat(r(i));
    y_power = str2double(coeff(strfind(coeff,'Y^')+2));
    x_power = str2double(coeff(strfind(coeff,'X^')+2));
    if (isempty(strfind(coeff,'Y'))), %% If value doesnt contain Y, X Only
        if (isempty(strfind(coeff,'X'))), %% If value doesnt contain X or Y then c value
            factor_vect(1) = gf(str2double(coeff),m);
        else
            value = str2double(strrep(coeff(1:strfind(coeff,'X')-1),'*',''));
            if strfind(coeff,'X')-1 == 0, %% No value before X thus coefficient is 1
                value = 1;
            end;
            if (isempty(strfind(coeff,'^'))), %% If value is single power of X
                factor_vect(2) = gf(value,m);
            else
                factor_vect(x_power + 1) = gf(value,m);
            end;
        end;
    else
        if (isempty(strfind(coeff,'X'))), %% If value contains Y but not X then Y Values
            value = str2double(strrep(coeff(1:strfind(coeff,'Y')-1),'*',''));
            if strfind(coeff,'Y')-1 == 0, %% No value before Y thus coefficient is 1
                value = 1;
            end;
            if (isempty(strfind(coeff,'^'))), %% If value is single power of Y
                factor_vect(limit+2) = gf(value,m);
            else
                factor_vect(y_power * (limit + 1) + 1) = gf(value,m);
            end;
        else %% Contains both X and Y
            value = str2double(strrep(coeff(1:strfind(coeff,'X')-1),'*',''));
            if strfind(coeff,'X')-1 == 0, %% No value before X thus coefficient is 1
                value = 1;
            end;   
            
            if (isempty(strfind(coeff,'X^'))),    
                if (isempty(strfind(coeff,'Y^'))), %% X*Y
                    factor_vect(limit + 3) = gf(value,m);
                else                               %% Y^n*X
                    factor_vect(y_power * (limit + 1) + 1 + 1) = gf(value,m);
                end;
            else                                                                 
               if (isempty(strfind(coeff,'Y^')))   %%Y*X^b
                   factor_vect(limit + 1 + 1 + x_power + 1) = gf(value,m);
               else                                %%Y^a*X^b
                   factor_vect(y_power * (limit + 1) + 1 + x_power) = gf(value,m);
               end;
            end;
        end;
    end;        
end
