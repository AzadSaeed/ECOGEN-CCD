function [out, T] = ThermalStorageOptions(TimeFlag)

%-----------------------------------------------------------------------%
% Capital cost for storage medium [$/MWhr of energy storage]
out.C_s = 1.048947*10^6;
%-----------------------------------------------------------------------%

%-----------------------------------------------------------------------%
% Charging/discharging by storage [$/MWh]
C_s_vom  = 0.75;
%-----------------------------------------------------------------------%

%-----------------------------------------------------------------------%
% FOM of charge of storage for each year [$/MW/year]
C_s_in_fom = 2.5881*10^3;
%-----------------------------------------------------------------------%

%-----------------------------------------------------------------------%
% FOM of discharge of storage for each year [$/MW/year]
C_s_out_fom = 4.12186*10^3;
%-----------------------------------------------------------------------%

%-----------------------------------------------------------------------%
% FOM of storage system [$/MWhr of storage/year]
C_s_fom     = 41.9579*10^3;
%-----------------------------------------------------------------------%

%-----------------------------------------------------------------------%
% Minimum storage capacity - plant lower bound
out.p_min = 0;
%-----------------------------------------------------------------------%

%-----------------------------------------------------------------------%
% Maximum storage capacity - plant upper bound
out.p_max = Inf;
%-----------------------------------------------------------------------%

%-----------------------------------------------------------------------%
% Minimum input power to storage [MW] - control lower bound
out.u1_smin = 0;
%-----------------------------------------------------------------------%

%-----------------------------------------------------------------------%
% Minimum output power from storage [MW] - control lower bound
out.u2_smin = 0;
%-----------------------------------------------------------------------%

%-----------------------------------------------------------------------%
% Maximum input power to storage [MW] - control upper bound
mu_powerin  = 0.9;     % Storage charging efficiency
ratein_max  = 840.515; % Maximum energy rate [MW] into the storage
out.u1_smax = mu_powerin*ratein_max;
%-----------------------------------------------------------------------%

%-----------------------------------------------------------------------%
% Maximum input power to storage [MW] - control upper bound
mu_powerout = 0.9;     % Storage discharging efficiency
rateout_max = 45.2353; % Maximum energy rate [MW] out of storage
out.u2_smax = mu_powerout*rateout_max;
%-----------------------------------------------------------------------%

%-----------------------------------------------------------------------%
% Initial stored thermal energy - state [MWh]
out.x_s0 = 2;
%-----------------------------------------------------------------------%

%-----------------------------------------------------------------------%
% Final stored thermal energy - state [MWh]
out.x_sf = 2;
%-----------------------------------------------------------------------%

%-----------------------------------------------------------------------%
% B matrix components [MWhr of energy storage/MW/time]
% k_in   = 0.005949; % in [MWhr of energy storage/MW per hour?--confirm]
% k_out  = 0.02211;  % in [MWhr of energy storage/MW per minute?--confirm]
k_in   = 1; % in [MWhr of energy storage/MW per hour?--confirm]
k_out  = 1;  % in [MWhr of energy storage/MW per minute?--confirm]

%-----------------------------------------------------------------------%

%-----------------------------------------------------------------------%
% Time-dependent parameters
switch upper(TimeFlag)
    case 'HOUR'
        t1 = 1;
        t2 = (1/24)*(1/365);
    case 'DAY'
        t1 = 24;
        t2 = (1/365);
end

% [$/MWh in an hour] or [$/MWh in a day]
out.C_s_vom = C_s_vom*t1;

% [$/MW/hr] or [$/MW/day]
out.C_s_in_fom = C_s_in_fom*t2;

% [$/MW/hr] or [$/MW/day]
out.C_s_out_fom = C_s_out_fom*t2;

% [$/MWhr of storage/hour] or [$/MWhr of storage/day]
out.C_s_fom = C_s_fom*t2;

% [MWh of storage/MW/h] or [MWh of storage/MW/day]
out.k_in  = k_in*t1;
out.k_out = k_out*t1;

%-----------------------------------------------------------------------%

%-----------------------------------------------------------------------%
% Efficiency of storage discharge
out.eta_s = 1;
%-----------------------------------------------------------------------%

%-----------------------------------------------------------------------%
% Maximum energy rate [MW] into the storage
out.ratein_max  = 840.515;
%-----------------------------------------------------------------------%

%-----------------------------------------------------------------------%
% Maximum energy rate [MW] out of storage
out.rateout_max  = 45.2353;
%-----------------------------------------------------------------------%


% Create a table foe better visualization of all needed parameters
%-----------------------------------------------------------------------%
Parameter = ["C_s"; "C_s_vom"; "C_s_in_fom"; "C_s_out_fom"; "C_s_fom";...
    "p_min"; "p_max"; "u_1min"; "u_2min"; "u_1max"; "u_2max"; "x_s0";...
    "x_sf"; "k_in"; "k_out";"eta_s"; "ratein_max"; "rateout_max"];
BaseValues = [1.048947*10^6; 0.75; 2.5881*10^3; 4.12186*10^3; 41.9579*10^3;...
    0; inf; 0; 0; 0.9*840.515;0.9*45.2353; 50; 50; 0.005949; 0.02211; 1;...
    out.ratein_max;out.rateout_max];

switch upper(TimeFlag)
    case 'HOUR'
        coeff = [1;1;1/(24*365);1/(24*365);1/(24*365); 1; 1; 1; 1; 1; 1;...
            1; 1; 1; 1; 1; 1; 1];
        unit  = ["$/MWh"; "$/MWh"; "$/MW/h"; "$/MW/h"; "$/MWH/h";...
            "MWh"; "MWh"; "MW"; "MW"; "MW"; "MW"; "MWh"; "MWh"; "MWh/MW/h";...
            "MWh/MW/h";"-";"MW";"MW"];
    case 'DAY'
        coeff = [1;24;1/(365);1/(365);1/(365); 1; 1; 1; 1; 1; 1;...
            1; 1; 24; 24; 1; 1; 1];
        unit  = ["$/MWh"; "$/MWh"; "$/MW/day"; "$/MW/day"; "$/MWH/day";...
            "MWh"; "MWh"; "MW"; "MW"; "MW"; "MW"; "MWh"; "MWh"; "MWh/MW/day";...
            "MWh/MW/day";"-"; "MW"; "MW"];
end

T = table(Parameter,coeff.*BaseValues,unit);
%-----------------------------------------------------------------------%
end


