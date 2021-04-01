classdef Country < Region
    properties (Access = private)
        States           %{mustBeVector} = [] % List of states
        StatesNames      % Cache this list instead of recalculating again
    end
    
    methods
        function obj = Country(Name, States)
            arguments
                Name = ''
                States = []
            end
            % Instantiate the super class
            obj = obj@Region(Name, [], []);
            obj.States = States;
            obj.StatesNames = [];
        end
        
        function tf = eq(a, b)
            arguments
                a (1,1)
                b
            end
            if ~isa(b, 'Country')
                if strcmp(a.GetName(), b)
                    tf = true;
                else
                    tf = false;
                end
            else
                if strcmp(a.GetName(), b.GetName())
                    tf = true;
                else
                    tf = false;
                end
            end
        end
        
        function states = GetStatesNames(obj)
            if ~isempty(obj.StatesNames)
                states = obj.StatesNames;
                return;
            end
            states = cell(1, length(obj.States));

            for i = 1:length(obj.States)
                states{i} = char(obj.States(i).GetName());
            end
            obj.StatesNames = states;
        end
        
        function states = GetStates(obj)
            states = obj.States;
        end
        
        function name = GetName(obj)
            name = GetName@Region(obj);
        end
        
        function state = GetStateByName(obj, Name)
            StatesName = obj.GetStatesNames();
            index = find([StatesName{:}, " "] == Name);
            state = obj.States(index);
        end
        
        % convenient to this functions
        function cases = GetCumulativeCases(obj)
            cases = obj.States(1).GetCumulativeCases();
        end
        
        function cases = GetCumulativeDeaths(obj)
            cases = obj.States(1).GetCumulativeDeaths();
        end
    end
end