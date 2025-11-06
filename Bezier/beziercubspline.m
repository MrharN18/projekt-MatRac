function B = beziercubspline(u,D)
% Opis:
% beziercubspline izračuna sestavljeno Bezierjevo krivuljo stopnje 3,
% ki je dvakrat zvezno odvedljiva v stikih
%
% Definicija:
% B = beziercubspline(u,D)
%
% Vhodna podatka:
% u seznam parametrov delitve dolžine m+1,
% D matrika, v kateri vsaka izmed m+3 vrstic predstavlja eno
% kontrolno točko sestavljene krivulje
%
% Izhodni podatek:
% B celični seznam dolžine m, v kateri je vsak element matrika
% s štirimi vrsticami, ki določajo kontrolne točke kosa
% sestavljene krivulje

m = length(u) - 1;
n = size(D,2);
B = cell(1,m);
for i=1:m
    B{i} = zeros(4,n);
end

B{1}(1,:) = D(1,:); 
B{1}(2,:) = D(2,:); 
B{1}(3,:) = diff(u(2:3))/(diff(u(1:2)) + diff(u(2:3))) .* D(2,:) + diff(u(1:2))/(diff(u(1:2)) + diff(u(2:3))) .* D(3,:);

for i=1:m-2
    B{i+1}(2,:) = (diff(u(i+1:i+2)) + diff(u(i+2:i+3)))/(diff(u(i:i+1)) + diff(u(i+1:i+2)) + diff(u(i+2:i+3))) .* D(i+2,:) +  diff(u(i:i+1))/(diff(u(i:i+1)) + diff(u(i+1:i+2)) + diff(u(i+2:i+3))) .* D(i+3,:);
    B{i+1}(3,:) = diff(u(i+2:i+3))/(diff(u(i:i+1)) + diff(u(i+1:i+2)) + diff(u(i+2:i+3))) .* D(i+2,:) + (diff(u(i:i+1)) + diff(u(i+1:i+2)))/(diff(u(i:i+1)) + diff(u(i+1:i+2)) + diff(u(i+2:i+3))) .* D(i+3,:);
end

B{end}(end,:) = D(end,:); 
B{end}(end-1,:) = D(end-1,:); 
B{end}(end-2,:) = diff(u(end-1:end))/(diff(u(end-2:end-1)) + diff(u(end-1:end))) .* D(end-2,:) + diff(u(end-2:end-1))/(diff(u(end-2:end-1)) + diff(u(end-1:end))) .* D(end-1,:);

for i=1:m-1
    B{i}(4,:) = diff(u(i+1:i+2))/(diff(u(i:i+1)) + diff(u(i+1:i+2))) .* B{i}(3,:) + diff(u(i:i+1))/(diff(u(i:i+1)) + diff(u(i+1:i+2))) .* B{i+1}(2,:);
    B{i+1}(1,:) = diff(u(i+1:i+2))/(diff(u(i:i+1)) + diff(u(i+1:i+2))).*B{i}(3,:) + diff(u(i:i+1))/(diff(u(i:i+1)) + diff(u(i+1:i+2))).*B{i+1}(2,:);
end

end