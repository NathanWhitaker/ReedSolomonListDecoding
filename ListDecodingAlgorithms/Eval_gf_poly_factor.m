function [ result ] = Eval_gf_poly( polynomial,point,m )
%EVAL_POLY Summary of this function goes here
%   Detailed explanation goes here
point = gf(point,m);
result = gf(0,m);
point_power = gf(point,m);
for i=1:size(polynomial,1),
    result = result + gf(polynomial(i),m) * point_power;
    point_power = point_power * point;
end

