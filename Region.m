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
        
        lang2Prop;      % the proportion of L2
    end
 
    properties (Dependent)
        emisP;          % emissive power
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
        
        function obj = loadDataByYear(obj)
            global curYear;
            obj.econP = getYearGdp(obj, curYear);
            obj.pop = getYearPop(curYear);
            obj.migrNum = obj.pop * obj.migrProp;
        end
        
        function obj = calEmisP(obj)
            obj.emisP = ...
                obj.econP * econW + ...
                obj.poliP * poliW + ...
                obj.absDiff * absDiffW + ...
                obj.migrP * migrW;
        end
        
        function gdp = getYearGdp(obj, year)
            gdp = polyval(obj.gdpsFitLine, year);
        end
        
        function pop = getYearPop(obj, year)
           pop = obj.popsFitLine(year);
        end
    end
    
    methods
        function update(regionList)
            regionNum = size(regionList);
            migratorNums = zeros(1, regionNum);
            
            % update data
            for i = 1:regionNum
                regionList(i).loadDataByYear(); % ecno & pop & migrNum
                migratorNums(i) = regionList(i).migrNum; % record migrNum
            end
            
            % update migrP & cal emisP
            migrPs = normalize(migratorNums);
            for i = 1:regionNum
                regionList(i).migrP = migrPs(i);
                regionList.calEmisP();
            end
        end
    end
end