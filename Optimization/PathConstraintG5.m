function Z = PathConstraintG5(Z,auxdata, Opts)
% Revenue signal is always smaller or equal to the discharge 
% U_R <= U_Discharge
%
% Saeed Azad, PhD

idx = length(Z);

% Number of controls 
N_Control  = Opts.DTQP.subsys.Nu_G+Opts.DTQP.subsys.Nu_S;

% Create a zero vector
Control_mat = zeros(N_Control,1);


idx = idx + 1;
Z(idx).linear(1).right = 1; Z(idx).linear(1).matrix = Control_mat;
Z(idx).linear(2).right = 1; Z(idx).linear(2).matrix = Control_mat;
Z(idx).b = 0;

% Primary 
if isfield(auxdata.IDX.Storage,'Primary')

    idx_Control_S = auxdata.IDX.Storage.Primary.Control;
    u_discharge_idx = idx_Control_S(2,1);
    u_rev_idx = idx_Control_S(3,1);

    Z(idx).linear(1).matrix(u_rev_idx,1) = 1;
    Z(idx).linear(2).matrix(u_discharge_idx,1) = -1;

end

% Electrical
if isfield(auxdata.IDX.Storage,'Electrical')

    idx_Control_S = auxdata.IDX.Storage.Electrical.Control;
    u_discharge_idx = idx_Control_S(2,1);
    u_rev_idx = idx_Control_S(3,1);

    Z(idx).linear(1).matrix(u_rev_idx,1) = 1;
    Z(idx).linear(2).matrix(u_discharge_idx,1) = -1;

end

% Tertiary
if isfield(auxdata.IDX.Storage,'Tertiary')

    idx_Control_S = auxdata.IDX.Storage.Tertiary.Control;
    u_discharge_idx = idx_Control_S(2,1);
    u_rev_idx = idx_Control_S(3,1);

    Z(idx).linear(1).matrix(u_rev_idx,1) = 1;
    Z(idx).linear(2).matrix(u_discharge_idx,1) = -1;
end

end

