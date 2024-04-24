function Z = PathConstraint_G2(Z,auxdata, Opts)
% This function defines the following path constraints:
%
% L_GP(t) = LP*xG - eta_discharge_P*uP_discharge + eta_discharge_P*uP_rev
% L_GE(t) = LE*xG - eta_discharge_E*uE_discharge + eta_discharge_E*uE_rev
%
%
% Constraint 1:
% --------- 0 <= L_GP(t)
% ------------>  -LP*xG + eta_discharge_P*uP_discharge - eta_discharge_P*uP_rev <= 0  
%
%
% Constraint 2:
% --------- L_GP <= x_gen(t) - u_Charge_P(t)
%------------> LP*xG - eta_discharge_P*uP_discharge + eta_discharge_P*uP_rev - x_gen(t) + u_Charge_P(t) <= 0 
%
%
% Constraint 3:
% --------- 0 <= LPT
%
%
% Constraint 4:
% --------- LPT < = x_G - u_P_charge - LGP
%
%
% Constraint 5:
% --------- 0 <= L_GE(t)
%------------> -LE*xG + eta_discharge_E*uE_discharge - eta_discharge_E*uE_rev <= 0 
% 
%
% Constraint 6:
% --------- L_GE <= eta_G(x_gen(t) - u_Charge_P(t) - L_GP - LPT) - u_Charge_E(t)
%------------> LE*xG - eta_discharge_E*uE_discharge + eta_discharge_E*uE_rev - eta_G*x_gen(t) + eta_G*u_Charge_P(t) + eta_G*L_GP + LPT +  u_Charge_E(t)
%------------> LE*xG - eta_discharge_E*uE_discharge + eta_discharge_E*uE_rev - eta_G*x_gen(t) + eta_G*u_Charge_P(t) + eta_G*LP*xG - eta_G*eta_discharge_P*uP_discharge + eta_G*eta_discharge_P*uP_rev + LPT*u_charge_t + u_Charge_E(t) 
%
% Saeed Azad, PhD

if auxdata.Loads.LP_G~=0

    % Constraint 1:
    Z = constraint_one(Z,auxdata, Opts);

    % Constraint 2:
    Z = constraint_two(Z,auxdata, Opts);

end


if auxdata.Loads.LP_T~=0

    % Constraint 3:
    Z = constraint_three(Z,auxdata, Opts);

    % Constraint 4:
    Z = constraint_four(Z,auxdata, Opts);

end

if auxdata.Loads.LE~=0

    % Constraint 5:
    Z = constraint_five(Z,auxdata, Opts);

    % Constraint 5:
    Z = constraint_six(Z,auxdata, Opts);

end

end




%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%

function Z = constraint_one(Z,auxdata, Opts)

% Constraint 1:
% -LP*xG + eta_discharge_P*uP_discharge - eta_discharge_P*uP_rev <= 0
% -T1 + T2 - T3 < = 0

idx = length(Z);
idx = idx + 1;


% Number of controls and states
N_Control  = Opts.DTQP.subsys.Nu_G+Opts.DTQP.subsys.Nu_S;
N_State = Opts.DTQP.subsys.Nx_G+Opts.DTQP.subsys.Nx_S;


% Create a zero vector
Control_mat = zeros(N_Control,1);
State_mat = zeros(N_State,1);


% T1
Z(idx).linear(1).right = 2; Z(idx).linear(1).matrix = State_mat;

% T2
Z(idx).linear(2).right = 1; Z(idx).linear(2).matrix = Control_mat;

% T3
Z(idx).linear(3).right = 1; Z(idx).linear(3).matrix = Control_mat;

% Constraint bound
Z(idx).b = 0;


% -T1
idx_State_G = auxdata.IDX.Generator.State;
Z(idx).linear(1).matrix(idx_State_G,1) = -auxdata.Loads.LP_G;


if isfield(auxdata.IDX,'Storage') && isfield(auxdata.IDX.Storage,'Primary')

    idx_Control_S = auxdata.IDX.Storage.Primary.Control;
    u_discharge_idx = idx_Control_S(2,1);
    u_rev_idx = idx_Control_S(3,1);
    eta_p_discharge = auxdata.Storage.eta2_S;

    % T2
    Z(idx).linear(2).matrix(u_discharge_idx,1) = eta_p_discharge;

    % -T3
    Z(idx).linear(3).matrix(u_rev_idx,1) = -eta_p_discharge;

