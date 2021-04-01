classdef Region < handle
    properties (Access = private)
        Name             string = ''   % Name
        CumulativeCases
        CumulativeDeaths
        DailyCases
        DailyDeaths
    end
    
    methods (Access = private)
        % Calculate the daily cases and deaths
        function CalculateDailyData(obj)
            if isempty(obj.CumulativeCases) || isempty(obj.CumulativeDeaths)
                return;
            end
            
            obj.DailyCases = zeros(1,length(obj.CumulativeCases));
            obj.DailyDeaths = zeros(1, length(obj.DailyCases));
            
            obj.DailyCases(1) = obj.CumulativeCases(1);
            obj.DailyDeaths(1) = obj.CumulativeDeaths(1);
            for i = 2:length(obj.DailyCases)
                obj.DailyCases(i) = max(0, obj.CumulativeCases(i) - obj.CumulativeCases(i-1));
                obj.DailyDeaths(i) = max(0, obj.CumulativeDeaths(i) - obj.CumulativeDeaths(i-1));
            end
        end
    end
    
    methods
        function obj = Region(Name, Cases, Deaths)
            arguments
                Name = ''
                Cases = []
                Deaths = []
            end
            obj.Name = Name;
            obj.CumulativeCases = Cases;
            obj.CumulativeDeaths = Deaths;
            obj.DailyCases = [];
            obj.DailyDeaths = [];
            CalculateDailyData(obj);
        end
        
        function name = GetName(obj)
            name = obj.Name;
        end
        
        function cases = GetCumulativeCases(obj)
            cases = obj.CumulativeCases;
        end
        
        function deaths = GetCumulativeDeaths(obj)
            deaths = obj.CumulativeDeaths;
        end
        
        function cases = GetDailyCases(obj)
            cases = obj.DailyCases;
        end
        
        function deaths = GetDailyDeaths(obj)
            deaths = obj.DailyDeaths;
        end
    end
    
end