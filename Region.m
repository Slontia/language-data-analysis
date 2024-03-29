classdef Region
    properties
        % profile
        id;
        country;
        lang;
        
        % fit line
        popsFitLine;    % the changes of population
        gdpsFitLine;    % the changes of GDP
        
        % static data
        migrProp;       % migrator number / population (2015)
        poliP;          % politics power
        
        % dynamic data
        pop;            % population
        migrNum;        % migrator number
        econP;          % economy power
        migrP;          % migration power
        emisP;          % emissive power
        
        lang2Prop;      % the proportion of L2
    end
   
    % constuctor
    methods 
        function self = Region(id, country, lang)
            self.id = id;
            self.country = country;
            self.lang = lang;
        end
    end
    
    methods
        function beRediatedBy(originRegion, dist)
            
        end
        
        function gdp = getYearGdp(obj, year)
            gdp = polyval(obj.gdpsFitLine, year);
        end
        
        function pop = getYearPop(obj, year)
           pop = obj.popsFitLine(year);
        end
        
        function obj = loadDataByYear(obj)
            global curYear;
            obj.econP = obj.getYearGdp(curYear);
            obj.pop = obj.getYearPop(curYear);
            obj.migrNum = obj.pop * obj.migrProp;
        end
        
        function obj = calEmisP(obj)
            global econW;
            global poliW;
            global migrW;
            obj.emisP = ...
                obj.econP * econW + ...
                obj.poliP * poliW + ...
                obj.migrP * migrW;
        end
    end
    
    methods(Static)
        function update()
            global regionList;
            global regionNum;
            migratorNums = zeros(1, regionNum);
            gdps = zeros(1, regionNum);
       
            % update data
            for i = 1:regionNum
                regionList{i} = regionList{i}.loadDataByYear(); % ecno & pop & migrNum
                migratorNums(1, i) = regionList{i}.migrNum; % record migrNum
                gdps(1, i) = regionList{i}.econP; % record economy power
            end
            
            % update migrP & cal emisP
            migrPs = normalize(migratorNums, "upper", Inf);
            econPs = normalize(gdps, "upper", Inf);
            for i = 1:regionNum
                regionList{i}.migrP = migrPs(i);
                regionList{i}.econP = econPs(i);
                regionList{i} = regionList{i}.calEmisP();
            end
        end
    end
end