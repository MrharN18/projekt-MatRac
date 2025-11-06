function b = power2bernstein(p)
% Opis:
% power2bernstein pretvori polinom, predstavljen s koeficienti v
% potenčni bazi, v polinom, predstavljen v Bernsteinovi bazi
%
% Definicija:
% b = power2bernstein(p)
%
% Vhodni podatek:
% p seznam koeficientov dolžine n+1, ki po vrsti pripadajo razvoju
% polinoma stopnje n v potenčni bazi od x^n do 1
%
% Izhodni podatek:
% b seznam koeficientov dolžine n+1, ki po vrsti pripadajo razvoju
% polinoma stopnje n v Bernsteinovi bazi od 0-tega do n-tega
% Bernsteinovega baznega polinoma

n = length(p) - 1;
b = zeros(1,n+1);

for i = 0:n
    for j = i:n
        b(j+1) = b(j+1) + (nchoosek(j,i)/nchoosek(n,i)) * p(n-i+1);
    end
end

% p(x) = p0*x^n + p1*x^(n-1) + ... + pn = b0*B_0^n(x + ... + bn*B_n^n(x)


