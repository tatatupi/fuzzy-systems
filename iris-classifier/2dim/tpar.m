function [par] = tpar(K)

for i=0:K-1
    par(i+1,1)=(i-1)/(K-1);
    par(i+1,2)=(i+1)/(K-1);
end
