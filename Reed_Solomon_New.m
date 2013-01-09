%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  System Parameters  %%%%%%%%%%%%%%%%%%%%
close all; clear all;
p = 2;   % Base Prime
m = 4;   % Symbol Bit Width
t = 2;  % Half Parity Count
n = (p^m)-1; % Codeblock Size
k = n - (2*t); % Message Width
%the constants used in the algorithm
alpha = gf(2, m);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  System Sections  %%%%%%%%%%%%%%%%%%%%%
hEnc = comm.RSEncoder(n,k); % Create Encoder
hChan= comm.AWGNChannel('NoiseMethod','Signal to noise ratio (SNR)','SNR',10); % Noise Communication Channel
hDec = comm.RSDecoder(n,k); % Create Decoder for comparison
alpha_table = gf(zeros(1, 2*t), m);
for i=1:2*t,
    alpha_table(i) = alpha^(2*t-i+1);
end; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Data Generation  %%%%%%%%%%%%%%%%%%%%%
data = randi([0 n-1], k,1); % Generate Message Data
enc_data = step(hEnc,data); % Encode Data
dec_data = step(hDec,enc_data);

corrupted_data = step(hChan,enc_data);  
corrupted_data = round(corrupted_data); %% Convert to integer
corrupted_data = min(corrupted_data,2^m-1);
corrupted_data = max(corrupted_data,0); %% bound corrupted data between 0 and 2^m-1
corrupted_data_gf = gf(corrupted_data,m);
clear data hEnc hChan hDec
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Data Generation  %%%%%%%%%%%%%%%%%%%%%
actual_error_count = 0;
actual_error_location = 0;
for i=1:n,
    if((corrupted_data(i) - enc_data(i)) ~= 0)
        actual_error_count = actual_error_count + 1;
        actual_error_location(actual_error_count) = i;
    end;
end;
%fprintf('actual_error_count %d\r',actual_error_count);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Synd Calculation  %%%%%%%%%%%%%%%%%%%%
syndrome = gf(zeros(1, 2*t),m);
for i=1:2*t,
    for j=1:n,
        syndrome(i)=syndrome(i) + corrupted_data_gf(j) * (alpha^(i*(n-j)));
    end;
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Syndrome Check   %%%%%%%%%%%%%%%%%%%%%
if (syndrome == gf(zeros(1,2*t),m))
    fprintf( 'No Correction Required\r')
    return;
end;
clear alpha_table
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Berlekamp Massey %%%%%%%%%%%%%%%%%%%%%
%% Algorithm implemented from BBC White Paper 031 Appendix
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
clear e e_vect correction K order lambda_new 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Key Equation Calc %%%%%%%%%%%%%%%%%%%%
%% Algorithm implemented from BBC White Paper 031
%% Omega_1 = Synd_1
%% Omege_2 = Synd_2 + Lamda_1 * Synd_1
%% ..
%% ..
%% Omega_2t = Synd_2t + Synd_2t-1 * Lamda_1 + .... Synd_1 * Lamda_2t
omega = gf(zeros(1,2*t),m);
for i=1:(2*t),
    for j=1:i, %Lamda Coefficient Locations
        omega(i) = omega(i) + lambda(j)*syndrome(i-j+1);
    end;
end;
clear syndrome
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Chien Search Calc %%%%%%%%%%%%%%%%%%%%
%   f(?^i)     = a0 + a1*?^i+ ... + at*(?^i)^t
%   f(?^[i+1]) = a0 + a1*?^[i+1]+ ... + at*(?^[i+1])^t
%=> f(?^[i+1]) = a0 + a1*?^i*?+ ... + at*(?^[i+1])^t*?^t
%
%   f(?^[i+1]) = f(?^i) * alpha_table
%
% http://vincent.herbert.is.free.fr/documents/biswas-herbert-slides-weworc09.pdf
gamma = gf(zeros(1,2*t),m);
for j=1:2*t, 
    gamma(j) = lambda(j)*(alpha^(j-1));
end;
error_count = 0;
error_location = zeros(1,2*t);
eval_store = gf(zeros(1,n),m);
for i=1:n,
    eval_store(i) = 0;
    
    for j=1:2*t, % Accumulate Values
        eval_store(i) = eval_store(i) + gamma(j);
    end;

    if (eval_store(i) == 0) % Check for Root
        error_count = error_count + 1;
        error_location(error_count) = i; %alpha^-1
    end;
    
    for j=1:2*t, % New value to be evaluated
        gamma(j) = gamma(j) * (alpha^(j-1));
    end;
end;
%clear eval_store gamma
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Forney Algorithm %%%%%%%%%%%%%%%%%%%%%
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
out_data = double(decoded_data.x);    
diff = enc_data - out_data;
%if (actual_error_count > t)
%    fprintf('Error count beyond correction limit\r');
%    return;
%end;

%fprintf('Detected Error Locations : %g \r',error_location);
%fprintf('\rActual Error Locations : %g',actual_error_location);
%diff
%error_count

clear error_count error_location decoded_data lambda lambda_diff lambda_diff_eval omega omega_eval x_j forney_correct
clear i j
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
