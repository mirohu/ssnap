function p = pic(mat,strtitle) %accepts a matrix and returns a picture


[avg1 max1 intg1] = metrica(mat);
[ssr1,snd1] = max(mat(:));
[ij1,ji1] = ind2sub(size(mat),snd1); 

maxstr1 = strcat('Maximum =  ',num2str(ssr1));
suppinf1 = strcat('Average = ',num2str(avg1),', Integral = ',num2str(intg1));

mesh(mat)
colormap jet
title(strtitle)
hold on
plot3(ji1,ij1,ssr1,'or')
hold off
text(ji1,ij1*1.3,ssr1*1.3,maxstr1)
text(-1000, 0, (-1/8)*ssr1, suppinf1)