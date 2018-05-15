function newim = filterRidge(im, orient, freq, medfreq, mask)

    % Determina kx e ky, fatores de escala que especificam o sigma do
    % filtro.
    kx = 0.5;
    ky = 0.5;
    
    debug=0;
    
    % Incremento fixo do angulo do filtro em graus.
    angleInc = 3;  
    
   % Verifica se a imagem foi convertida de uint8 para double.
    % Em caso negativo realiza a conversao.
	if ~isa(im,'double')
        im = double(im); 
    end	
    
    % Determina as dimensoes da imagem.
    [rows, cols] = size(im);
    
    % Gera filtros correspondentes as diferentes orientaçoes em incrementos
    % de 'angleInc' graus
    filter = cell(1,180/angleInc);
       
    % Determina sigmax e sigmay
    sigmax = 1/medfreq*kx;
    sigmay = 1/medfreq*ky;

    % Determina o tamanho do filtro
    sze = round(3*max(sigmax,sigmay));
      
    % Gera valores para serem substituidos no filtro
    [x,y] = meshgrid(-sze:sze);
    
    % Determina a dimensao do filtro
    DimFiltro = length(x);
    
    % Insere linhas e colunas com o nivel de cinza do fundo
    % na imagem original, preparando-a para a filtragem
    ImagemN = max(max(im))*ones(rows+2*sze, cols+2*sze);
    ImagemN(sze+1:rows+sze,sze+1:cols+sze)  = im;  
    
    % Cria uma nova imagem zerada, onde sera armazenada a imagem filtrada
    newim = zeros(rows, cols);
    
    % Gera o filtro de referencia
    reffilter = exp(-(x.^2/sigmax^2 + y.^2/sigmay^2)/2).*cos(2*pi*medfreq*x);
    
  
        % Generate rotated versions of the filter.  Note orientation
        % image provides orientation *along* the ridges, hence +90
        % degrees, and imrotate requires angles +ve anticlockwise, hence
        % the minus sign.
        for o = 1:180/angleInc
            filter{o} = imrotate(reffilter,-(o*angleInc+90),'bilinear','crop'); 
        end
      
    % Determina o maximo indice do banco de filtros (serao 180/angleInc filtros)
    maxorientindex = round(180/angleInc);
    
    % Converte os angulos de orient para graus e constroi, dividido cada termo por angleInc,
    % uma matriz de indices, onde cada posiçao contem um indice que deve ser utilizado
    % para buscar um filtro no banco de filtros.
    orientdeg = (180*orient/pi);
    orientindex = round(orientdeg/angleInc);
    
if debug
    for i=1:rows
        for j=1:cols
            orientdeg(i,j)
            imshow(filter{(orientindex(i,j))})
            pause
        end
    end 
end
    
    % Encontra os indices zero (indicam zero grau)
    i = find(orientindex < 1);
    
    % Torna os indices zero (indicam zero grau) iguais aos 60 (indicam 180 graus)
    orientindex(i) = orientindex(i)+maxorientindex;
    
    % Encontra os indices superiores a 60
    i = find(orientindex > maxorientindex); 
    
    % Torna os indices superiores a 60 iguais a eles menos-60
    orientindex(i) = orientindex(i)-maxorientindex; 

    % Finalmente a filtragem  
      
for r = sze+1:rows+sze
    for c = sze+1:cols+sze
        if freq(r-sze,c-sze) ~= 0
              newim(r-sze,c-sze) = sum(sum(  ImagemN(r-sze:r+sze,c-sze:c+sze)  .*filter{orientindex(r-sze,c-sze)}   ) );
          end
      end   
  end
  
return