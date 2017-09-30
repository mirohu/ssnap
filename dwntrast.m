function matrix =  dwntrast(matrix, Goal_Percent_SD)


a = 0.5 - (Goal_Percent_SD/2);
b = 0.5 + (Goal_Percent_SD/2);
matrix = (b-a).*matrix + a;


%sig(matrix)