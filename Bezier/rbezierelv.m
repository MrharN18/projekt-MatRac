function [Be,we] = rbezierelv(B,w)
% Opis:
% rbezierelv izvede višanje stopnje racionalne Bezierjeve krivulje
%
% Definicija:
% [Be,we] = rbezierelv(B,w)
%
% Vhodna podatka:
% B matrika velikosti n+1 x d, v kateri vsaka vrstica predstavlja
% d-dimenzionalno kontrolno točko racionalne Bezierjeve krivulje
% stopnje n,
% w seznam uteži racionalne Bezierjeve krivulje
%
% Izhodni podatek:
% Be matrika velikosti n+2 x d, v kateri vsaka vrstica predstavlja
% d-dimenzionalno kontrolno točko racionalne Bezierjeve krvulje
% stopnje n+1, ki ustreza dani racionalni Bezierjevi krivulji,
% we seznam dolžine n+2, v katerem vsak element predstavlja utež
% racionalne Bezierjeve krvulje stopnje n+1, ki ustreza dani
% racionalni Bezierjevi krivulji

bh = [w.*B,w];
Beh = bezierelv(bh,1);
we = Beh(:,end);
Be = Beh(:,1:end-1)./we;

end