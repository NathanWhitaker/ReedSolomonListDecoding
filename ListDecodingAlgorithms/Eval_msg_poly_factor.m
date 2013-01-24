function [ count gen_msg ] = Eval_msg_poly_factor( msg,poly,m,t )
%EL Summary of this function goes here
%   Detailed explanation goes here
length = 2^m-1;
poly_size = size(poly,1);
msg_power = gf(zeros(length,poly_size),m);
for i=1:length,
    msg_power(i,:) = gf(msg(i),m) .^ (1:poly_size);
end;
gen_msg = msg_power * poly;
count = 4;
%count = sum(ismember(gen_msg-msg,0));
end

