function BS = beziersub(B,t,k)
% Opis:
% beziersub izvede subdivizijo Bezierjeve krivulje
%
% Definicija:
% BS = beziersub(B,t)
%
% Vhodni podatki:
% B matrika kontrolnih točk Bezierjeve krivulje, v kateri
% vsaka vrstica predstavlja eno kontrolno točko,
% t parameter subdivizije Bezierjeve krivulje
%
% Izhodni podatek:
% BS celica, ki vsebuje kontrolne točke dveh krivulj, ki jih
% dobimo s subdivizijo prvotne Bezierjeve krivulje

if nargin == 2
    k = 1;
end

[n, m] = size(B);

B1 = zeros(n,m);
B2 = zeros(n,m);

for i = 1 : m
    D = decasteljau(B(:, i),t);
    B1(:, i) = D(1, :)';
    B2(:, i) = diag(flip(D,2));

    if k==1
        BS = cell(1,2);
        BS{1} = B1;
        BS{2} = B2;
    elseif k>1
        BS1 = beziersub(B1, t, k-1);
        BS2 = beziersub(B2, t, k-1);
        BS = [BS1 BS2];
    end
end

end