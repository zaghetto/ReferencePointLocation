function imagemstdv = stddvim(imagem, blksze);

coder.extrinsic('std2');

% Determina dimensoes da imagem
[L, C] = size(imagem);

% Ajusta a dimensao da imagem, inserindo zeros, de maneira a gerar um numero
% inteiro de sub-blocos de dimensao blksze
[ImagemN, numBlocosL, numBlocosC]  = inserezeros(imagem, blksze);

% Processa a imagem sub-bloco a sub-bloco, de blksze pixels, trocando os
% elementos do sub-bloco pelo desvio padrao do subbloco
for i=0:(numBlocosL-1)
    for j=0:(numBlocosC-1)
        LimL = (i*blksze+1):((i+1)*blksze);
        LimC = (j*blksze+1):((j+1)*blksze);
        desviopadrao = std2(ImagemN(LimL, LimC));
        vector1(i * numBlocosC + j + 1) = desviopadrao;
        ImagemN(LimL, LimC) = desviopadrao;
    end
end

% Retorna uma imagem com a mesma dimensao de imagem
imagemstdv = ImagemN(1:L, 1:C);


return