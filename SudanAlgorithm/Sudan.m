function [ Min_Value, Min_Factor ] = Sudan(Y,m,k)
%SUDAN Summary of this function goes here
%   Detailed explanation goes here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% System Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%
n = 2^m-1;
d = n-k+1;
t = floor((n-k)/2);
l = 1;%sqrt(2*(n+1)/d) - 1;
tau = 3;%floor((n-k-1)/2);
X = gf(2,m) .^ (0:n-1)'; %%X is the alpha list
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Q(X,Y) Relationship between X and Y %%%%%%%%%
tStart = tic;
% Two possible Q(X,Y) functions choice=1 selects algorithm from Sudan paper,
% otherwise Q(X,Y) function found below used
% http://www.louisiana.edu/Academic/Sciences/MATH/stage/puremath2011.pdf
x_limit     = m+l*d; %floor(sqrt(n));%round(l*d + m);
y_limit     = l; %floor(sqrt(n));%ceil(l);
x_mat = gf(zeros(n,x_limit+1),m);
y_mat = gf(zeros(n,y_limit+1),m);
for i=1:n,
    x_mat(i,:) = gf(X(i),m) .^ (0:x_limit);
    y_mat(i,:) = gf(Y(i),m) .^ (0:y_limit);
end;
polynomials = sudan_q_2(x_mat,y_mat,l,x_limit,m,d ); %Q_Function_sudan(x_mat,y_mat,m,d,k,x_limit,y_limit);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Factor Polynomials %%%%%%%%%%%%%%%%%%%%%%%%%%
%Polynomial that is found is then factorised
one = gf(zeros(size(polynomials,1),1),m);
one(1) = 1;
norm_poly = one;
for i=1:size(polynomials,3),
    norm_poly = [norm_poly polynomials(:,1,i)];
end;
factors = Factorise_gf_brute(norm_poly,m,k);%Factorise_gf(polynomials(:,i),m,k,x_limit,y_limit);
%Remove duplicate factors
factors = gf(unique(factors.x','rows')',m);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Evaluate Polynomials %%%%%%%%%%%%%%%%%%%%%%%%
List = [];
Factor_List = [];
for i=1:size(factors,2),
    [msg factor] = Factor_Exhaust(x_mat,Y,factors(:,i),m,t);
    List = [List msg];
    Factor_List = [Factor_List factor];
end;
List_Degree = [];
Factor_List_Degree = [];
for i=1:size(Factor_List,2),
    if (gf_poly_deg(Factor_List(:,i),m) <k),
        List_Degree = [List_Degree List(:,i)];
        Factor_List_Degree = [Factor_List_Degree Factor_List(:,i)];
    end;
end;
fprintf('Sudan Time : %d s\r\n',toc(tStart));
[Min_Value, Min_Factor] = Minimum_Distance(List_Degree,Factor_List_Degree,Y);
end
