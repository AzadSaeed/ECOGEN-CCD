function Z = Path_DemandFollowing(Z,auxdata,Opts)
% This function is a path constraint associated with demand following for
% specific hours during the day. During these specific hours, the generator
% is expected to operate at its nominal capacity to provide peak power.
% During the same time priod, since the power is required for demand, the
% charging signal must also be turned off
% 
% Saeed Azad, PhD



%-------------------------------------------------------------------------% 
%-------------------------Generator Power --------------------------------%
%-------------------------------------------------------------------------%
idx = length(Z);

% Create the state matrix of the apropriate size
N_State  = Opts.DTQP.subsys.Nx_G+Opts.DTQP.subsys.Nx_S;

% Create cells for matrices
State_mat = repmat({zeros(1,1)},1,N_State);

% State index
idx_State_G = auxdata.IDX.Generator.State ;

% Gmin <= xG
idx = idx + 1;
Z(idx).linear(1).right = 2;  Z(idx).linear(1).matrix = State_mat;
Z(idx).b = @(t)-auxdata.Generator.F_demand_fnc.Limit_min_fnc(t);
Z(idx).linear(1).matrix{idx_State_G,1} = -1;
%-------------------------------------------------------------------------%



%-------------------------------------------------------------------------% 
%------------------------- Storage Charge --------------------------------%
%-------------------------------------------------------------------------%

% Number of States and control 
N_Control  = Opts.DTQP.subsys.Nu_G+Opts.DTQP.subsys.Nu_S;

% Create a zero vector
Control_mat = zeros(N_Control,1);

idx = idx + 1;
Z(idx).linear(1).right = 1; Z(idx).linear(1).matrix = Control_mat;
Z(idx).b = @(t)auxdata.Generator.F_demand_fnc.max_charge_fnc(t);

% Primary Storage 
if isfield(auxdata.IDX.Storage,'Primary')

    idx_Control_S   = auxdata.IDX.Storage.Primary.Control;    
    u_charge_idx    = idx_Control_S(1,1);
    Z(idx).linear(1).matrix(u_charge_idx,1) = 1;

end



% Electrical Storage 
if isfield(auxdata.IDX.Storage,'Electrical')

    idx_Control_S   = auxdata.IDX.Storage.Primary.Control;    
    u_charge_idx    = idx_Control_S(1,1);
    Z(idx).linear(1).matrix(u_charge_idx,1) = 1;

end


% Tertiary Storage 
if isfield(auxdata.IDX.Storage,'Tertiary')

    idx_Control_S   = auxdata.IDX.Storage.Tertiary.Control;    
    u_charge_idx    = idx_Control_S(1,1);
    Z(idx).linear(1).matrix(u_charge_idx,1) = 1;

end


end