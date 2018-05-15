%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Alexandre Zaghetto                               %
% zaghetto@unb.br                                  %
% University of Brasília                           %
% Department of Computer Science                   %
% Laboratory of Images, Signals and Acoustics      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reference Point Estimation.                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [normim, mask, maskind] = segmentafranja(im, blksze)
    
    % Determina o limiar de corte para geraçao da mascara
    thresh = 0.1;        
      
    % Normaliza a imagem para que tenha media 0 e desvio padrao 1
    im = normaliza(im);

    % Gera uma imagem onde cada elemento de um sub-bloco de dimensoes blksze eh substituido
    % pelo desvio padrao do sub-bloco
    desvpadrim = stddvim(im, blksze);
    
    % Gera uma mascara para identificar as regioes onde o desvio padrao
    % local e inferior a um determinado limiar
    mask = desvpadrim  > thresh;

    % Identifica os indices onde a mascara é 1
    maskind = find(mask);
       
    % Com o auxilio da mascara, renormaliza apenas as regioes onde ha
    % franjas para media 0 e desvio padrao 1
    im = im - mean(im(maskind));
    normim = im/std(im(maskind));
                
return
    
