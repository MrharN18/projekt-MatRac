function p = plotrbezier(B,w,t)

    P = rbezier(B,w,t);

    % farinove tocke
    q = w(1:end-1) ./ (w(1:end-1) + w(2:end)) .* B(1:end-1,:) + w(2:end) ./ (w(1:end-1) + w(2:end)) .* B(2:end,:);

    hold on
    if size(B,2) == 2
        plot(B(:,1),B(:,2),'k');
        plot(B(:,1),B(:,2),'.k','MarkerSize',15);
        scatter(q(:,1),q(:,2),'rsquare','filled')
        p = plot(P(:,1),P(:,2),'LineWidth',2);
    else
        plot3(B(:,1),B(:,2),B(:,3),'k');
        plot3(B(:,1),B(:,2),B(:,3),'.k','MarkerSize',15);
        scatter3(q(:,1),q(:,2),q(:,3),'rsquare','filled')
        p = plot3(P(:,1),P(:,2),P(:,3),'LineWidth',2);
    end

    hold off


end