end


end


%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%

function Z = constraint_two(Z,auxdata, Opts)

% Constraint 2:
% LP*xG - eta_discharge_P*uP_discharge + eta_discharge_P*uP_rev - x_gen(t) + u_Charge_P(t) <= 0
% T1 - T2 + T3 - T4 + T5 <= 0

idx = length(Z);
idx = idx + 1;

% Number of controls and states
N_Control  = Opts.DTQP.subsys.Nu_G+Opts.DTQP.subsys.Nu_S;
N_State = Opts.DTQP.subsys.Nx_G+Opts.DTQP.subsys.Nx_S;


% Create a zero vector
Control_mat = zeros(N_Control,1);
State_mat = zeros(N_State,1);


% T1
Z(idx).linear(1).right = 2; Z(idx).linear(1).matrix = State_mat;


% T2
Z(idx).linear(2).right = 1; Z(idx).linear(2).matrix = Control_mat;

% T3
Z(idx).linear(3).right = 1; Z(idx).linear(3).matrix = Control_mat;

% T4
Z(idx).linear(4).right = 2; Z(idx).linear(4).matrix = State_mat;

% T5
Z(idx).linear(5).right = 1; Z(idx).linear(5).matrix = Control_mat;

% Constraint bound
Z(idx).b = 0;

% T1
idx_State_G = auxdata.IDX.Generator.State;
Z(idx).linear(1).matrix(idx_State_G,1) = auxdata.Loads.LP_G;


% -T4
Z(idx).linear(4).matrix(idx_State_G,1) = -1;



% Primary
if isfield(auxdata.IDX,'Storage') && isfield(auxdata.IDX.Storage,'Primary')

    idx_Control_S = auxdata.IDX.Storage.Primary.Control;
    u_charge_idx = idx_Control_S(1,1);
    u_discharge_idx = idx_Control_S(2,1);
    u_rev_idx = idx_Control_S(3,1);
    eta_p_discharge = auxdata.Storage.eta2_S;


    % T2
    Z(idx).linear(2).matrix(u_discharge_idx,1) = -eta_p_discharge;

    % T3
    Z(idx).linear(3).matrix(u_rev_idx,1) = eta_p_discharge;

    % T5
    Z(idx).linear(5).matrix(u_charge_idx,1) = 1;

end


end

%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%


function Z = constraint_three(Z,auxdata, Opts)
% Constraint 3:
% 0 <= LPT*u_T_charge ----->   -LPT*u_T_charge <= 0
%                                     T1 <= 0

idx = length(Z);
idx = idx + 1;

% Number of controls and states
N_Control  = Opts.DTQP.subsys.Nu_G+Opts.DTQP.subsys.Nu_S;

% Create a zero vector
Control_mat = zeros(N_Control,1);

% Constraint bound
Z(idx).b = 0;

% T1
Z(idx).linear(1).right = 1; Z(idx).linear(1).matrix = Control_mat;

if isfield(auxdata.IDX,'Storage') && isfield(auxdata.IDX.Storage,'Tertiary')

    idx_Control_S = auxdata.IDX.Storage.Tertiary.Control;
    u_charge_idx = idx_Control_S(1,1);
    Z(idx).linear(1).matrix(u_charge_idx,1) = -auxdata.Loads.LP_T;

end

end


%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
function Z = constraint_four(Z,auxdata, Opts)
% Constraint 4:
% LPT*u_T_charge <= x_G - u_P_charge - LGP
% LPT*u_T_charge <= x_G - u_P_charge - (LP*xG - eta_discharge_P*uP_discharge + eta_discharge_P*uP_rev )
% LPT*u_T_charge <= x_G - u_P_charge - LP*xG + eta_discharge_P*uP_discharge - eta_discharge_P*uP_rev 
% LPT*u_T_charge -  x_G + u_P_charge + LP*xG - eta_discharge_P*uP_discharge + eta_discharge_P*uP_rev <= 0
%  T1            -  T2  +    T3      +  T4   -             T5               +       T6 <= 0


