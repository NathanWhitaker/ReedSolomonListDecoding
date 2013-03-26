function [ List ] = Sudan(Y,m,k,choice)
%SUDAN Summary of this function goes here
%   Detailed explanation goes here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% System Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%
n = 2^m-1;
t = floor((n-k)/2);
d = k;%2^m -1 - 2*t;% k;
l = ceil(sqrt(2*(n+1)/d)) - 1;
X = gf(2,m) .^ (0:n-1); %%X is the alpha list
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Q(X,Y) Relationship between X and Y %%%%%%%%%
tStart = tic;
% Two possible Q(X,Y) functions choice=1 selects algorithm from Sudan paper,
% otherwise Q(X,Y) function found below used
% http://www.louisiana.edu/Academic/Sciences/MATH/stage/puremath2011.pdf
%if choice, 
    x_limit     = m+l*d;
    y_limit     = l;
    polynomials = Q_Function_sudan(X,Y,m,k,x_limit,y_limit);
%else
%    x_limit     = floor(sqrt(n));
%    y_limit     = floor(sqrt(n));
%    polynomials = Q_Function_n_root(X,Y,m,x_limit,y_limit);
%end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Factor Polynomials %%%%%%%%%%%%%%%%%%%%%%%%%%
%Polynomial that is found is then factorised
factors = gf(zeros((x_limit+1)*(y_limit+1),1),m);
for i=1:size(polynomials,2),
    factors = [factors Factorise_gf(polynomials(:,i),m,x_limit,y_limit)];
end;
%Remove initialisation value
factors = factors(:,2:size(factors,2));
%Remove duplicate factors
factors = gf(unique(factors.x','rows')',m); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Evaluate Polynomials %%%%%%%%%%%%%%%%%%%%%%%%
%fprintf('Factors :'); 
%List_count = 0;
List = gf(zeros(n,1),m);
%List_factors = gf(zeros((x_limit+1)*(y_limit+1),1),m);
for i=1:size(factors,2),
%	List = [List Factor_Exhaust(Y,factors(:,i),m,k)];

for j=1:n,
    [valid msg] = Eval_Factor(X,Y,(j*factors(:,i)),m,t,x_limit,y_limit);
    if valid,   
        %List_count = List_count + 1;
        List = [List msg];
    		j
				%List_factors = [List_factors factors(:,i)];
		end;
	end;      
end;
%List_count
%Remove initialisation value
List = List(:,2:size(List,2));
%List_factors = List_factors(:,2:size(List,2));
%Remove duplicate results
List = unique(List.x','rows')';
%List_factors = unique(List_factors.x','rows')';
List 
fprintf('List Size is : %d\r',size(List,2)); 
fprintf('Total Time : %d s\r\n',toc(tStart));
fprintf('');
end
