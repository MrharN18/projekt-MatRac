function [db, dB] = bezierder(B,r,t)
% Opis:
% bezierder vrne točke na krivulji, ki predstavlja odvod dane
% Bezierjeve krivulje
%
% Definicija:
% db = bezierder(B,r,t)
%
% Vhodni podatki:
% B matrika kontrolnih točk Bezierjeve krivulje, v kateri vsaka
% vrstica predstavlja eno kontrolno točko,
% r stopnja odvoda, ki ga računamo,
% t seznam parameterov, pri katerih računamo odvod
%
% Izhodni podatek:
% db matrika, v kateri vsaka vrstica predstavlja točko r-tega
% odvoda pri istoležnem parametru iz seznama t

n = size(B, 1) - 1;
m = size(B, 2);
db = zeros(length(t), m);

if nargout == 1
    for i = 1 : length(t)
        for j = 1 : m
            D = decasteljau(B(:, j), t(i));
            df = diff(D(:, n-r+1), r);
            db(i,j) = factorial(n) / factorial(n-r) * df(1);
        end
    end
else
    dB = factorial(n) / factorial(n-r) * diff(B, r);
    db = bezier(dB, t);
end

