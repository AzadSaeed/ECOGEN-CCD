function Z = PathConstraintG3(Z,auxdata, Opts)
% Storage state smaller than plant (i.e. capacity) 
% x_storgae <= Storage capacity
%
% Saeed Azad, PhD

idx = length(Z);

% Number of States 
N_State  = Opts.DTQP.subsys.Nx_G+Opts.DTQP.subsys.Nx_S;
N_Plant  = Opts.DTQP.subsys.Np_G+Opts.DTQP.subsys.Np_S;

% Create a zero vector for state
State_mat = zeros(N_State,1);
Plant_mat = zeros(N_Plant,1);

idx = idx + 1;
Z(idx).linear(1).right = 2;  Z(idx).linear(1).matrix = State_mat;
Z(idx).linear(2).right = 3;  Z(idx).linear(2).matrix = Plant_mat;
Z(idx).b = 0;


% Primary
if isfield(auxdata.IDX.Storage,'Primary')

    idx_State_S = auxdata.IDX.Storage.Primary.State;
    idx_Plant_S = auxdata.IDX.Storage.Primary.Plant;

    Z(idx).linear(1).matrix(idx_State_S,1) = 1;
    Z(idx).linear(2).matrix(idx_Plant_S,1) = -1;

end


% Electrical
if isfield(auxdata.IDX.Storage,'Electrical')

    idx_State_S = auxdata.IDX.Storage.Electrical.State;
    idx_Plant_S = auxdata.IDX.Storage.Electrical.Plant;

    Z(idx).linear(1).matrix(idx_State_S,1) = 1;
    Z(idx).linear(2).matrix(idx_Plant_S,1) = -1;

end


% Tertiary 
if isfield(auxdata.IDX.Storage,'Tertiary')

    idx_State_S = auxdata.IDX.Storage.Tertiary.State;
    idx_Plant_S = auxdata.IDX.Storage.Tertiary.Plant;

    Z(idx).linear(1).matrix(idx_State_S,1) = 1;
    Z(idx).linear(2).matrix(idx_Plant_S,1) = -1;

end

end