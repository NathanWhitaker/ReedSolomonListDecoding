function [ gcd ] = GCD( a,b,m )
%GCD Summary of this function goes here
%   Detailed explanation goes here

ri = a;
ri_plus_1 = b;
ri_minus_1 = ri;
zers = gf(zeros(size(a,1),1),m);
while(~isequal(ri_plus_1,zers) && ~isequal(ri_plus_1,0)),
    ri_minus_1 = ri;
    ri = ri_plus_1;
    [q, ri_plus_1] = Euclid(ri_minus_1,ri,m);
end;
gcd = ri;
end

