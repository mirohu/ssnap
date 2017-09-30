function mat = makecircle(mat) %accepts as input a square matrix and returns a circle

tf = isequal([length(mat) length(mat)],size(mat));
abortmsg = 'Cannot be made into circle. Program aborted';
imageSize = size(mat);

if tf == 0
    disp(abortmsg);
elseif mod(length(mat),2) == 0
    disp(abortmsg);
else
    ceix = round(length(mat)/2); %the center element index is the middle element in the array
    ci = [ceix, ceix, length(mat)/2];
    [xx,yy] = ndgrid((1:imageSize(1))-ci(1),(1:imageSize(2))-ci(2));
    mask = (xx.^2 + yy.^2)<ci(3)^2;
    mat = mask .* mat;   
end

