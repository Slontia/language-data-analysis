function readData()
    readMatData();
    createRegions();
end

function readMatData() % static
    global regionNum;

    % distance
    global distMat;
    global distW;
    distMat = getData("dist"); % read from xls
    distMat = symMat(distMat);              % remove NAN
    distMat = normalize(distMat, "lower", 500);  % normalize
    distMat = distMat .* distW;             % mul with weight 
    
    % absolute capable
    global absCapMat;
    global relDiffW;
    global eduW;
    
    % part I: relative language difficulty
    langFamis = getData("fami");
    relDiffMat = zeros(regionNum);
    for reg = 1 : regionNum
        fami = langFamis(reg);
        famRegs = (langFamis == fami);
        relDiffMat(reg, famRegs) = 1;
    end
    
    % part II: education
    eduMat = zeros(regionNum);
    
    absCapMat = relDiffMat * relDiffW + eduMat * eduW;
end

function mat = symMat(mat)
    [h, w] = size(mat);
    if h ~= w
        return
    end
    matSize = h;
    
    for i = 1:matSize
        for j = 1:matSize
            % remove NAN
            if isnan(mat(i, j))
               mat(i, j) = mat(j, i);
            end
        end
    end
end


function createRegions()
    initRegions();
    fitData();
    readStaticData();
end


function initRegions()
    global regionList;
    global regionNum;
    [digitData, textData] = getData("profile");
    [regionNum, ~] = size(digitData);
    regionList = cell(1, regionNum);
    for i = 1 : regionNum
        regionList{i} = Region(digitData, textData(i, 2), textData(i, 1));
    end
end

function fitData()
    fitDataFromXls("gdp", @gdpFit);
    fitDataFromXls("pop", @popFit);
    fprintf('over\n');
end

function readStaticData()
    global regionList;
    global regionNum;
    
    % migrProp
    migrNum2015s = getData("out");
    for i = 1 : regionNum
       pop2015 = regionList{i}.getYearPop(2015);
       regionList{i}.migrProp = migrNum2015s(i) / pop2015;
    end
    
    % poliP
    ambs = getData("amb");
    poliPs = normalize(ambs, "upper", Inf);
    for i = 1 : regionNum
        regionList{i}.poliP = poliPs(i);
    end
end