function gdpsFit = gdpFit(yearsX, gdpsY)
    global regionList;
    [yearsX, gdpsY] = initForFit(yearsX, gdpsY);
    gdpsFit = polyfit(yearsX, gdpsY, 2);
    
%     gdpsFitX = 1980:2065;
%     gdpsFitY = polyval(gdpsFit, gdpsFitX);
%     clf;
%     plot(yearsX, gdpsY, '*', gdpsFitX, gdpsFitY)
end