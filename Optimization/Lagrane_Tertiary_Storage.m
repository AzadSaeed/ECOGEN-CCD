function L = Lagrane_Tertiary_Storage(L,auxdata,Opts)
% This function creates all the Lagrange terms associated with the tertiary
% storage system.
%
% Saeed Azad, PhD


idx = length(L);

% Create the state matrix of the apropriate size
N_plant = Opts.DTQP.subsys.Np_G+Opts.DTQP.subsys.Np_S;
N_Control = Opts.DTQP.subsys.Nu_G+Opts.DTQP.subsys.Nu_S;

% Create cells for matrices
Plant_mat = repmat({zeros(1,1)},1,N_plant);
Control_mat = repmat({zeros(1,1)},1,N_Control);

% Extract appropriate indices
idx_Plant_S = auxdata.IDX.Storage.Tertiary.Plant;
idx_Control_S = auxdata.IDX.Storage.Tertiary.Control;

u_charge_idx = idx_Control_S(1,1);
u_discharge_idx = idx_Control_S(2,1);
u_rev_idx       = idx_Control_S(3,1);

% Scaling factor for objective function
f_scale = auxdata.Scale.f;

% Rate of return
r  = auxdata.Economics.r;

% Year function based on 365.25 days
year = auxdata.Economics.year;

% price signals
c_tertiary       = auxdata.PriceFunctions.Tertiary;
c_electricity    = auxdata.PriceFunctions.c_electricity;

% Efficiencies
eta_t_charge     = auxdata.Storage.eta1_S;
eta_t_discharge  = auxdata.Storage.eta2_S;
eta_G            = auxdata.Generator.eta_G;

% Electrical to Tertiary conversion
CF_E2T           = auxdata.Storage.eta_c_E2T; 

% Tertiary to Electrical conversion
CF_T2E           = auxdata.Storage.eta_c_T2E;

% Costs
FOM_S = auxdata.Storage.FOM_S;
VOM_S = auxdata.Storage.VOM_S;

% Loads
LPT = auxdata.Loads.LP_T;


%--------------------------------------------------------------%
%----------------------- Revenue Terms ------------------------%
%--------------------------------------------------------------%

% Term 1: minimize C_elec*eta_G*LP*u_charge
idx = idx + 1;
L(idx).left = 0;
L(idx).right = 1;
L(idx).matrix = Control_mat;
L(idx).matrix{1,u_charge_idx} = @(t)(1./f_scale)*(LPT*eta_G*c_electricity(t))./(1+r).^year(t);


% Term 1 minimize c_elec*u_charge
idx = idx + 1;
L(idx).left   = 0;
L(idx).right  = 1;
L(idx).matrix = Control_mat;
L(idx).matrix{1,u_charge_idx} = @(t)(1./f_scale)*(c_electricity(t))./(1+r).^year(t);


% Term 2 minimize -c_elec*eta_t_discharge*u_discharge*(1/CF_E2T)(Tertiary to electricity)
idx = idx + 1;
L(idx).left   = 0;
L(idx).right  = 1;
L(idx).matrix = Control_mat;
L(idx).matrix{1,u_discharge_idx} = @(t)-(1./f_scale)*(c_electricity(t)*(1./CF_T2E)*eta_t_discharge)./(1+r).^year(t);

% Term 3 minimize c_elec*eta_t_discharge*u_discharge*uTR
idx = idx + 1;
L(idx).left   = 0;
L(idx).right  = 1;
L(idx).matrix =  Control_mat;
L(idx).matrix{1,u_rev_idx} = @(t)(1./f_scale)*(c_electricity(t)*eta_t_discharge*(1./CF_T2E))./(1+r).^year(t);

% Term 4 minimize c_tertiary*eta_t_discharge*uTR*u_discharge
idx = idx + 1;
L(idx).left   = 0;
L(idx).right  = 1;
L(idx).matrix = Control_mat;
L(idx).matrix{1,u_rev_idx} = @(t)-(1./f_scale)*(c_tertiary(t)*eta_t_discharge)./(1+r).^year(t);


%--------------------------------------------------------------%
%----------------------- Expense Terms ------------------------%
%--------------------------------------------------------------%

% Term 5 minimize Fo&M
idx = idx + 1;
L(idx).left = 0;
L(idx).right = 3;
L(idx).matrix = Plant_mat;
L(idx).matrix{1,idx_Plant_S} = @(t)(1./f_scale)*(FOM_S)./(1+r).^year(t);

% Term 6 minimize VO&M
idx = idx + 1;
L(idx).left = 0;
L(idx).right = 1;
L(idx).matrix = Control_mat;
L(idx).matrix{1,u_charge_idx} = @(t)(1./f_scale)*((1./CF_E2T)*eta_t_charge*VOM_S)./(1+r).^year(t);
L(idx).matrix{1,u_discharge_idx} = @(t)(1./f_scale)*(VOM_S)./(1+r).^year(t);



end