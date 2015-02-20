classdef TwoPhaseOilWaterModel < ReservoirModel
    % Two phase oil/water system without dissolution

%{
Changes by Codas


%}
    properties

    end
    
    methods
        function model = TwoPhaseOilWaterModel(G, rock, fluid, varargin)
            
            model = model@ReservoirModel(G, rock, fluid);
            
            % This is the model parameters for oil/water
            model.oil = true;
            model.gas = false;
            model.water = true;
            
            % Blackoil -> use CNV style convergence 
            model.useCNVConvergence = true;
            
            model.saturationVarNames = {'sw', 'so'};
            model.wellVarNames = {'qWs', 'qOs', 'bhp'};
            
            model = merge_options(model, varargin{:});
            
            % Setup operators
            model = model.setupOperators(G, rock, 'deck', model.inputdata);
        end
        
        function [problem, state] = getEquations(model, state0, state, dt, drivingForces, varargin)
            [problem, state] = equationsOilWater(state0, state, model,...
                            dt, ...
                            drivingForces,...
                            varargin{:});
            
        end
        
        end
        
        function [state, report] = updateState(model, state, problem, dx, drivingForces)
            % Parent class handles almost everything for us
            [state, report] = updateState@ReservoirModel(model, state, problem, dx, drivingForces);
            
            % Update wells based on black oil specific properties
            saturations = model.saturationVarNames;
            wi = strcmpi(saturations, 'sw');
            oi = strcmpi(saturations, 'so');
            gi = strcmpi(saturations, 'sg');

            W = drivingForces.Wells;
            state.wellSol = assignWellValuesFromControl(model, state.wellSol, W, wi, oi, gi);

        end
    end
end