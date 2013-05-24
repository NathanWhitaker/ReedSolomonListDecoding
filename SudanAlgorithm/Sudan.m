function [ Min_Value ] = Sudan(Y,m,k)
%SUDAN Summary of this function goes here
%   Detailed explanation goes here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% System Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%
n = 2^m-1;
d = k;
t = floor((n-k)/2);
l = sqrt(2*(n+1)/d) - 1;
tau = 3;%floor((n-k-1)/2);
X = gf(2,m) .^ (0:n-1); %%X is the alpha list
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Q(X,Y) Relationship between X and Y %%%%%%%%%
tStart = tic;
% Two possible Q(X,Y) functions choice=1 selects algorithm from Sudan paper,
% otherwise Q(X,Y) function found below used
% http://www.louisiana.edu/Academic/Sciences/MATH/stage/puremath2011.pdf
x_limit     = n-tau-1; %floor(sqrt(n));%round(l*d + m);
y_limit     = 3; %floor(sqrt(n));%ceil(l);
x_mat = gf(zeros(n,x_limit+1),m);
y_mat = gf(zeros(n,y_limit+1),m);
for i=1:n,
    x_mat(i,:) = gf(X(i),m) .^ (0:x_limit);
    y_mat(i,:) = gf(Y(i),m) .^ (0:y_limit);
end;
polynomials = Q_Function_sudan(x_mat,Y,m,k,x_limit,y_limit);
polynomials = polynomials(1:(x_limit+1)*(y_limit+1),:);
polynomials = gf(unique(polynomials.x','rows')',m);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Factor Polynomials %%%%%%%%%%%%%%%%%%%%%%%%%%
%Polynomial that is found is then factorised
factors = gf(zeros((x_limit+1)*(y_limit+1),1),m);
for i=1:size(polynomials,2),
	new_factors = Factorise_gf(polynomials(:,i),m,x_limit,y_limit);
    factors = [factors new_factors];	
end;
%Remove initialisation value
factors = factors(:,2:size(factors,2));
%Remove duplicate factors
factors = gf(unique(factors.x','rows')',m); 
%Remove Y factor
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Evaluate Polynomials %%%%%%%%%%%%%%%%%%%%%%%%
List = gf(zeros(n,1),m);
for i=1:size(factors,2),
    msg = Factor_Exhaust(x_mat,y_mat,factors(:,i),m,t,x_limit,y_limit);
    List = [List msg];
end;
%Remove initialisation value
List = List(:,2:size(List,2));
%Remove duplicate results
List = unique(List.x','rows')';
fprintf('Sudan Time : %d s\r\n',toc(tStart));
fprintf('');
Min_Value = Minimum_Distance(List,Y);
end
