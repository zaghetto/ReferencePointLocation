function [orientim] = orientfranja(im)
    
    % Carrega os filtros gaussianos Input.f1 (e gradientes Input.f1x e Input.f1y), Input.f2 e Input.f3;
    Input = coder.load ('orientfiltros.mat', 'f1', 'f1x', 'f1y', 'f2', 'f3');
    
    % Filtra a imagem com o gradiente do filtro Input.f1 em x, ou seja, Input.f1x
    Gx = filter2(Input.f1x, im, 'same'); % Gradient da imagem em x
    
    % Filtra a imagem com o gradiente do filtro Input.f1 em y, ou seja, Input.f1y
    Gy = filter2(Input.f1y, im, 'same'); % Gradient da imagem em y
    
    % Estimate the local orientation of each block by finding the axis
    % orientation that minimises the area moment.
   
    Gxx = Gx.^2;       % Momentos
    Gxy = Gx.*Gy;
    Gyy = Gy.^2;
    
    % Filtra Gxx, Gxy e Gyy com o filtro gaussiano 2
    Gxx = filter2(Input.f2, Gxx);  % Momentos suavizados
    Gxy = 2*filter2(Input.f2, Gxy);
    Gyy = filter2(Input.f2, Gyy);
    
    % Determina sin2theta e cos2theta
    denom = sqrt(Gxy.^2 + (Gxx - Gyy).^2);
    sin2theta = Gxy./denom;            
    cos2theta = (Gxx-Gyy)./denom;
    
    % Filtra sin2theta e cos2theta com o filtro gaussiano 3
    cos2theta = filter2(Input.f3, cos2theta); % Senos e cossenos do dobro do angulo suavizados
    sin2theta = filter2(Input.f3, sin2theta); 
    
    % Determina a orientaçao a partir de sin2thera e cos2theta
    orientim = pi/2 + atan2(sin2theta,cos2theta)/2;
    
return