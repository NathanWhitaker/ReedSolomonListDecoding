function [] = Random_Test_Generation_Poly( m,t,Test_num )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  System Parameters  %%%%%%%%%%%%%%%%%%%%
p = 2;   % Base Prime
n = (p^m)-1; % Codeblock Size
k = n - (2*t); % Message Width
d = k;
l = ceil(sqrt(2*(n+1)/d)) - 1;
x_limit     = m+l*d;
y_limit     = l;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  System Sections  %%%%%%%%%%%%%%%%%%%%%
X_vals = gf(ones(1,n),m);
X_vals = [X_vals ;transpose(circshift(transpose(gf(2,m).^(1:n)),1))];
val = 2^m;
for i=1:x_limit-1,
	X_vals = [X_vals; X_vals(i+1,:).*X_vals(2,:)];	
end;
X_vals = X_vals';
X_Coeff = gf(randi([0 n],[x_limit+1 Test_num]),m);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Data Generation  %%%%%%%%%%%%%%%%%%%%%
enc_data = X_vals*X_Coeff;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Error Generation  %%%%%%%%%%%%%%%%%%%%
error_count = randi([0 t],[1 Test_num]);
error_location = randi([1 n],[t  Test_num]);
error_value = randi([1 n],[t Test_num]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Data Export  %%%%%%%%%%%%%%%%%%%%%%%%%
directory = sprintf('./Data/Data_m_%d_t_%d',m,t);
if ~exist(directory, 'dir')
  mkdir(directory);
end
dlmwrite(sprintf('%s/Encoded_Data.txt',directory),enc_data.x);
dlmwrite(sprintf('%s/Error_Count.txt',directory), error_count);
dlmwrite(sprintf('%s/Error_Location.txt',directory), error_location);
dlmwrite(sprintf('%s/Error_Value.txt',directory), error_value);
end

