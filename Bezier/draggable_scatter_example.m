function draggable_scatter_example
    figure;
    axis([0 10 0 10]); hold on;
    B = [2 3; 5 5; 7 2];  % example points
    t = linspace(0,1,200);

    % Scatter points
    hScatter = scatter(B(:,1), B(:,2), 100, 'b', 'filled');

    % Initial Bézier curve
    hCurve = plot_bezier(B,t);

    % Store dragging info
    dragging.idx = [];
    guidata(gcf, dragging);  % store in figure

    % Set ButtonDownFcn for each point
    hScatter.ButtonDownFcn = @(src,event) startDrag(src, event, hScatter, hCurve, B, t);
end

function startDrag(src, ~, hScatter, hCurve, B, t)
    % Which point was clicked? (find closest)
    pt = get(gca,'CurrentPoint');
    pt = pt(1,1:2);
    dists = sqrt((B(:,1)-pt(1)).^2 + (B(:,2)-pt(2)).^2);
    [~, idx] = min(dists);

    % Store the index in figure guidata
    dragging.idx = idx;
    guidata(gcf, dragging);

    % Set motion and release callbacks
    set(gcf,'WindowButtonMotionFcn', @(src,event) draggingFcn(src,event,hScatter,hCurve,B,t));
    set(gcf,'WindowButtonUpFcn', @(src,event) stopDrag(src,event));
end

function draggingFcn(~,~,hScatter,hCurve,B,t)
    dragging = guidata(gcf);
    idx = dragging.idx;
    if isempty(idx), return; end

    % Update point position
    pt = get(gca,'CurrentPoint');
    B(idx,:) = pt(1,1:2);

    % Update scatter
    hScatter.XData = B(:,1);
    hScatter.YData = B(:,2);

    % Update Bézier curve
    xy = bezier_eval(B,t);
    hCurve.XData = xy(:,1);
    hCurve.YData = xy(:,2);
    drawnow
end

function stopDrag(~,~)
    dragging = guidata(gcf);
    dragging.idx = [];
    guidata(gcf, dragging);
    set(gcf,'WindowButtonMotionFcn','');
    set(gcf,'WindowButtonUpFcn','');
end

function h = plot_bezier(B,t)
    xy = bezier_eval(B,t);
    h = plot(xy(:,1), xy(:,2), 'r-','LineWidth',2);
end

function xy = bezier_eval(B,t)
    n = size(B,1)-1;
    xy = zeros(length(t),2);
    for i = 0:n
        bin = nchoosek(n,i)*(1-t).^(n-i).*t.^i;
        xy = xy + bin'*B(i+1,:);
    end
end

