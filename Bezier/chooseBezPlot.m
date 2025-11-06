but = 1;
B = [];
i = 1;
t = linspace(0,1);

while but == 1
    hold on;
    axis([-10 10 -10 10]);
    [x,y,but] = ginput(1);
    plot(x,y,'b.','MarkerSize',15);
    B(i,:) = [x,y];
    i = i + 1;
end

plotbezier(B,t)
