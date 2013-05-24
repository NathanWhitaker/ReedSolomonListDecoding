function [ factor_vect ] = Str_to_Fact( factor_str,m,x_limit,y_limit,base)
%STR_TO_FACT Summary of this function goes here
%   This is passed the string of a factor and this converts it into a
%   coefficient matrix in X and Y
n = 2^m-1;
ori_factor_str = factor_str;
factor_vect = gf(zeros((x_limit+1)*(y_limit+1),1),m);
minus_loc   = regexp(factor_str,'\-\x20');
factor_str = strrep(factor_str,'-','+');
all_loc   = [1 regexp(factor_str,'\+\x20')];
all_loc = unique(all_loc','rows')';
neg_coeff_loc= 0;
for i=1:size(minus_loc,2),
    j=1;
    while( (j<=size(all_loc,2)) && (minus_loc(i) ~= all_loc(j))),
        j=j+1;
    end;
    neg_coeff_loc = [neg_coeff_loc j];
end;
r=regexp(factor_str,'\x20\x2B\x20','split');  
for i=1:size(r,2),
    coeff = cell2mat(r(i));
    y_power = str2double(coeff(strfind(coeff,'Y^')+2));
    x_power = str2double(coeff(strfind(coeff,'X^')+2));
    if (isempty(strfind(coeff,'Y'))), %% If value doesnt contain Y, X Only
        if (isempty(strfind(coeff,'X'))), %% If value doesnt contain X or Y then c value
            factor_vect(1) = gf(str2double(coeff),m);
            if(ismember(i,neg_coeff_loc)),
               value = base-str2double(coeff);
               value = mod(value,n+1);
               factor_vect(1) = gf(value,m);
            end;
        else
            value = str2double(strrep(coeff(1:strfind(coeff,'X')-1),'*',''));
            if(ismember(i,neg_coeff_loc)),
               value = base - value;
            end;
            if strfind(coeff,'X')-1 == 0, %% No value before X thus coefficient is 1
                value = 1;
                if(ismember(i,neg_coeff_loc)),
                    value = base - value;
                end;
            end;
            value = mod(value,n+1);
            if (isempty(strfind(coeff,'^'))), %% If value is single power of X
                    factor_vect(2) = gf(value,m);
            else
                    factor_vect(x_power + 1) = gf(value,m);
            end;
        end;
    else
        if (isempty(strfind(coeff,'X'))), %% If value contains Y but not X then Y Values
            value = str2double(strrep(coeff(1:strfind(coeff,'Y')-1),'*',''));
            if(ismember(i,neg_coeff_loc)),
               value = base - value;
            end;
            if strfind(coeff,'Y')-1 == 0, %% No value before Y thus coefficient is 1
                value = 1;
                if(ismember(i,neg_coeff_loc)),
                    value = base - value;
                end;
            end;
            value = mod(value,n+1);
            if (isempty(strfind(coeff,'^'))), %% If value is single power of Y
                    factor_vect(x_limit+2) = gf(value,m);
            else
                    factor_vect(y_power * (x_limit + 1) + 1) = gf(value,m);
            end;
        else %% Contains both X and Y
            value = str2double(strrep(coeff(1:strfind(coeff,'Y')-1),'*','')); %% Y variable precedees X
            if(ismember(i,neg_coeff_loc)),
               value = base - value;
            end;
            if strfind(coeff,'Y')-1 == 0, %% No value before X thus coefficient is 1
                value = 1;
                if(ismember(i,neg_coeff_loc)),
                    value = base - value;
                end;
            end;   
            value = mod(value,n+1);
            if (isempty(strfind(coeff,'X^'))),    
                if (isempty(strfind(coeff,'Y^'))), %% X*Y
                    factor_vect(y_limit + 3) = gf(value,m);
                else                               %% Y^n*X
                    factor_vect(y_power * (y_limit + 1) + 1 + 1) = gf(value,m);
                end;
            else                                                                 
               if (isempty(strfind(coeff,'Y^')))   %%Y*X^b
                   factor_vect(y_limit + 1 + 1 + x_power + 1) = gf(value,m);
               else                                %%Y^a*X^b
                   factor_vect(y_power * (y_limit + 1) + 1 + x_power) = gf(value,m);
               end;
            end;
        end;
    end; 
    a = factor_vect.x;
end;
end