idx = length(Z);
idx = idx + 1;

% Number of controls and states
N_Control  = Opts.DTQP.subsys.Nu_G+Opts.DTQP.subsys.Nu_S;
N_State = Opts.DTQP.subsys.Nx_G+Opts.DTQP.subsys.Nx_S;


% Create a zero vector
Control_mat = zeros(N_Control,1);
State_mat = zeros(N_State,1);


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

% Constraint bound
Z(idx).b = 0;


% T1
if isfield(auxdata.IDX,'Storage') && isfield(auxdata.IDX.Storage,'Tertiary')

    idx_Control_S = auxdata.IDX.Storage.Tertiary.Control;
    u_charge_idx = idx_Control_S(1,1);
    Z(idx).linear(1).matrix(u_charge_idx,1) = auxdata.Loads.LP_T;

end

% -T2
idx_State_G = auxdata.IDX.Generator.State;
Z(idx).linear(2).matrix(idx_State_G,1) = -1;


% Primary
if isfield(auxdata.IDX,'Storage') && isfield(auxdata.IDX.Storage,'Primary')

    idx_Control_S = auxdata.IDX.Storage.Primary.Control;
    u_charge_idx = idx_Control_S(1,1);
    u_discharge_idx = idx_Control_S(2,1);
    u_rev_idx = idx_Control_S(3,1);
    eta_p_discharge = auxdata.Storage.eta2_S;


    % T3
    Z(idx).linear(3).matrix(u_charge_idx,1) = 1;

    % T5
    Z(idx).linear(5).matrix(u_discharge_idx,1) = -eta_p_discharge;

    % T6
    Z(idx).linear(6).matrix(u_rev_idx,1) = + eta_p_discharge;

end


% T4 
Z(idx).linear(4).matrix(idx_State_G,1) = auxdata.Loads.LP_G;


end



%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%

function Z = constraint_five(Z,auxdata, Opts)


idx = length(Z);
idx = idx + 1;

% Number of controls and states
N_Control  = Opts.DTQP.subsys.Nu_G+Opts.DTQP.subsys.Nu_S;
N_State = Opts.DTQP.subsys.Nx_G+Opts.DTQP.subsys.Nx_S;


% Create a zero vector
Control_mat = zeros(N_Control,1);
State_mat = zeros(N_State,1);

% T1
Z(idx).linear(1).right = 2; Z(idx).linear(1).matrix = State_mat;

% T2
Z(idx).linear(2).right = 1; Z(idx).linear(2).matrix = Control_mat;

% T3
Z(idx).linear(3).right = 1; Z(idx).linear(3).matrix = Control_mat;

% Constraint bound
Z(idx).b = 0;


% -T1
idx_State_G = auxdata.IDX.Generator.State;
Z(idx).linear(1).matrix(idx_State_G,1) = -auxdata.Loads.LE;


if isfield(auxdata.IDX,'Storage') && isfield(auxdata.IDX.Storage,'Electrical')

    idx_Control_S = auxdata.IDX.Storage.Electrical.Control;
    u_discharge_idx = idx_Control_S(2,1);
    u_rev_idx = idx_Control_S(3,1);
    eta_e_discharge = auxdata.Storage.eta2_S;


    % T2
    Z(idx).linear(2).matrix(u_discharge_idx,1) = eta_e_discharge;

    % -T3
    Z(idx).linear(3).matrix(u_rev_idx,1) = -eta_e_discharge;


end



end



%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
function Z = constraint_six(Z,auxdata, Opts)

% Constraint 4:
% LE*xG - eta_discharge_E*uE_discharge + eta_discharge_E*uE_rev - eta_G*x_gen(t) + eta_G*u_Charge_P(t) + eta_G*LP*xG - eta_G*eta_discharge_P*uP_discharge + eta_G*eta_discharge_P*uP_rev + eta_G*LPT*u_charge_T + u_Charge_E(t) < = 0
%  T1   -            T2                +           T3           -      T4        +         T5          +       T6    -                T7                  +         T8                   +        T9      +    T10

idx = length(Z);
idx = idx + 1;

