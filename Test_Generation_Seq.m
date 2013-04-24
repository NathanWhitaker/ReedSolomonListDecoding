function [] = Test_Generation_Seq( m,t,power )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  System Parameters  %%%%%%%%%%%%%%%%%%%%
p = 2;   % Base Prime
n = (p^m)-1; % Codeblock Size
k = n - (2*t); % Message Width
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  System Sections  %%%%%%%%%%%%%%%%%%%%%
Test_num = (2^m)^(power+1);
X_vals = gf(ones(1,n),m);
X_vals = [X_vals ;gf(2,m).^(1:n)];
val = 2^m;
for i=1:power,
	X_vals = [X_vals; X_vals(i+1,:).*X_vals(2,:)];	
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Data Generation  %%%%%%%%%%%%%%%%%%%%%
enc_data = gf(zeros(n,Test_num),m);
X_Coeff = gf(zeros(power+1,1),m);
for i=1:Test_num,
	test = i
	for j=1:power+1,
		X_Coeff(j) = mod(test,val);
		test = floor(test/val);
		new_val = X_Coeff(j)*X_vals(j,:);
		enc_data(:,i) = enc_data(:,i) +new_val';
	end;
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Error Generation  %%%%%%%%%%%%%%%%%%%%
error_count = randi([0 t],[1 Test_num]);
error_location = randi([1 n],[t  Test_num]);
error_value = randi([1 n],[t Test_num]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Data Export  %%%%%%%%%%%%%%%%%%%%%%%%%
directory = sprintf('./Data_m_%d_t_%d',m,t);
if ~exist(directory, 'dir')
  mkdir(directory);
end
dlmwrite(sprintf('%s/Encoded_Data.txt',directory),enc_data.x);
dlmwrite(sprintf('%s/Error_Count.txt',directory), error_count);
dlmwrite(sprintf('%s/Error_Location.txt',directory), error_location);
dlmwrite(sprintf('%s/Error_Value.txt',directory), error_value);
end

