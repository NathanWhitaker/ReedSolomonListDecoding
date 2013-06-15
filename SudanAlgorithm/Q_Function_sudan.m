function [ list_full ] = Q_Function_sudan( x_mat,y_mat,l,x_limit,m,d )
f_mat = [];
for i=0:l,
    x_select_limit = x_limit-(d)*i;
    for j=0:x_select_limit,
        f_mat = [f_mat (y_mat(:,i+1)).*x_mat(:,j+1)];
    end;
end;
list = gfnull(f_mat,'r',m);
list_full = gf(zeros(x_limit+1,l+1,size(list,2)),m);
prev_end = 1;
for i=0:l,
    selection_width= x_limit-(d)*i;
    list_full(1:1+selection_width,i+1,:) = list(prev_end:prev_end+selection_width,:);
    prev_end = prev_end+selection_width+1;
end

