%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Alexandre Zaghetto                               %
% zaghetto@unb.br                                  %
% University of Brasília                           %
% Department of Computer Science                   %
% Laboratory of Images, Signals and Acoustics      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reference Point Estimation.                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Prepare environment
clc;
clear all
close all

% Show results
verbose = 1;

% Debug
debug_code = 1;

A = 0;

% Orientation image
orientMAT = [];

% Counter
cont = 1;

% Allocation
imagem = zeros([240 336], 'uint8');
map = zeros([256 3], 'uint8');
M = 3.7;

% Select image folder
PATHNAME = uigetdir([], 'Select image folder');
imgs = dir(PATHNAME);

% Mumber of images
Nimg = length(imgs);

% Process each image
for i=3:Nimg
    
    % Open fingerprint
    fingerprint = imread([PATHNAME '\' imgs(i).name]);
            
    % Direction image
    blksize = 16;
    [orientim, mask, freq, newim, binim] = extractDirecional(fingerprint, blksize);
    
    % Image height and width
    [imgheight, imgwidth] = size(orientim);
    
    % Crop limits
    PercentBorder = 0.07;
    Borderx = floor(PercentBorder*imgwidth);
    Bordery = floor(PercentBorder*imgheight);
    
    % Crop image
    imgCrop = fingerprint(Bordery:(imgheight-Bordery), Borderx:(imgwidth-Borderx));
    
    % If debug show cropped image
    if debug_code
        figure;
        imshow(imgCrop);
        pause(1.0)
        title('Original Cropped Image')
    end
    
    % Cropped orientation image
    orientimCrop = orientim(Bordery:(imgheight-Bordery), Borderx:(imgwidth-Borderx));
    
    % Cropped binary image    
    binimCrop = binim(Bordery:(imgheight-Bordery), Borderx:(imgwidth-Borderx));
    
    % Binarized image + orientation
    if debug_code
        figure;
        imshow(binimCrop);              
        hold on
        plotridgeorient(orientimCrop, 16, binimCrop);
        title('Orientations')  
    end
            
    % Erode mask
    NHOOD = ones(55,55);
    [lmask, cmask] = size(mask);
    
    mask(1:15,:) = 0;
    mask(:,1:15) = 0;
    mask(lmask-15:lmask,:) = 0;
        
    mask = imerode(mask,NHOOD);
                
    % Cropped mask
    maskCrop = mask(Bordery:(imgheight-Bordery), Borderx:(imgwidth-Borderx));
    
    if debug_code
        figure;
        imshow(maskCrop);
        pause(1.0)
        title('Eroded Cropped Mask')
    end
        
    % Apply sin on orientimCrop and generate E
    E = sin(orientimCrop);
    
    if debug_code
        figure;
        imshow(maskCrop.*E);
        pause(1.0)
        title('E = sin(Orientations)')
    end
    
    % Apply gradient on E and generate M
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
    
    % Debug
    if debug_code
        figure;
        imshow(maskCrop.*M)
        title('M = Gradient(E)')
    end
    
    % Apply gradient on M and Generate M filtered
    M = round(255*M/max(max(M)));
    pause(1.0)
    
    % Gradiente em A
    [l, c] = size(E);
    for k=2:l-1
        for j=2:c-1
            Gx = (M(k+1, j-1)+2*M(k+1, j)+M(k+1,j+1))-(M(k-1, j-1)+2*M(k-1, j)+M(k-1,j+1));
            Gy = (M(k+1, j+1)+2*M(k, j+1)+M(k-1,j+1))-(M(k+1, j-1)+2*M(k, j-1)+M(k-1,j-1));
            Mfilter(k,j) = sqrt(Gx^2 + Gy^2);
        end
    end
    
    Mfilter(l,:)=0;
    Mfilter(:,c)=0;
    
    Mfilter = M;
    
    Mfilter = round(255*Mfilter/max(max(Mfilter)));
    
    H = fspecial('sobel');
    Mfilter = round(imfilter(M,H));
    
    if debug_code
        figure
        imshow(uint8(maskCrop.*Mfilter));
        title('Mfiltered = Gradient(M)')
    end
    
    % Threshold   
    Thr = 140;
    
    % Limiarização para detectar a referência
    Mbin = Mfilter.*maskCrop > Thr;
    
    if debug_code
        figure;
        imshow(Mbin);
        title('Mbin = Binarize(Mfilter)');
    end
    
    % Integra as direções
    A = integratePixels(E);
    
    % Determina as coordenadas da referência
    [CandRefi,CandRefj] = find(Mbin == 1);
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % If there are no candidates %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if isempty(CandRefi)
        
        % Take the center of the image
        
        
    else
        
        % Select the best candidate
        
        
    end    
    
    cont = cont+1;
    
    keyboard
    
end


imwrite(Mbin, 'Mfilter.png');
imwrite(Mbin, 'Mbin.png');

save main_referencePoints.mat






