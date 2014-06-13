function obj = finalStepVars(step,finalState,wellSol,schedule,finalTime, varargin)
% the final state of the simulation (finalState) should equal stateNext

opt     = struct('ComputePartials',false,'xvScale',[],'xLeftSeed',[],'vLeftSeed',[],...
        'activeComponents',struct('oil',1,'water',1,'gas',0,'polymer',0,'disgas',0,'vapoil',0,'T',0,'MI',0),...
        'fluid',[],...
        'system',[]);% default OW


opt     = merge_options(opt, varargin{:});

comp = opt.activeComponents;

if ~comp.gas && ~comp.polymer && ~(comp.T || comp.MI)
    
    obj = finalStepVarsOW(step,finalState,wellSol,schedule,finalTime,...
        'ComputePartials',opt.ComputePartials,...
        'xvScale',opt.xvScale,...
        'xLeftSeed',opt.xLeftSeed,...
        'vLeftSeed',opt.vLeftSeed);
    
elseif comp.gas && comp.oil && comp.water
    
    obj = finalStepVarsOWG(step,finalState,wellSol,schedule,finalTime,opt.fluid,opt.system,...
        'ComputePartials',opt.ComputePartials,...
        'xvScale',opt.xvScale,...
        'xLeftSeed',opt.xLeftSeed,...
        'vLeftSeed',opt.vLeftSeed);
    
else
    error('Not implemented for current activeComponents');
end

end




