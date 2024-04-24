function Z = PathConstraintG4(Z,auxdata, Opts)
%
% U_charge <= available power
% Specific cases
%   Primary--- U_Pcharge <= x_G
%   Electrical U_Echarge <= eta_G(x_G - U_Pcharge - L_GP)
%   Tertiary   U_Tcharge <= eta_G(x_G - U_Pcharge - L_GP)  - U_Echarge - L_GE
%  
% Generic case: 
% -----> U_Tcharge - eta_G*x_G + eta_G*U_Pcharge + eta_G*L_GP + eta_G*L_PT + U_Echarge + L_GE <= 0
% -----> U_Tcharge - eta_G*x_G + eta_G*U_Pcharge + eta_G*LP_G*xG - eta_G*eta_discharge_P*uP_discharge + eta_G*eta_discharge_P*uP_rev + eta_G*L_PT*u_T_charge + U_Echarge + LE*xG - eta_discharge_E*uE_discharge + eta_discharge_E*uE_rev <= 0
% ----->    T1     -     T2     +      T3        +      T4       -               T5                   +           T6                 +           T7          +   T8      +   T9   -             T10             +          T11 <= 0
% 
% Saeed Azad, PhD


idx = length(Z);

% Number of States and control 
N_State  = Opts.DTQP.subsys.Nx_G+Opts.DTQP.subsys.Nx_S;
N_Control  = Opts.DTQP.subsys.Nu_G+Opts.DTQP.subsys.Nu_S;

% Create a zero vector
State_mat = zeros(N_State,1);
Control_mat = zeros(N_Control,1);

idx = idx + 1;

% T1
Z(idx).linear(1).right = 1; Z(idx).linear(1).matrix = Control_mat;

% T2
Z(idx).linear(2).right = 2; Z(idx).linear(2).matrix = State_mat;

% T3
Z(idx).linear(3).right = 1; Z(idx).linear(3).matrix = Control_mat;

% T4
Z(idx).linear(4).right = 2; Z(idx).linear(4).matrix = State_mat;

% T5
Z(idx).linear(5).right = 1; Z(idx).linear(5).matrix = Control_mat;

% T6
Z(idx).linear(6).right = 1; Z(idx).linear(6).matrix = Control_mat;

% T7
Z(idx).linear(7).right = 1; Z(idx).linear(7).matrix = Control_mat;

% T8
Z(idx).linear(8).right = 1; Z(idx).linear(8).matrix = Control_mat;

% T9
Z(idx).linear(9).right = 2; Z(idx).linear(9).matrix = State_mat;

% T10
Z(idx).linear(10).right = 1; Z(idx).linear(10).matrix = Control_mat;

% T11
Z(idx).linear(11).right = 1; Z(idx).linear(11).matrix = Control_mat;

% Constraint Bound
Z(idx).b = 0;

eta_G           = auxdata.Generator.eta_G;
idx_State_G     = auxdata.IDX.Generator.State;

% -T2: - eta_G*x_G
Z(idx).linear(2).matrix(idx_State_G,1) = -eta_G;

% T4: eta_G*LP*xG
Z(idx).linear(4).matrix(idx_State_G,1) = +eta_G*auxdata.Loads.LP_G;

% T9: LE*xG
Z(idx).linear(9).matrix(idx_State_G,1) = +auxdata.Loads.LE;



% Primary Storage 
if isfield(auxdata.IDX.Storage,'Primary')

    idx_Control_S   = auxdata.IDX.Storage.Primary.Control;
    u_charge_idx    = idx_Control_S(1,1);
    u_discharge_idx = idx_Control_S(2,1);
    u_rev_idx       = idx_Control_S(3,1);
    eta_p_discharge = auxdata.Storage.eta2_S;


    % T3: eta_G*U_Pcharge
    Z(idx).linear(3).matrix(u_charge_idx,1) = eta_G;

    % T5: - eta_G*eta_discharge_P*uP_discharge
    Z(idx).linear(5).matrix(u_discharge_idx,1) = -eta_G*eta_p_discharge;

    % T6: eta_G*eta_discharge_P*uP_rev
    Z(idx).linear(6).matrix(u_rev_idx,1) = +eta_G*eta_p_discharge;


end


% Electrical 
if isfield(auxdata.IDX.Storage,'Electrical')

    idx_Control_S   = auxdata.IDX.Storage.Electrical.Control;
    u_charge_idx    = idx_Control_S(1,1);
    u_discharge_idx = idx_Control_S(2,1);
    u_rev_idx       =  idx_Control_S(3,1);
    eta_e_discharge = auxdata.Storage.eta2_S;


    % T8: U_Echarge
    Z(idx).linear(8).matrix(u_charge_idx,1) = 1;

    % T10: - eta_discharge_E*uE_discharge
    Z(idx).linear(10).matrix(u_discharge_idx,1) = -eta_e_discharge;

    % T11:  eta_discharge_E*uE_rev
    Z(idx).linear(11).matrix(u_rev_idx,1) = +eta_e_discharge;

end


% Tertiary (u_T_Charge(t)<= x_Gen(t)-L_GP- L_GE)
if isfield(auxdata.IDX.Storage,'Tertiary')

    idx_Control_S = auxdata.IDX.Storage.Tertiary.Control;
    u_charge_idx = idx_Control_S(1,1);

    % T1: U_Tcharge
    Z(idx).linear(1).matrix(u_charge_idx,1) = 1;

    % T4: eta_G*LP*u_charge_T
    Z(idx).linear(7).matrix(u_charge_idx,1) = +eta_G*auxdata.Loads.LP_T;


end

end