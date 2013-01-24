function [ Q_Sum ] = Q_Weighted_Sum(X,Y,c_kj,m,l,d,k)
%Q_RELATIONSHI Summary of this function goes here
%   Detailed explanation goes here
n = 2^m - 1;
D = double(ceil(sqrt(2*k*n)));
y_limit = double(floor(D/k));
x_mat = X .^ (0:D);
y_mat = Y .^ (0:(y_limit));
horz_ones = gf(ones(1,D+1),m);
Q_Sum = horz_ones * diag(x_mat' * y_mat * c_kj');
end

% http://www.cse.buffalo.edu/~atri/courses/coding-theory/lectures/lect38.pdf

%% Explanation Below
%[1 x x^2 x^3 x^4 x^5 ... x^D]      
%[1 y y^2 y^3 y^4 y^5 ... y^y_limit]
%[1 1 1 1 1 1 ... 1]     

%% Coefficient Matrix Passed Transposed
%|c0,0 c1,0 c2,0 c3,0 c4,0 c5,0 ... cy_limit,0|
%|c0,1 c1,1 c2,1 c3,1 c4,1 c5,1 ... cy_limit,1|
%|c0,2 c1,2 c2,2 c3,2 c4,2 c5,2 ... cy_limit,2|
%|c0,3 c1,3 c2,3 c3,3 c4,3 c5,3 ... cy_limit,3|
%|c0,4 c1,4 c2,4 c3,4 c4,4 c5,4 ... cy_limit,4|
%|c0,5 c1,5 c2,5 c3,5 c4,5 c5,5 ... cy_limit,5|
%|  .    .    .    .    .    .  ...      .    |
%|  .    .    .    .    .    .  ...      .    |
%|  .    .    .    .    .    .  ...      .    |
%|c0,D c1,D c2,D c3,D c4,D c5,D ... cy_limit,D|

%                 /\
%                 ||
%             Transposed
%                 ||
%                 \/          
            
%|    c0,0       c0,1       c0,2       c0,3       c0,4       c0,5       ...        c0,D |   
%|    c1,0       c1,1       c1,2       c1,3       c1,4       c1,5       ...        c1,D |  
%|    c2,0       c2,1       c2,2       c2,3       c2,4       c2,5       ...        c2,D |  
%|    c3,0       c3,1       c3,2       c3,3       c3,4       c3,5       ...        c3,D |   
%|    c4,0       c4,1       c4,2       c4,3       c4,4       c4,5       ...        c4,D |   
%|    c5,0       c5,1       c5,2       c5,3       c5,4       c5,5       ...        c5,D |  
%|     .          .          .          .          .          .          .          .   |
%|     .          .          .          .          .          .          .          .   |
%|     .          .          .          .          .          .          .          .   |
%|cy_limit,0 cy_limit,1 cy_limit,2 cy_limit,3 cy_limit,4 cy_limit,5     ...  cy_limit,D | 

%% Transposed X Matrix Multiplied by Y Matrix

%| 1 |*[1 y y^2 y^3 y^4 y^5 ... y^y_limit] = | 1     y^1    y^2    y^3    y^4    y^5 ...    y^y_limit|
%|x^1|                                     = | x    xy^1   xy^2   xy^3   xy^4   xy^5 ...    y^y_limit|
%|x^2|                                     = |x^2 x^2y^1 x^2y^2 x^2y^3 x^2y^4 x^2y^5 ... x^2y^y_limit|
%|x^3|                                     = |x^3 x^3y^1 x^3y^2 x^3y^3 x^3y^4 x^3y^5 ... x^3y^y_limit|
%|x^4|                                     = |x^4 x^4y^1 x^4y^2 x^4y^3 x^4y^4 x^4y^5 ... x^4y^y_limit|
%|x^5|                                     = |x^5 x^5y^1 x^5y^2 x^5y^3 x^5y^4 x^5y^5 ... x^5y^y_limit|
%| . |                                     = | .    .      .      .      .      .    ...       .     |
%| . |                                     = | .    .      .      .      .      .    ...       .     |
%| . |                                     = | .    .      .      .      .      .    ...       .     |
%|x^D|                                     = |x^D x^Dy^1 x^Dy^2 x^Dy^3 x^Dy^4 x^Dy^5 ... x^Dy^y_limit|

