%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Alexandre Zaghetto                               %
% zaghetto@unb.br                                  %
% University of Brasília                           %
% Department of Computer Science                   %
% Laboratory of Images, Signals and Acoustics      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reference Point Estimation.                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [orientim, mask, freq, newim, binim] = extractDirecional(fingerprint, blksze);

    % Normaliza a imagem
    [normim, mask] = segmentRidge(fingerprint, blksze);

    % Determinar a orientacao
    orientim = orientfranja(normim);  
    
    % Ridge Frequency    
    [freq, medfreq] = freqRidge(normim, mask, orientim, blksze);
    freq = medfreq.*mask;

    % Apply filter
    newim = filterRidge(normim, orientim, freq, medfreq, mask);
    
    % Binarize image
    binim = newim > -1;
        
return
        
        