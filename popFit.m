function popsFit = popFit(yearsX, popsY)
    global DRAW_GRAPH;
    [yearsX, popsY] = initForFit(yearsX, popsY);
    
    % get start point
    [xm, x0, r] = logistic(yearsX, popsY);
    if xm > x0
        startPoint = [xm, x0, r];
        funcExpr = 'maxPop / (1 + (maxPop / minPop) * exp(-r * (year - 1950)))';
    else
        [x0, r] = malthus(yearsX, popsY);
        startPoint = [x0, r];
        funcExpr = 'minPop * exp(r * (year - 1950))';
    end
    
    % draw picture
    popFunc = fittype(funcExpr,'independent','year','dependent','population');
    popsFit = fit(yearsX, popsY, popFunc, 'Startpoint',startPoint)
    
    if DRAW_GRAPH
        clf;
        xlim([1950, 2065]);
        plot(popsFit, 'fit', 0.95);
        hold on,
        plot(yearsX, popsY, '*');
    end
end

function [x0, r] = malthus(yearsX, popsY)
    y = log(popsY);
    spFunc = polyfit(yearsX-1950, y, 1);
    r = spFunc(1);
    x0 = exp(spFunc(2));
end

function [xm, x0, r] = logistic(yearsX, popsY)
    dataSize = size(yearsX, 1);
    yearGap = yearsX(2) - yearsX(1);
    lastPop = popsY(1:dataSize-1);
    nextPop = popsY(2:dataSize);
    deltaPop = (nextPop - lastPop) ./ nextPop ./ yearGap;
    spFunc = polyfit(nextPop, deltaPop, 1);
    r = spFunc(2);
    xm = -r/spFunc(1);
    x0 = min(popsY(1));
end
