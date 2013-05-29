function [ min_distance,min_fact ] = Minimum_Distance(List,Factor_List,Y)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
List;
if(size(List,2) == 0),
    min_distance = zeros(size(List,1),1);
    min_fact = zeros(size(Factor_List,1),1);
    return;
end;
distance = List(:,1) - Y;
for i=2:size(List,2),
    distance = [distance List(:,i) - Y];
end;
distance = sum(min(distance.x,1));
[r,c]=find(distance==min(min(distance)));
min_distance = List(:,c(1));
min_fact = Factor_List(:,c(1));
end

