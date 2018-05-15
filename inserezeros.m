function [zeroIm, numBlocosL, numBlocosC] = inserezeros(imOrig, blksze)

% Funcao que, dadas a imagem original imOrig e a dimensao do sub-bloco
% blksze, insere zeros para que imagem contenha um numero inteiro de
% sub-blocos.

% Determina as dimensoes de imOrig
[L, C] = size(imOrig);

% Determina num inteiro de sub-blocos para a imagem
numBlocosL = ceil(L/blksze);
numBlocosC = ceil(C/blksze);

% Determina a nova dimensao para a imagem, baseando-se no numero de
% sub-bloco
numL = blksze*numBlocosL;
numC = blksze*numBlocosC;

% Cria uma imagem com a dimensao e a cor de fundo necessarios
zeroIm = max(max(imOrig))*ones(numL, numC);

% Insere a imOrig dentro de zeroIm
zeroIm(1:L, 1:C) = imOrig;

return