% Number of controls and states
N_Control  = Opts.DTQP.subsys.Nu_G+Opts.DTQP.subsys.Nu_S;
N_State = Opts.DTQP.subsys.Nx_G+Opts.DTQP.subsys.Nx_S;


% Create a zero vector
Control_mat = zeros(N_Control,1);
State_mat = zeros(N_State,1);


% T1
Z(idx).linear(1).right = 2; Z(idx).linear(1).matrix = State_mat;

% T2
Z(idx).linear(2).right = 1; Z(idx).linear(2).matrix = Control_mat;

% T3
Z(idx).linear(3).right = 1; Z(idx).linear(3).matrix = Control_mat;

% T4
Z(idx).linear(4).right = 2; Z(idx).linear(4).matrix = State_mat;

% T5
Z(idx).linear(5).right = 1; Z(idx).linear(5).matrix = Control_mat;

% T6
Z(idx).linear(6).right = 2; Z(idx).linear(6).matrix = State_mat;

% T7
Z(idx).linear(7).right = 1; Z(idx).linear(7).matrix = Control_mat;

% T8
Z(idx).linear(8).right = 1; Z(idx).linear(8).matrix = Control_mat;

% T9 
Z(idx).linear(9).right = 1; Z(idx).linear(9).matrix = Control_mat;

% T10
Z(idx).linear(10).right = 1; Z(idx).linear(10).matrix = Control_mat;

% Constraint bound
Z(idx).b = 0;




idx_State_G = auxdata.IDX.Generator.State;

% T1:  LE*xG
Z(idx).linear(1).matrix(idx_State_G,1) = auxdata.Loads.LE;

% -T4: -eta_G*x_gen(t)
Z(idx).linear(4).matrix(idx_State_G,1) = -auxdata.Generator.eta_G;

% T6: eta_G*LP*xG
Z(idx).linear(6).matrix(idx_State_G,1) = auxdata.Generator.eta_G*auxdata.Loads.LP_G;




if isfield(auxdata.IDX,'Storage') && isfield(auxdata.IDX.Storage,'Primary')

    idx_Control_S = auxdata.IDX.Storage.Primary.Control;
    u_charge_idx = idx_Control_S(1,1);
    u_discharge_idx = idx_Control_S(2,1);
    u_rev_idx = idx_Control_S(3,1);

    eta_p_discharge = auxdata.Storage.eta2_S;


    % T5: eta_G*u_Charge_P(t)
    Z(idx).linear(5).matrix(u_charge_idx,1) = auxdata.Generator.eta_G;

    % -T7: - eta_G*eta_discharge_P*uP_discharge
    Z(idx).linear(7).matrix(u_discharge_idx,1) = -auxdata.Generator.eta_G*eta_p_discharge;

    % T8: eta_G*eta_discharge_P*uP_rev
    Z(idx).linear(8).matrix(u_rev_idx,1) = auxdata.Generator.eta_G*eta_p_discharge;

end

if isfield(auxdata.IDX,'Storage') && isfield(auxdata.IDX.Storage,'Electrical')

    idx_Control_S = auxdata.IDX.Storage.Electrical.Control;
    u_charge_idx = idx_Control_S(1,1);
    u_discharge_idx = idx_Control_S(2,1);
    u_rev_idx = idx_Control_S(3,1);
    eta_e_discharge = auxdata.Storage.eta2_S;


    % -T2: - eta_discharge_E*uE_discharge
    Z(idx).linear(2).matrix(u_discharge_idx,1) = -eta_e_discharge;

    % T3: eta_discharge_E*uE_rev
    Z(idx).linear(3).matrix(u_rev_idx,1) = eta_e_discharge;

    % T10: u_Charge_E(t)
    Z(idx).linear(10).matrix( u_charge_idx,1) = 1;

end


if isfield(auxdata.IDX,'Storage') && isfield(auxdata.IDX.Storage,'Tertiary')

    % T9
    idx_Control_S   = auxdata.IDX.Storage.Tertiary.Control;
    u_charge_idx    = idx_Control_S(1,1);
    Z(idx).linear(9).matrix(u_charge_idx,1) = auxdata.Generator.eta_G*auxdata.Loads.LP_T;

end




end
