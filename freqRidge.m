%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Alexandre Zaghetto                               %
% zaghetto@unb.br                                  %
% University of Brasília                           %
% Department of Computer Science                   %
% Laboratory of Images, Signals and Acoustics      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reference Point Estimation.                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [freq, medianfreq] = fredRidge(im, mask, orient, blksze)

% Determina as dimensoes da imagem
[rows, cols] = size(im);

% Cria uma matriz zerada com as dimensoes de im
freq = zeros(size(im));

% Faz um processamento bloco a bloco, determinando para cada subbloco a
% frequencia de franjas
for r = 1:blksze:rows-blksze
    for c = 1:blksze:cols-blksze
        
        % Seleciona o sub-bloco a ser trabalhado
        blkim = im(r:r+blksze-1, c:c+blksze-1);
        
        % Seleciona o sub-bloco de orientaçao equivalente
        blkor = orient(r:r+blksze-1, c:c+blksze-1);
        
        % Estima a frequencia de franjas no sub-bloco por meio da funçao
        % freqest e armazena a estimativa no sub-bloco correspondente de
        % freq
        freq(r:r+blksze-1,c:c+blksze-1) = freqest(blkim, blkor);
        
    end
end

% Marca as regioes de freq onde nao ha franjas
freq = freq.*mask;

% Calcula-se a frequencia mediana, considerando-se as regioes validas da
% imagem, ou seja, onde a frequencia e maior que zero
medianfreq = median(freq(find(freq>0)));

return