function [av, mx, ig] = metrica(matrix)
%given a matrix returns its mean, max and integral

av = mean(mean(matrix));
mx = max(max(matrix));

ig = 0;
for i=1:size(matrix,1)
    for j=1:size(matrix,2)
        ig = ig + abs(matrix(i,j));
    end
end
        
