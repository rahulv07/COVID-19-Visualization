classdef World < handle
    properties (Access = private)
        % Parse object
        DataParser
        % Vector of countries
        Countries
        % Instead of storing the duration of data in each object
        % is it stored in this global object to save some space.
        Duration
        StartDate
        EndDate
    end

    methods
        % Constructor
        function obj = World()
            % Load data
            load covid_data.mat covid_data;
            obj.DataParser = Parser(covid_data);
            obj.Countries = obj.DataParser.ParseCountries();
            obj.Duration = obj.DataParser.ParseDuration();
            [obj.StartDate, obj.EndDate] = obj.DataParser.ParseDurationInterval();
        end
        
        function duration = GetDuration(obj)
            duration = obj.Duration;
        end
        
        function [startDate, endDate] = GetDurationInterval(obj)
            startDate = obj.StartDate;
            endDate = obj.EndDate;
        end
        
        function countries = GetCountriesNames(obj)
            countries = cell(1, length(obj.Countries));

            for i = 1:length(obj.Countries)
                countries{i} = char(obj.Countries(i).GetName());
            end
        end
        
        function country = GetCountryByName(obj, Name)
            CountryNames = obj.GetCountriesNames();
            index = find([CountryNames{:}, " "] == Name);
            country = obj.Countries(index);
        end
        
        function countries = GetCountries(obj)
            countries = obj.Countries;
        end
    end
end