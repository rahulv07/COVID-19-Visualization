classdef Parser < handle
    properties
        Data
    end
    
    methods (Access = private)
        % Parses the row data into a list of cases and death
        function [cases, deaths] = ParseData(obj, Index)
            CovidData = obj.Data(Index, 3:end);
            
            %Preallocate arrays
            cases = zeros(1, length(CovidData));
            deaths = zeros(1, length(CovidData));
            
            for i = 1:length(CovidData)
                cases(i) = CovidData{i}(1);
                deaths(i) = CovidData{i}(2);
            end
        end
        
        function [country, index] = ParseCountry(obj, Index)
            arguments
                obj
                Index (1,:) {mustBeInteger}
            end
            if (Index > length(obj.Data))
                exception = MException('Parse:IndexOutOfBounds');
                throw(exception);
            end
            
            CountryName = obj.Data{Index, 1};
            
            % Find the number of states
            ii = (Index + 1);
            while ii <= length(obj.Data)
                if ~strcmp(obj.Data{ii}, CountryName)
                    break;
                end
                ii = ii + 1;
            end
            index = ii;
            States = obj.ParseStates(Index, ii);
            
            country = Country(CountryName, States);
        end
        
        function states = ParseStates(obj, StartIndex, EndIndex)
            arguments
                obj
                StartIndex (1,:) {mustBeInteger}
                EndIndex (1,:) {mustBeInteger}
            end
            if (StartIndex > length(obj.Data) || EndIndex > length(obj.Data) + 1)
                exception = MException('Parse:IndexOutOfBounds');
                throw(exception);
            end
            
            % Preallocate
            states(EndIndex-StartIndex) = Region('Dummy', [], []);
            Index = 1;
            while StartIndex < EndIndex
                Name = obj.Data{StartIndex, 2};
                if isempty(Name)
                    % Empty name cell means no states
                    Name = 'All';
                end
                [Cases, Deaths] = obj.ParseData(StartIndex);
                states(Index) = Region(Name, Cases, Deaths);
                StartIndex = StartIndex + 1;
                Index = Index + 1;
            end
        end
    end
    
    methods
        function obj = Parser(CovidData)
            obj.Data = CovidData;
        end
        
        function countries = ParseCountries(obj)
            % Populate the countries vector
            rowIndex = 2;
            
            % Parse the Global number of cases and deaths
            GlobalData = obj.Data(2:end, 3:end);
            GlobalData = cell2mat(GlobalData);
            GlobalData = sum(GlobalData);
            sze = size(GlobalData, 2);
            GlobalData = reshape(GlobalData, [2, sze/2]);
            GlobalCases = GlobalData(1, :);
            GlobalDeaths = GlobalData(2, :);
            
            GlobalState = Region('All', GlobalCases, GlobalDeaths);
            
            % Preallocate the list
            Prev = '';
            Counter = 0;
            for i = 2:length(obj.Data)
                if strcmp(obj.Data(i, 1), Prev)
                    continue;
                end
                Prev = obj.Data(i, 1);
                Counter = Counter + 1;
            end
            countries(Counter + 1) = Country('Dummy', GlobalState);    
            
            CountryIndex = 2;
            while rowIndex <= size(obj.Data, 1)
                [country, index] = obj.ParseCountry(rowIndex);
                countries(CountryIndex) = country;
                rowIndex = index;
                CountryIndex = CountryIndex + 1;
            end
            countries(1) = Country('Global', GlobalState);
        end
        
        function duration = ParseDuration(obj)
            DurationData = obj.Data(1, 3:end);
            duration = DurationData;
        end
        
        function [startdate, enddate] = ParseDurationInterval(obj)
            startdate = obj.Data(1, 3);
            enddate = obj.Data(1, end);
            startdate = datetime(startdate, 'InputFormat', 'M/d/yy');
            startdate.Format = 'M/d/yy';
            enddate = datetime(enddate, 'InputFormat', 'M/d/yy');
            enddate.Format = 'M/d/yy';
        end
    end
end








