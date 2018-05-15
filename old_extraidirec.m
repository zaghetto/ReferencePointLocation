% Imagens direcionais
%-------------------------
% Programa que, dado um grupo de fingerprints, extrai suas imagens
% direcionais

%clc;
%clear all
%close all

function extraidirec_2
coder.extrinsic('imread');
coder.extrinsic('imshow');

% Mostra resultados
verbose = 1;

% Debug
debug_code = 1;

A = 0;

% Numero de imagens
Nimg = 6; % 25

% Extrai as imagens direcionais
% -----------------------------
orientMAT = [];
conta = 1;

% Pré-alocação:
imagem = zeros([240 336], 'uint8');
map = zeros([256 3], 'uint8');
M = 3.7;

% Abre a imagem
for i=6:Nimg %i=1:Nimg
    
    if i<10        
        ind = ['0' num2strSpecial(i)];
    else
        ind = num2strSpecial(i);
    end
    
    [imagem,map]=imread(['images/' ind '.bmp']);
    
        img = imagem;
        
        % Prepara Imagem
        fingerprint = preparaim(img);

        
        % Utiliza o algoritmo de extração de minucias para gerar a imagem
        % direcional orietim
        [orientim, mask] = extraidirecional(fingerprint,16);
    
        % Determina a largura da borda
        [imgheight, imgwidth] = size(orientim);
    
        % Determina limietes para realizar Crop na imagem
        PercentBorda = 0.07;
        Bordax = floor(PercentBorda*imgwidth);
        Borday = floor(PercentBorda*imgheight);
    
        % Faz crop na imagem original
        imgCrop = img(Borday:(imgheight-Borday), Bordax:(imgwidth-Bordax));

        if debug_code
        figure(1);
        imshow(imgCrop);
        pause(1.0)
        end
          
        % Determina as direções das franjas com base na imagem binarizada já
        % com o Crop
        orientimCrop = orientim(Borday:(imgheight-Borday), Bordax:(imgwidth-Bordax)); 
%         hold on
%         s_orient = plotridgeorient(orientimCrop, 10);   
%         pause(1.0)
%         hold off
%     
        % Erode a máscara
    
        NHOOD = ones(55,55);
        [lmask, cmask] = size(mask);

        % imshow(mask);
        mask(1:15,:) = 0;
        mask(:,1:15) = 0;
        mask(lmask-15:lmask,:) = 0;
        mask(:,cmask-15:cmask) = 0;

%         figure
%         imshow(mask)
	
        mask = imerode(mask,NHOOD);
        
        % Faz o Crop da máscara
        maskCrop = mask(Borday:(imgheight-Borday), Bordax:(imgwidth-Bordax));
    
        if debug_code
        figure(2);
        imshow(maskCrop);    
        pause(1.0)		       
        end
        
        
        % Aplica o seno na imagem de direções
        E = sin(orientimCrop);
    
        if debug_code
        figure(3);
        imshow(maskCrop.*E);
        pause(1.0)
        end
        
        % Gradiente em A
        [l, c] = size(E);
        for k=2:l-1
            for j=2:c-1        
                Gx = (E(k+1, j-1)+2*E(k+1, j)+E(k+1,j+1))-(E(k-1, j-1)+2*E(k-1, j)+E(k-1,j+1));
                Gy = (E(k+1, j+1)+2*E(k, j+1)+E(k-1,j+1))-(E(k+1, j-1)+2*E(k, j-1)+E(k-1,j-1));
                M(k,j) = sqrt(Gx^2 + Gy^2);        
            end
        end
        
        M(l,:)=0;
        M(:,c)=0;
        
        if debug_code
        figure(4)
        imshow(maskCrop.*M)
        end
         
%         M = round(255*M/max(max(M)));
%         pause(1.0)
%         
%         % Gradiente em A
%         [l, c] = size(E);
%         for k=2:l-1
%             for j=2:c-1        
%                 Gx = (M(k+1, j-1)+2*M(k+1, j)+M(k+1,j+1))-(M(k-1, j-1)+2*M(k-1, j)+M(k-1,j+1));
%                 Gy = (M(k+1, j+1)+2*M(k, j+1)+M(k-1,j+1))-(M(k+1, j-1)+2*M(k, j-1)+M(k-1,j-1));
%                 Mfilter(k,j) = sqrt(Gx^2 + Gy^2);        
%             end
%         end
%         
%         Mfilter(l,:)=0;
%         Mfilter(:,c)=0;
%         
        Mfilter = M;
        
        Mfilter = round(255*Mfilter/max(max(Mfilter)));
                
        % H = fspecial('sobel');
        % Mfilter = round(imfilter(M,H));

        if debug_code
        figure(5)
        imshow(uint8(maskCrop.*Mfilter));
        end
    
        Limiar = 140;
    
        % Limiarização para detectar a referência
        Mbin = Mfilter.*maskCrop > Limiar;
    
        if debug_code
        figure(6);
        imshow(Mbin);
        end
        
        % Integra as direções
        % A = integrapix(E);
end %Nimg

end % Fim main
 
% save orient.mat orientMAT;