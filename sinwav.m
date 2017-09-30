function [Z, O] = sinwav(pixels, nOscillations, orientation, pShift)

O = nOscillations * (2 * pi /pixels); %how many times you want wave to oscillate in x-dir


xdomain = 1:pixels;


[X,Y] = meshgrid(xdomain);

Z = sin((sin(deg2rad(orientation))*O*X + cos(deg2rad(orientation))*O*Y)+pShift);

%mesh(Z)