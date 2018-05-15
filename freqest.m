
function freqim =  freqest(im, orientim)
    
    % Define constantes  
    debug = 0;
    windsze=5;
    minWaveLength=5;
    maxWaveLength = 15;
    
    % Determina a dimensao das imagens
    [rows,cols] = size(im);
    
    % Encontra a orientaçao media do bloco. Calcula-se a media dos senos e
    % cossenos do dobro dos angulos antes de se reconstruir o angulo
    % novamente.
    orientim = 2*orientim;    
    cosorient = mean2(cos(orientim));
    sinorient = mean2(sin(orientim));    
    orient = atan2(sinorient,cosorient)/2;

    % Rotaciona a imagem de maneira a tornar as franjas verticais
    rotim = imrotate(im,90+orient/pi*180);
    
    % Recorta a imagem para eliminar regioes invalidas geradas pela rotaçao
    cropsze = fix(rows/sqrt(2)); offset = fix((rows-cropsze)/2);
    rotim = rotim(offset:offset+cropsze, offset:offset+cropsze);
       
    % Sum down the columns to get a projection of the grey values down
    % the ridges.
    
    % Soma as colunas para obter um projeçao do sub-bloco na direçao x
     proj = sum(rotim);
    
    % Acha os picos de proj
     [indpicos, pico, npicos] = detPeaks(proj);
           
     if debug
     subplot(2,2,1)
     imshow(rotim)
     title('Sub-bloco rotacionado')
     hold
     subplot(2,2,2)
     stem(proj)
     title('Soma das linhas')
     subplot(2,2,3)
     stem(indpicos, pico)
     title('Maximos')
     pause
     end
           
    % Determina a frequencia espacial das franjas, dividindo a distancia
    % entro o primeiro e o ultimo pico pelo Numero de Picos-1. Caso nenhum pico
    % seja detectado, ou o comprimento de onda esteja fora dos limites
    % permitidos, a frequancia da imagem estimada como 0.
    if npicos < 2
	freqim = zeros(size(im));
    waveLength = 0;
    else
	waveLength = (indpicos(end)-indpicos(1))/(npicos-1);
	    if waveLength > minWaveLength & waveLength < maxWaveLength
	        freqim = 1/waveLength * ones(size(im));
        else
	        freqim = zeros(size(im));
        end
    end
    