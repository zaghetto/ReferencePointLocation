function [orientim, mask, freq, newim, binim] = extractDirecional(fingerprint, blksze);

    % Normaliza a imagem
    [normim, mask] = segmentRidge(fingerprint, blksze);

    % Determinar a orientacao
    orientim = orientfranja(normim);  
    
    % Ridge Frequency 
    blksze = 32;
    [freq, medfreq] = freqRidge(normim, mask, orientim, blksze);
    freq = medfreq.*mask;
    
    keyboard

    % Apply filter
    newim = filterRidge(normim, orientim, freq, medfreq, mask);
    
    % Binarize image
    binim = newim > -1;
        
return
        
        