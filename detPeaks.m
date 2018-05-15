function [indpicos, pico, npicos] = detPeaks(proj);

% Funçao que determina a posiçao dos picos de um vetor

% Aredonda os valores em proj
% proj = round(proj);

% Determina o comprimento do vetor proj
compr = length(proj);

% Cria um vetor com duas posiçoes a mais, uma no inicio e outra no fim,
% contendo o valor 0
novaproj = zeros(compr+2);
novaproj(2:compr+1) = proj;


% Define um contador
k = 1;

% Inicializa as variaveis com zero
indpicos = 0;
pico = 0;

for i=2:compr+1
    if (novaproj(i) > novaproj(i-1)) & (novaproj(i) > novaproj(i+1))
        indpicos(k) = i-1;
        pico(k) = novaproj(i);
        k = k+1;
        hapicos = 1;
    end
end

% Determina a quantidade de picos encontrados
npicos = length(indpicos);

return