%% XY Matrix  Multiplied by Transposed C_kj Matrix

% | 1     y^1    y^2    y^3    y^4    y^5 ...    y^y_limit| * |    c0,0       c0,1       c0,2       c0,3       c0,4       c0,5       ...        c0,D | = | v0 ?  ?  ?  ?  ?  ? ..... ? ... ?| 
% | x    xy^1   xy^2   xy^3   xy^4   xy^5 ...    y^y_limit|   |    c1,0       c1,1       c1,2       c1,3       c1,4       c1,5       ...        c1,D | = | ? v1  ?  ?  ?  ?  ? ..... ? ... ?|
% |x^2 x^2y^1 x^2y^2 x^2y^3 x^2y^4 x^2y^5 ... x^2y^y_limit|   |    c2,0       c2,1       c2,2       c2,3       c2,4       c2,5       ...        c2,D | = | ?  ? v2  ?  ?  ?  ? ..... ? ... ?|
% |x^3 x^3y^1 x^3y^2 x^3y^3 x^3y^4 x^3y^5 ... x^3y^y_limit|   |    c3,0       c3,1       c3,2       c3,3       c3,4       c3,5       ...        c3,D | = | ?  ?  ? v3  ?  ?  ? ..... ? ... ?|
% |x^4 x^4y^1 x^4y^2 x^4y^3 x^4y^4 x^4y^5 ... x^4y^y_limit|   |    c4,0       c4,1       c4,2       c4,3       c4,4       c4,5       ...        c4,D | = | ?  ?  ?  ? v4  ?  ? ..... ? ... ?|
% |x^5 x^5y^1 x^5y^2 x^5y^3 x^5y^4 x^5y^5 ... x^5y^y_limit|   |    c5,0       c5,1       c5,2       c5,3       c5,4       c5,5       ...        c5,D | = | ?  ?  ?  ?  ? v5  ? ..... ? ... ?|
% | .    .      .      .      .      .    ...       .     |   |     .          .          .          .          .          .          .          .   | = | .  .  .  .  .  .  . ..... . ... ?|
% | .    .      .      .      .      .    ...       .     |   |     .          .          .          .          .          .          .          .   | = | .  .  .  .  .  .  . ..... . ... ?|
% | .    .      .      .      .      .    ...       .     |   |     .          .          .          .          .          .          .          .   | = | .  .  .  .  .  .  . ..... . ... ?|
% |x^D x^Dy^1 x^Dy^2 x^Dy^3 x^Dy^4 x^Dy^5 ... x^Dy^y_limit|   |cy_limit,0 cy_limit,1 cy_limit,2 cy_limit,3 cy_limit,4 cy_limit,5     ...  cy_limit,D | = | ?  ?  ?  ?  ?  ?  ? ..... vn ?  ?|

%% Diag(XY Matrix  Multiplied by Transposed C_kj) Matrix

%| v0 |
%| v1 |
%| v2 |
%| v3 |
%| v4 |
%| v5 |
%| .. |
%| .. |
%| .. |
%| vn |

%% Horz ones * Diag(XY Matrix  Multiplied by Transposed C_kj) Matrix

%[1 1 1 1 1 1 ... 1]  *  | v0 | = (v0 + v1 + v2 + v3 + v4 + v5 + .. + .. + .. vn)
%                        | v1 |
%                        | v2 |
%                        | v3 |
%                        | v4 |
%                        | v5 |
%                        | .. |
%                        | .. |
%                        | .. |
%                        | vn |


%% Previous Algorithm
%k_limit = m+l*d;
%Q = gf(zeros(l+1,1),m);
%x_mat = X .^ (0:k_limit);
%y_mat = Y .^ (0:l);
%horz_ones = gf(ones(1,l+1),m);
%for j=0:l,
%    Q(j+1) =  (x_mat .* y_mat(j+1)) * c_kj(:,j+1);
%end;
%Q_Sum = horz_ones * Q;
%end