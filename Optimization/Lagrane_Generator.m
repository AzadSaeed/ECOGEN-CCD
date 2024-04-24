function L = Lagrane_Generator(auxdata,Opts)
% This function creates all the Lagrange terms associated with the
% generator.
%
% Saeed Azad, PhD


% Thermal to electrical efficiency of power plant
eta_G = auxdata.Generator.eta_G;

% Electricity price function
c_electricity = auxdata.PriceFunctions.c_electricity;

% Primary load 
LP_G = auxdata.Loads.LP_G;

% Electrical load
LE = auxdata.Loads.LE;

% Rate of return
r  = auxdata.Economics.r;

% Year function based on 365.25 days 
year = auxdata.Economics.year;

% Scaling factor for objective function
f_scale = auxdata.Scale.f;

% Number of states
N_State  = Opts.DTQP.subsys.Nx_G+Opts.DTQP.subsys.Nx_S;

% Create cells for matrices
State_mat = repmat({zeros(1,1)},1,N_State);

% Extract appropriate indices for the generator
idx_State_G = auxdata.IDX.Generator.State ;

% Parameters
rho_fuel        = auxdata.Generator.rho_fuel;
alpha_co2       = auxdata.Generator.alpha_co2;

% Price Signals
c_fuel_front    = auxdata.PriceFunctions.Fuel_Front;
c_fuel_back     = auxdata.PriceFunctions.Fuel_Back;
c_co2           = auxdata.PriceFunctions.c_carbon;

% Costs
FOM_G     = auxdata.Generator.FOM_G;
VOM_G     = auxdata.Generator.VOM_G;


%--------------------------------------------------------------%
%----------------------- Revenue Terms ------------------------%
%--------------------------------------------------------------%

% Term G1: minimize  -C_elec*eta_G*x_G
idx = 1;
L(idx).left = 0;
L(idx).right = 2;
L(idx).matrix = State_mat;
L(idx).matrix{1,idx_State_G} = @(t)(1./f_scale)*(-eta_G*c_electricity(t))./(1+r).^year(t);


% Term G2: minimize C_elec*eta_G*LP_G*xG
idx = idx + 1;
L(idx).left = 0;
L(idx).right = 2;
L(idx).matrix = State_mat;
L(idx).matrix{1,idx_State_G} = @(t)(1./f_scale)*(LP_G*eta_G*c_electricity(t))./(1+r).^year(t);



% Term G3: minimize C_elec*LE*xG
idx = idx + 1;
L(idx).left = 0;
L(idx).right = 2;
L(idx).matrix = State_mat;
L(idx).matrix{1,idx_State_G} = @(t)(1./f_scale)*(LE*c_electricity(t))./(1+r).^year(t);


%--------------------------------------------------------------%
%----------------------- Expense Terms ------------------------%
%--------------------------------------------------------------%

% Term 1: fuel front-end --- minimize rho_fuel*c_fuel*x_G
idx = idx + 1;
L(idx).left = 0;
L(idx).right = 2;
L(idx).matrix = State_mat;
L(idx).matrix{1,idx_State_G} = @(t)(1./f_scale)*(c_fuel_front(t)*rho_fuel)./(1+r).^year(t);


% Term 2: fuel backend --- minimize rho_fuel*c_Back_end*x_G
idx = idx + 1;
L(idx).left = 0;
L(idx).right = 2;
L(idx).matrix = State_mat;
L(idx).matrix{1,idx_State_G} = @(t)(1./f_scale)*(c_fuel_back(t)*rho_fuel)./(1+r).^year(t);


% Term 3: co2 --- minimize c_co2*alpha_co2*rho_fuel*x_G
idx = idx + 1;
L(idx).left = 0;
L(idx).right = 2;
L(idx).matrix = State_mat;
L(idx).matrix{1,idx_State_G} = @(t)(1./f_scale)*(c_co2(t)*rho_fuel*alpha_co2)./(1+r).^year(t);

% Term 4: FO&M
idx = idx + 1;
L(idx).left = 0;
L(idx).right = 0;
L(idx).matrix = @(t)(1./f_scale)*(FOM_G)./(1+r).^year(t);

% Term 5: Vo&M
idx = idx + 1;
L(idx).left = 0;
L(idx).right = 2;
L(idx).matrix = State_mat;
L(idx).matrix{1,idx_State_G} = @(t)(1./f_scale)*(VOM_G)./(1+r).^year(t);

end