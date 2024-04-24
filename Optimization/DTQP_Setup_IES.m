function [setup,opts,auxdata]  = DTQP_Setup_IES(Opts, varargin)
% This function creates the problem structure to be solved using DTQP.

if nargin > 1
    auxdata = varargin{:};
else
    auxdata = [];
end


% Avoid DTQP_standardizedinputs and instead write your own function 
[auxdata,opts] = StdDTQPin(Opts, auxdata);

% Number of plants, States, and Controls
N_Plant    = Opts.DTQP.subsys.Np_G+Opts.DTQP.subsys.Np_S;
N_State    = Opts.DTQP.subsys.Nx_G+Opts.DTQP.subsys.Nx_S;
N_Control  = Opts.DTQP.subsys.Nu_G+Opts.DTQP.subsys.Nu_S;

% set up
t0 = opts.general.t0;
tf = opts.general.tf;


% Mayer terms
M  = MayerFunction(Opts, auxdata);
setup.M = M;

% Lagrange terms
L  = LagrangeFunction(Opts, auxdata);
setup.L = L; 


% Create matrices Ax + Bu + Gx_p + D

if isfield(auxdata.IDX,'Generator')

    idx_State_G = auxdata.IDX.Generator.State ;
    idx_Control_G = auxdata.IDX.Generator.Control;
else

    error('Generator must be defined')
end

% A matrix (nx by nx)
A = zeros(N_State,N_State);
A(idx_State_G,idx_State_G) = -1/auxdata.Generator.tau_G;
setup.A = A;

% B matrix (nx by nu)
B = zeros(N_State, N_Control);
B(idx_State_G,idx_Control_G) = 1/auxdata.Generator.tau_G;

% Extract appropriate indices for the primary storage
if isfield(auxdata.IDX,'Storage')

    if isfield(auxdata.IDX.Storage,'Primary')
        
        eta_p_charge = auxdata.Storage.eta1_S;

        idx_State_S = auxdata.IDX.Storage.Primary.State ;
        idx_Control_S = auxdata.IDX.Storage.Primary.Control;

        u_charge_idx = idx_Control_S(1,1);
        u_discharge_idx = idx_Control_S(2,1);

        B(idx_State_S,u_charge_idx) = eta_p_charge*1;
        B(idx_State_S,u_discharge_idx) = -1;

    elseif isfield(auxdata.IDX.Storage,'Electrical')

        eta_e_charge = auxdata.Storage.eta1_S;

        idx_State_S = auxdata.IDX.Storage.Electrical.State ;
        idx_Control_S = auxdata.IDX.Storage.Electrical.Control;

        u_charge_idx = idx_Control_S(1,1);
        u_discharge_idx = idx_Control_S(2,1);

        B(idx_State_S,u_charge_idx) = eta_e_charge*1;
        B(idx_State_S,u_discharge_idx) = -1;

    elseif isfield(auxdata.IDX.Storage,'Tertiary')

        eta_t_charge  = auxdata.Storage.eta1_S;
        CF_E2T = auxdata.Storage.eta_c_E2T;

        idx_State_S = auxdata.IDX.Storage.Tertiary.State ;
        idx_Control_S = auxdata.IDX.Storage.Tertiary.Control;

        u_charge_idx = idx_Control_S(1,1);
        u_discharge_idx = idx_Control_S(2,1);

        B(idx_State_S,u_charge_idx) = (1/CF_E2T)*eta_t_charge*1;
        B(idx_State_S,u_discharge_idx) = -1;
    end
end

setup.B = B;

% G matrix (nx by np)
G = zeros(N_State,N_Plant); 
setup.G = G;

% simple bounds
[LB, UB] = BoundsFunction(auxdata, Opts);

% Path Constraints
Z = PathConstraints(auxdata, Opts);
setup.Z = Z;

% number of controls, states, and plants
n.nu = Opts.DTQP.subsys.Nu_G+Opts.DTQP.subsys.Nu_S;
n.ny = Opts.DTQP.subsys.Nx_G+Opts.DTQP.subsys.Nx_S;
n.np = Opts.DTQP.subsys.Np_G+Opts.DTQP.subsys.Np_S;

% combine structures
setup.UB = UB; setup.LB = LB; setup.n = n;
setup.t0 = t0; setup.tf = tf; setup.auxdata = auxdata;


% Scale the problem
if isfield(auxdata.IDX,'Storage')
    if auxdata.Storage.x_S0 ~=0
        Xs_scale = abs(auxdata.Storage.x_S0);
    else
        Xs_scale = 1;
    end

    if auxdata.Storage.u3_Smax ~=0
        U3s_scale = abs(auxdata.Storage.u3_Smax);
    else
        U3s_scale = 1;
    end

else
    Xs_scale = [];
    auxdata.Storage.u1_Smax = [];
    auxdata.Storage.u2_Smax = [];
    U3s_scale = [];
end

setup.scaling(1).right = 2; % states
setup.scaling(1).matrix = [auxdata.Generator.x_Gmax; Xs_scale];
setup.scaling(2).right = 1; % controls
setup.scaling(2).matrix = [auxdata.Generator.u_Gmax; auxdata.Storage.u1_Smax; auxdata.Storage.u2_Smax; U3s_scale];


end


%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%

function [auxdata,opts] = StdDTQPin(Opts, varargin)

% number of inputs
n = length(varargin);

% get user options for this example
opts = Opts.DTQP;

% potentially add inputs to p or opts
if n >= 1
    auxdata = varargin{1};
end

end

%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%

