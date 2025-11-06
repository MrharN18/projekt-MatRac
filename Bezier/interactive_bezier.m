function interactive_bezier
    % Initialize
    f = figure('Name','Draggable Bezier','NumberTitle','off');
    axis([-0.5 1.5 -0.5 1.5]); hold on; grid on;
    title('Click to place control points (Right-click or Enter when done)');

    B = [0,0];
    but = 1;
    t = linspace(0,1,200);

    hOldPoints = gobjects(size(B,1),1);

    hOldPoints(1) = plot(0,0,'bo','MarkerFaceColor','b','MarkerSize',8);
    hOldPoints(end+1) = plot(1,0,'bo','MarkerFaceColor','b','MarkerSize',8);

    % Step 1 — Pick control points
    while but == 1
        [x,y,but] = ginput(1);
        if isempty(x) || isempty(y)
            break;
        end
        hOldPoints(end+1) = plot(x,y,'bo','MarkerFaceColor','b','MarkerSize',8);
        B = [B; x,y];
    end
    if isempty(B), return; end

    

    % Remove the old points after input
    if ~isempty(hOldPoints)
        delete(hOldPoints);
    end

    B(end+1,:) = [1,0];

    % Step 2 — Draw initial Bezier curve
    curvePlot = plotbezier(B,t);
    hold on;
    ctrlPlot = plot(B(:,1), B(:,2), 'bo--','LineWidth',1.5);

    % Step 3 — Scatter points for interaction
    hPts = scatter(B(2:end-1,1), B(2:end-1,2), 100, 'b', 'filled', 'ButtonDownFcn', @startDrag);

    % Store dragging info in figure
    guidata(f, struct('B',B, 'idx', [], 't', t));

    % Step 4 — Key press callback for Enter
    set(f,'WindowKeyPressFcn',@keyPress);

    uiwait(f);  % Keep figure interactive

    % --- Nested functions -----------------------------------------------

    function startDrag(src, ~)
        draggable = 2:size(B,1)-1;
        
        % Determine which point was clicked
        pt = get(gca,'CurrentPoint');
        pt = pt(1,1:2);
        data = guidata(f);
                
        % Compute distances only to draggable points
        dists = sqrt(sum((data.B(draggable,:) - pt).^2,2));
        [~, idx] = min(dists);

        data.idx = draggable(idx);  % global index in B
        guidata(f,data);

        % Set motion and release callbacks
        set(f,'WindowButtonMotionFcn', @dragging);
        set(f,'WindowButtonUpFcn', @stopDrag);
    end

    function dragging(~,~)
        data = guidata(f);
        idx = data.idx;
        if isempty(idx), return; end

        % Update position of dragged point
        pt = get(gca,'CurrentPoint');
        data.B(idx,:) = pt(1,1:2);

        % Update scatter and polygon
        hPts.XData = data.B(:,1);
        hPts.YData = data.B(:,2);
        set(ctrlPlot,'XData',data.B(:,1),'YData',data.B(:,2));

        % Update Bezier curve
        xy = bezier(data.B,t);
        set(curvePlot,'XData',xy(:,1),'YData',xy(:,2));
       
        guidata(f, data);
        drawnow
    end

    function stopDrag(~,~)
        % Stop dragging
        data = guidata(f);
        data.idx = [];
        guidata(f,data);
        set(f,'WindowButtonMotionFcn','');
        set(f,'WindowButtonUpFcn','');
    end

    function keyPress(~,event)
        if strcmp(event.Key,'return')  % Enter pressed
            data = guidata(f);
            xy = bezier(data.B,data.t);  % evaluated curve
            % Save to MAT file (can also change to JSON if desired)
            save('bezier_curve.mat','data','xy');
            disp('Curve saved to bezier_curve.mat');
            uiresume(f);  % stop uiwait and return
        end
    end
end