function L = Lagrane_Electrical_Storage(L,auxdata,Opts)
% This function creates all the Lagrange terms asociated with the
% electrical (secondary) storage system.
%
% Saeed Azad, PhD

idx = length(L);

% Create the state matrix of the apropriate size
N_plant = Opts.DTQP.subsys.Np_G+Opts.DTQP.subsys.Np_S;
N_Control = Opts.DTQP.subsys.Nu_G+Opts.DTQP.subsys.Nu_S;

% Create cells for matrices
Plant_mat = repmat({zeros(1,1)},1,N_plant);
Control_mat = repmat({zeros(1,1)},1,N_Control);

idx_Plant_S = auxdata.IDX.Storage.Electrical.Plant;
idx_Control_S = auxdata.IDX.Storage.Electrical.Control;

u_charge_idx = idx_Control_S(1,1);
u_discharge_idx = idx_Control_S(2,1);

% scaling factor for objective function
f_scale = auxdata.Scale.f;

% Rate of return
r  = auxdata.Economics.r;

% Year function based on 365.25 days
year = auxdata.Economics.year;

% price signals
c_electricity   = auxdata.PriceFunctions.c_electricity;

% Efficiencies
eta_e_charge    = auxdata.Storage.eta1_S;
eta_e_discharge = auxdata.Storage.eta2_S;

% Costs
FOM_S = auxdata.Storage.FOM_S;
VOM_S = auxdata.Storage.VOM_S;



%--------------------------------------------------------------%
%----------------------- Revenue Terms ------------------------%
%--------------------------------------------------------------%

% Term 1 minimize c_elec*u_E_charge
idx = idx + 1;
L(idx).left   = 0;
L(idx).right  = 1;
L(idx).matrix = Control_mat;
L(idx).matrix{1,u_charge_idx} = @(t)(1./f_scale)*(c_electricity(t))./(1+r).^year(t);


% Term 2 minimize -c_elec*eta_E_discharge*u_E_discharge
idx = idx + 1;
L(idx).left   = 0;
L(idx).right  = 1;
L(idx).matrix = Control_mat;
L(idx).matrix{1,u_discharge_idx} = @(t)-(1./f_scale)*(c_electricity(t)*eta_e_discharge)./(1+r).^year(t);



%--------------------------------------------------------------%
%----------------------- Expense Terms ------------------------%
%--------------------------------------------------------------%

% Term 5 minimize Fo&M
idx = idx + 1;
L(idx).left = 0;
L(idx).right = 3;
L(idx).matrix = Plant_mat;
L(idx).matrix{1,idx_Plant_S} =  @(t)(1./f_scale)*(FOM_S)./(1+r).^year(t);

% Term 6 minimize VO&M
idx = idx + 1;
L(idx).left = 0;
L(idx).right = 1;
L(idx).matrix = Control_mat;
L(idx).matrix{1,u_charge_idx} =  @(t)(1./f_scale)*(eta_e_charge*VOM_S)./(1+r).^year(t);
L(idx).matrix{1,u_discharge_idx} =  @(t)(1./f_scale)*(VOM_S)./(1+r).^year(t);


end