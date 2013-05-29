function [ q,r ] = Euclid( a,b,m )
%EUCLOD Summary of this function goes here
%   Detailed explanation goes here
q=0;
r=a;
d=gf_poly_deg(b,m);
c=gf_poly_lc(b,m);
zers = gf(zeros(size(a,1),1),m);
while((gf_poly_deg(r,m) >=d) && (~isequal(r,zers))),
    x_deg = zers;
    x_deg(gf_poly_deg(r,m)-d+1) = 1; %%position is degree + 1
    s = (gf_poly_lc(r,m)/c)*x_deg;
    q = q + s;
    s_b = Factor_mult(s,b,m);
    s_b = s_b(:,size(s_b,2));
    r = r - s_b;
end;
end

