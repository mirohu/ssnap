function ig = integr(mat)

ig = 0;
for i=1:size(mat,1)
    for j=1:size(mat,2)
        ig = ig + abs(mat(i,j));
    end
end
        