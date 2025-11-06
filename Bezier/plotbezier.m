function p = plotbezier(B,t,c)
% Opis:
% plotbezier nariše Bezierjevo krivuljo za dane kontrolne točke in
% seznam parametrov
%
% Definicija:
% p = plotbezier(B,t,c)
%
% Vhodni podatki:
% B matrika velikosti n+1 x d, ki predstavlja kontrolne točke
% Bezierjeve krivulje stopnje n v d-dimenzionalnem prostoru,
% t seznam parametrov dolžine k, pri katerih računamo vrednost
% Bezierjeve krivulje,
% c opcijski parameter, ki določa barvo krivulje
%
% Izhodni podatek:
% p grafični objekt, ki določa krivuljo

P = bezier(B,t);

% Default color
defaultColor = 'b';

% Check if a color has been provided in varargin
if nargin > 2
    color = c;  % Get the color from the input
else
    color = defaultColor;  % Use the default color
end


if size(B,2) == 2
    hold on
    % plot(B(:,1),B(:,2),'k');
    % plot(B(:,1),B(:,2),'.','MarkerSize',15,'Color', color);
    p = plot(P(:,1),P(:,2),'Color', color, 'LineWidth',2);
    hold off
else
    hold on
    plot3(B(:,1),B(:,2),B(:,3),'k');
    plot3(B(:,1),B(:,2),B(:,3),'.','MarkerSize',15,'Color', color);
    p = plot3(P(:,1),P(:,2),P(:,3),'Color', color, 'LineWidth',2);
    hold off
end
hold off

end

% check ginput