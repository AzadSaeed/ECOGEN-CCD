function L = Lagrane_Primary_Storage(L,auxdata,Opts)
% This function creates all the Lagrange terms associated with the primary
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

% Extract appropriate indices for the primary storage
idx_Plant_S = auxdata.IDX.Storage.Primary.Plant;
idx_Control_S = auxdata.IDX.Storage.Primary.Control;

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
c_primary       = auxdata.PriceFunctions.Primary;
c_electricity   = auxdata.PriceFunctions.c_electricity;

% Efficiencies
eta_p_charge    = auxdata.Storage.eta1_S;
eta_p_discharge = auxdata.Storage.eta2_S;
eta_G           = auxdata.Generator.eta_G;

% Costs
FOM_S           = auxdata.Storage.FOM_S;
VOM_S           = auxdata.Storage.VOM_S;


%--------------------------------------------------------------%
%----------------------- Revenue Terms ------------------------%
%--------------------------------------------------------------%

% Term 1 minimize  -c_primary*eta_P_discharge*uPR
idx = idx + 1;
L(idx).left   = 0;
L(idx).right  = 1;
L(idx).matrix =  Control_mat;
L(idx).matrix{1,u_rev_idx} = @(t)-(1./f_scale)*(c_primary(t)*eta_p_discharge)./(1+r).^year(t);


% Term 2 minimize c_elec*eta_G*u_charge 
idx = idx + 1;
L(idx).left   = 0;
L(idx).right  = 1;
L(idx).matrix = Control_mat;
L(idx).matrix{1,u_charge_idx} = @(t)(1./f_scale)*(c_electricity(t)*eta_G)./(1+r).^year(t);

% Term 3 minimize c_elec*eta_G*eta_P_discharge*uP_discharge
idx = idx + 1;
L(idx).left   = 0;
L(idx).right  = 1;
L(idx).matrix = Control_mat;
L(idx).matrix{1,u_discharge_idx} = @(t)-(1./f_scale)*(c_electricity(t)*eta_G*eta_p_discharge)./(1+r).^year(t);

% Term 4 minimize c_elec*eta_G*eta_P_discharge*uPR
idx = idx + 1;
L(idx).left   = 0;
L(idx).right  = 1;
L(idx).matrix =  Control_mat;
L(idx).matrix{1,u_rev_idx} = @(t)(1./f_scale)*(c_electricity(t)*eta_G*eta_p_discharge)./(1+r).^year(t);


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
L(idx).matrix{1,u_charge_idx} = @(t)(1./f_scale)*(eta_p_charge*VOM_S)./(1+r).^year(t);
L(idx).matrix{1,u_discharge_idx} = @(t)(1./f_scale)*(VOM_S)./(1+r).^year(t);


end



