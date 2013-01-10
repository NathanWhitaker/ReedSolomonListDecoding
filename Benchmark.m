function [ corrected_data ] = Benchmark( corrupted_data_gf,p,m,t,n,k)
%BENCHMARK Summary of this function goes here
%   Detailed explanation goes here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  System Parameters  %%%%%%%%%%%%%%%%%%%%
%the constants used in the algorithm
alpha = gf(2, m);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Synd Calculation  %%%%%%%%%%%%%%%%%%%%
tic
tBench = tic;
syndrome = gf(zeros(1, 2*t),m);
alpha_power = gf(0,m);
alpha_mult = gf(0,m);
for i=1:2*t,
    alpha_power = alpha^(i*n);
    alpha_mult = alpha^-i;
    for j=1:n,
        alpha_power = alpha_power * alpha_mult;
        syndrome(i) = syndrome(i) + corrupted_data_gf(j) * alpha_power;
    end;
end;
%fprintf('Benchmark Syndrome Calculation : %d s\r',toc);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Syndrome Check   %%%%%%%%%%%%%%%%%%%%%
if (syndrome == gf(zeros(1,2*t),m))
    fprintf( 'No Correction Required\r')
    corrected_data = corrupted_data_gf.x;
    return;
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Berlekamp Massey %%%%%%%%%%%%%%%%%%%%%
%% Algorithm implemented from BBC White Paper 031 Appendix
tic
lambda  = gf(zeros(1,2*t),m);
lambda_new  = gf(zeros(1,2*t),m);
lambda_new(1) = 1;
correction = gf(zeros(1,2*t),m);
correction(2) = 1;
order = 0;
for K=1:(2*t),
    e = 0;
    lambda = lambda_new;
    for i=1:K,
        e = e + lambda(i)*syndrome(K-i+1); 
    end;
    lambda_new = lambda + e*correction;
    if(2*order < K)
        order = K - order;
        if(e ~= 0)
            correction = lambda / e;
        end;
    end;
    correction = circshift(correction,[0 1]);
end;
lambda = lambda_new;
%fprintf('Benchmark Berlekamp Massey : %d s\r',toc);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Key Equation Calc %%%%%%%%%%%%%%%%%%%%
%% Algorithm implemented from BBC White Paper 031
%% Omega_1 = Synd_1
%% Omege_2 = Synd_2 + Lamda_1 * Synd_1
%% ..
%% ..
%% Omega_2t = Synd_2t + Synd_2t-1 * Lamda_1 + .... Synd_1 * Lamda_2t
tic
omega = gf(zeros(1,2*t),m);
for i=1:(2*t),
    for j=1:i, %Lamda Coefficient Locations
        omega(i) = omega(i) + lambda(j)*syndrome(i-j+1);
    end;
end;
%fprintf('Benchmark Omega : %d s\r',toc);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Chien Search Calc %%%%%%%%%%%%%%%%%%%%
%   f(?^i)     = a0 + a1*?^i+ ... + at*(?^i)^t
%   f(?^[i+1]) = a0 + a1*?^[i+1]+ ... + at*(?^[i+1])^t
% http://vincent.herbert.is.free.fr/documents/biswas-herbert-slides-weworc09.pdf
tic
gamma = gf(zeros(1,2*t),m);
for j=1:2*t, 
    gamma(j) = lambda(j)*(alpha^(j-1));
end;
error_count = 0;
eval_store = gf(zeros(1,n),m);
for i=1:n,
    eval_store(i) = 0;
    
    for j=1:2*t, % Accumulate Values
        eval_store(i) = eval_store(i) + gamma(j);
        gamma(j) = gamma(j) * (alpha^(j-1));
    end;

    if (eval_store(i) == 0) % Check for Root
        error_count = error_count + 1;
        error_location(error_count) = i; %alpha^-1
    end;
end;
%fprintf('Benchmark Chien Search : %d s\r',toc);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Forney Algorithm %%%%%%%%%%%%%%%%%%%%%
tic
lambda_diff      = gf(zeros(1,t),m);
forney_correct   = gf(zeros(1,t),m);
omega_eval       = gf(zeros(1,t),m);
lambda_diff_eval = gf(zeros(1,t),m);
x_j              = gf(zeros(1,t),m);

decoded_data = corrupted_data_gf;
for i=1:(t),
    lambda_diff(i) = lambda(2*i-1);
end;
for i=1:error_count,
    x_j(i) = (alpha^-(n-error_location(i)));  
    for j=1:t,
        lambda_diff_eval(i) = lambda_diff_eval(i) + lambda_diff(j)*(x_j(i)^((j-1)*2));
    end;    
    for j=1:2*t,
        omega_eval(i) = omega_eval(i) + omega(j)*(x_j(i)^(j-1));
    end;    
    forney_correct(i) = (x_j(i))*(omega_eval(i)/lambda_diff_eval(i));
    decoded_data(error_location(i)) = decoded_data(error_location(i)) + forney_correct(i);   
end;
corrected_data = double(decoded_data.x);

%fprintf('Benchmark Forney : %d s\r',toc);   
fprintf('Benchmark Time : %d s\r',toc(tBench));  
%fprintf('Benchmark Error Locations : %g \r',error_location);
%fprintf('\r');
end

