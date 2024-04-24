function Z = Path_DiscreteMarketDemand(Z,auxdata,Opts)
% This function is a path constraint associated with the discrete demand
% for the sales of the tertiary commodity. 
% 
% Saeed Azad, PhD

idx_Control_S = auxdata.IDX.Storage.Tertiary.Control;
u_rev_idx = idx_Control_S(3,1);

% Number of path constraints
idx = length(Z);

% Discrete demand: modeled in problem options
idx = idx + 1;
Z(idx).linear(1).right = 1; Z(idx).linear(1).matrix(u_rev_idx,1) = 1;
Z(idx).b = @(t)auxdata.Storage.DMD(t);


end


