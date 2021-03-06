
function freqim =  freqest(img, ort, debug)

% Pameters for block processing
image = img.data;
startInd = img.location;
endInd = img.location + img.blockSize-1;

orientation = ort(startInd(1):endInd(1), startInd(2):endInd(2));

% Define constants
minWaveLength = 5;
maxWaveLength = 15;

% Image size
[rows,cols] = size(image);

% Find the average orientation of the block. 

% Filter angles
orientation = 2*orientation;
cosorient = mean2(cos(orientation));
sinorient = mean2(sin(orientation));

% Filter angles
orient = atan2(sinorient,cosorient)/2;

% Rotate image orient ridges vertically
rotimCrop = imrotate(image,90+orient/pi*180,'bicubic','crop');

% Crop image to eliminate artifacts due to rotation
% cropsze = fix(rows/sqrt(2)); 
% offset = fix((rows-cropsze)/2);
% rotimCrop = rotim(offset:offset+cropsze, offset:offset+cropsze);
% 
% size(image)

% rotimCrop = rotim;

% Sum colums to obtain a vertical projection 
proj = sum(rotimCrop);

% Find maxima
[indpicos, pico, npicos] = findMaxima(proj);

% Find spacial frequency by dividing the distance between the first and the
% last maximum divided by the number os maxima. If one or no maxima is
% found, frequency is set to 0.

if npicos < 2
    freqim = zeros(size(image));      
else
    waveLength = (max(indpicos)-min(indpicos))/(npicos-1);
    if waveLength > minWaveLength & waveLength < maxWaveLength
        freqim = 1/waveLength * ones(size(image));
    else
        freqim = zeros(size(image));
    end
end


% Debug
if debug
    subplot(2,2,1)
    imshow(rotimCrop)
    title('Sub-bloco rotacionado')
    hold
    subplot(2,2,2)
    stem(proj)
    title('Soma das linhas')
    subplot(2,2,3)
    stem(indpicos, pico)
    title([num2str(npicos) ' Maximos | Freq = ' num2str(freqim)])    
    pause(0.1)
end



return
    