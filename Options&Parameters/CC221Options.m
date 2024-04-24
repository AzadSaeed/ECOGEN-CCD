function [out,T] = CC221Options(TimeFlag)

% Information from EIA
%-----------------------------------------------------------------------%
% Net Nominal Capacity [MW]
Nom_Cap = 1080;

% Overnight Construction Cost [$/kW]
OCC = 958;

% Fixed O&M [$/kW-year]
FOM =  12.20;

% Variable O&M [$/MWh]
VOM = 1.87;
%-----------------------------------------------------------------------%




% Cost Elements
%-----------------------------------------------------------------------%
% Fixed capital investment to realize generator [$]
out.C_g = Nom_Cap*OCC*1000;
%-----------------------------------------------------------------------%

%-----------------------------------------------------------------------%
% FOM of generator for each year [$/year]
C_g_fom = Nom_Cap*FOM*1000;
%-----------------------------------------------------------------------%

%-----------------------------------------------------------------------%
% Power-level dependent portion [$/MWh]
C_g_vom = VOM;
%-----------------------------------------------------------------------%


% Plant Operational limits 
%-----------------------------------------------------------------------%
% Minimum requested power from generator [MW] - control lower bound
out.u_gmin = 0;
%-----------------------------------------------------------------------%

%-----------------------------------------------------------------------%
% Minimum power plant power level - state [MW]
out.x_gmin = 0;
%-----------------------------------------------------------------------%

%-----------------------------------------------------------------------%
% Maximum requested power from generator [MW] - control upper bound
out.u_gmax = Nom_Cap;
%-----------------------------------------------------------------------%










% Unchanged from NGCC

%-----------------------------------------------------------------------%
% Conversion between power output by NGCC and fuel consumed [kg NG/s/MW] 
rho_f  = 0.04082;
%-----------------------------------------------------------------------%

%-----------------------------------------------------------------------%
% Conversion coefficient [ton co2/kg of NG]
alpha_c = 0.0029;
%-----------------------------------------------------------------------%

%-----------------------------------------------------------------------%
% Maximum requested power from generator [MW] - control upper bound
mu_power = 0.9;             % Efficiency
powernominal_max = 634.741; % [MW]
out.u_gmax = mu_power*powernominal_max;
%-----------------------------------------------------------------------%



%-----------------------------------------------------------------------%
% Maximum power plant power level - state [MW]
out.x_gmax = mu_power*powernominal_max;
%-----------------------------------------------------------------------%

%-----------------------------------------------------------------------%
% Initial power level of the power plant - state [MW]
out.x_g0 = 0;
%-----------------------------------------------------------------------%

%-----------------------------------------------------------------------%
% Time constant for the ramp rate [s]
tau = 500;
%-----------------------------------------------------------------------%

%-----------------------------------------------------------------------%
% Efficiency of energy conversion in the generator
out.eta_g = 1;
%-----------------------------------------------------------------------%

%-----------------------------------------------------------------------%
% Time-dependent parameters
switch upper(TimeFlag)
    case 'HOUR'
        t1 = 3600;
        t2 = 1;
        t3 = (1/365)*(1/24);
    case 'DAY'
        t1 = 24*3600;
        t2 = 24;
        t3 = (1/365);
end

out.rho_f = rho_f*t1;
out.C_g_vom = C_g_vom*t2;
out.C_g_fom = C_g_fom*t3;
out.tau = (tau)*(1/t1);
%-----------------------------------------------------------------------%


%-----------------------------------------------------------------------%
% cn: % of co2 captured by any carbon capture system
cn = 0;
%-----------------------------------------------------------------------%

%-----------------------------------------------------------------------%
% Factor showing temperature dependence of carbon capture
mu_c = 1;
%-----------------------------------------------------------------------%

%-----------------------------------------------------------------------%
% Factor for fuel consumption based on ambient temperature ER (Eq.17)
mu_f = 1;
%-----------------------------------------------------------------------%

%-----------------------------------------------------------------------%
% Co2 emitted by the system in [ton co2/time/MW] (Eq.21)
out.rho_c_out = alpha_c*out.rho_f*mu_f*(1-cn*mu_c);
%-----------------------------------------------------------------------%



% Create a table foe better visualization of all needed parameters
%-------------------------------------------------------------------------%
Parameter = ["C_g"; "rho_f"; "alpha_c"; "cn"; "C_g_vom"; "C_g_fom"; "u_gmin"; ...
    "u_gmax"; "x_gmin"; "x_gmax"; "x_g0"; "tau"; "eta_g"];

BaseValues = [out.C_g; rho_f; alpha_c; cn;C_g_vom; C_g_fom; out.u_gmin; ...
    out.u_gmax; out.x_gmin; out.x_gmax; out.x_g0; tau; out.eta_g];

switch upper(TimeFlag)
    case 'HOUR'
        coeff = [1;3600;1;1;1;1/(365*24); 1; 1; 1; 1; 1; (1/3600); 1];
        unit  = ["$"; "kg NG/h/MW"; "ton Co_2/kg NG";"$/MWh";"-"; "$/h";...
            "MW"; "MW"; "MW"; "MW"; "MW"; "h"; "-"];
    case 'DAY'
        coeff = [1;3600*24;1;24;1;1/(365); 1; 1; 1; 1; 1; (1/(24*3600)); 1];
        unit  = ["$"; "kg NG/day/MW"; "ton Co_2/kg NG"; "$/MWh";"-" "$/day";...
            "MW"; "MW"; "MW"; "MW"; "MW"; "day"; "-"];
end

T = table(Parameter,coeff.*BaseValues,unit);
%-----------------------------------------------------------------------%
end