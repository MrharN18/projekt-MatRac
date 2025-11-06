function Be = bezierelv(B,k)
% Opis:
% bezierelv izvede višanje stopnje dane Bezierjeve krivulje
%
% Definicija:
% Be = bezierelv(B,k)
%
% Vhodna podatka:
% B matrika velikosti (n+1) x d, v kateri vsaka vrstica
% predstavlja d-dimenzionalno kontrolno točko Bezierjeve
% krivulje stopnje n,
% k število, ki določa, za koliko želimo zvišati stopnjo
% dane Bezierjeve krivulje
%
% Izhodni podatek:
% Be matrika velikosti (n+k+1) x d, v kateri vsaka vrstica
% predstavlja d-dimenzionalno kontrolno točko Bezierjeve
% krvulje stopnje n+k, ki ustreza dani Bezierjevi krivulji

n = size(B,1); m = size(B,2);
Be = zeros(n+k,m);

for d = 1:m
    b = zeros(n+k,k+1); b(1:n,1) = B(:,d);

    for i=1:k
        b(1,i+1) = b(1,i);
        for j=2:n+i-1
            b(j,i+1) = (1 - (j-1)/(n+i-1))*b(j,i) + ((j-1)/(n+i-1))*b(j-1,i);
        end
        b(n+i,i+1) = b(n+i-1,i);
    end

    Be(:,d) = b(:,end);

end

end