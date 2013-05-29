function [ factors ] = SFF(f,m)
%SFF Summary of this function goes here
%   Detailed explanation goes here
if (gf_poly_deg(f,m) == 0),
    factors = f;
    return;
end;
f_dash = gf_poly_diff(f,m);
u = GCD(f,f_dash,m);
n = gf_poly_deg(f,m);
ones = gf(zeros(size(f,1),1),m);
ones(1) = 1;
if ((isequal(u,ones)) || (isequal(u,1))),
    factors = f;
    return;
end;
if((gf_poly_deg(u,m) <n) && (gf_poly_deg(u,m) >=1)),
    [f_div_u, r] = Euclid(f,u,m);
    factors_1 = SFF(u,m);
    factors_2 = SFF(f_div_u,m);
    factors = [factors_1 factors_2];
    return;
end;
if(isequal(u,f)),
    f_new = gf(zeros(size(1,1),1),m);
    for i=0:floor(n/2),
        f_new(i+1) = f(2*i+1);
    end;
    h = f_new .^ (1/2);
    factor_1 = SFF(h,m);
    scale_factor_1 = factor_1 .*(1/gf(2,m));
    factors = repmat(scale_factor_1,[1 2]);
end;
factors = f;

for i=1:size(factors,2),
    factors(:,i) = factors(:,i)/gf_poly_lc(factors(:,i),m);
end;

% i=1;
% p=2;
% g = gf_poly_diff(f,m);
% zers = gf(zeros(size(f,1),1),m);
% one = zers;
% one(1) = 1;
% R = one;
% if(~isequal(g,zers)),
%     c = GCD(f,g,m)
%     [w,r] = Euclid(f,c,m)
%     while (~isequal(w,one)),
%         y = GCD(w,c,m)
%         [z,r] = Euclid(w,y,m)
%         R = Factor_mult(R,z.^i,m)
%         R = R(:,size(R,2))
%         i = i + 1
%         w = y
%         [c,r] = Euclid(c,y,m)
%     end;
%     if (~isequal(c,zers)),
%         c = c.^(1/p);
%         factors = (R*(SFF(c,m)^p));
%     else
%         factors = R;
%     end;
% else
%     f = f.^(1/p);
%     factors = SFF(f,m).^p;
% end;



end

