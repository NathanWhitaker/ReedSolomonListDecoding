function [ min_distance ] = Minimum_Distance(List,Y)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
distance = List(:,1) - Y;
for i=2:size(List,2),
    distance = [distance List(:,i) - Y];
end;
distance = sum(min(distance.x,1));
[r,c]=find(distance==min(min(distance)));
min_distance = List(:,c(1));
end

