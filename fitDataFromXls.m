function fitDataFromXls(sheetName, fitHandle)
    global regionList;
    data = xlsread("data.xlsx", sheetName);
    dataSize = size(data, 1);

    % load year axis
    years = data(1,:);

    % load year axis
    for regionNo = 2:dataSize
        regionDatas = data(regionNo, :);
        fitLine = fitHandle(years, regionDatas); 
%         pause(0.3);
        if (sheetName == "pop")
            regionList{regionNo - 1}.popsFitLine = fitLine;
        elseif (sheetName == "gdp")
            regionList{regionNo - 1}.gdpsFitLine = fitLine;
        end
    end
end