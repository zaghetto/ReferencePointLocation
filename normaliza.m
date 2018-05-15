% NORMALIZA - Normaliza os valores da imagem para media 0 e desvio padrao 1

function n = normaliza(im)

    % Verifica se a imagem foi convertida de uint8 para double.
    % Em caso negativo realiza a conversao.
	if ~isa(im,'double')
        im = double(im); 
	end	
    
    % Normaliza para media zero e desvio padrao unitario
	n = im - mean(im(:));    
	n = n/std(im(:));    
    
return
