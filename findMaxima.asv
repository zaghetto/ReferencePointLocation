function [indMaximum, maximum, nMaxima] = findMaxima(proj);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Alexandre Zaghetto                               %
% zaghetto@unb.br                                  %
% University of Brasília                           %
% Department of Computer Science                   %
% Laboratory of Images, Signals and Acoustics      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Find local maxima                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Length of input vector
len = length(proj);

% Padding
newProj = zeros(1, len+2);
newProj(2:len+1) = proj;

% Counter
k = 1;

% Inicialize with 0
indMaximum = 0;
maximum = 0;

% Determine de places and values of maxima
for i=2:len+1
    if (newProj(i) > newProj(i-1)) & (newProj(i) > newProj(i+1))
        indMaximum(k) = i-1;
        maximum(k) = newProj(i);
        k = k+1;        
    end
end

% Number of maxima
nMaxima = length(indMaximum);


return
