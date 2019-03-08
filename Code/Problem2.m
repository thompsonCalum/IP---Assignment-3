clear all
close all



im = imread('chromosome.TIF');
%im = imread('Fig1116(leg_bone).tif');
count = 1;
p = zeros(1,9);
% start = 1;
% scale = 1.1;
% trans = -20;
% rot = exp(j*(0.02));

% Calculate s(n)
[rows,cols] = find(im~=0);



contour = bwtraceboundary(im, [rows(1), cols(1)], 'N');

% contour = contour*rot;

% contour = contour*scale;

% Translation
% contour = contour + trans;

% contour(1) = contour(1) + trans;
% contour(2) = contour(2) + 0;


for i=1:128
    
    c(i) = contour(round(2),1) + j*contour(round(2), 2);
end

% C = fft(c);

% Subsample the boundary points so we have exactly 128, and put them into a
% complex number format (x + jy)
sampleFactor = length(contour)/128;
dist = 1;
for i=1:128
    c(i) = (contour(round(dist),2) + j*contour(round(dist),1));
    dist = dist + sampleFactor;
    
end

C = fft(c);

% C = C*scale;

% C(numel(C)) = C(numel(C)) + trans;

% C = C*rot;
% C(start) = C(start)*exp((-j*2*pi*start*c(start))/numel(C));

% Chop out some of the smaller coefficients (less than umax)
% umax = 32;
umax = 128; 
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