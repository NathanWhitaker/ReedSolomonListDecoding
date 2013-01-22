function [ count,gen_msg ] = Eval_msg_poly_factor( msg,poly,m,t )
%EL Summary of this function goes here
%   Detailed explanation goes here
length = 2^m-1;
k = length - 2*t;
count = 0;
gen_msg = zeros(1,length);
for i=1:length,
    msg_gf = Eval_gf_poly_factor(poly,msg(i),m);
    gen_msg(i) = double(msg_gf.x);
    result = msg(i) - gen_msg(i);
    if (result == 0),
        count = count + 1;
    end;
end;
end

