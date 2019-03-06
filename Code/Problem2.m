clear all
close all

im = imread('chromosome.TIF');

count = 1;
p = zeros(1,9);

% Calculate s(n)
[rows,cols] = find(im~=0);

contour = bwtraceboundary(im, [rows(1), cols(1)], 'N');

for i=1:128
    c(i) = contour(round(2),1) + j*contour(round(2), 2);
end

C = fft(c);

% Subsample the boundary points so we have exactly 128, and put them into a
% complex number format (x + jy)
sampleFactor = length(contour)/128;
dist = 1;
for i=1:128
    c(i) = contour(round(dist),2) + j*contour(round(dist),1);
    dist = dist + sampleFactor;
end

C = fft(c);
% Chop out some of the smaller coefficients (less than umax)
% umax = 32;
umax = 8; 
Capprox = C;
for u=1:128
    if u > umax & u < 128-umax
        Capprox(u) = 0;
    end
end

% Take inverse fft
cApprox = ifft(Capprox);

% Show original boundary and approximated boundary
imshow(imcomplement(bwperim(im)));
hold on, plot(cApprox,'r');