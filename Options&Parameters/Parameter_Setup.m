function [Gen_aux, Storage_aux] = Parameter_Setup
% This functions pre-defined the required parameters for generator and 
% storage as zero. 
%
% 
% Primary Contributor: Saeed Azad, PhD


% Generator:

% Overnight capital cost for the generator [$]
Gen_aux.OCC_G = 0;

% Fixed O&M cost in [$/time]
Gen_aux.FOM_G = 0;

% Variable O&M cost in [$/MW-time]
Gen_aux.VOM_G = 0;

% Conversion factor between power and fuel consumed in [kg fuel/time/MW]
Gen_aux.rho_fuel = 0;

% Conversion factor between fuel and CO2  in [ton Co_2 per kg fuel]
Gen_aux.alpha_co2 = 0;

% Ramp rate in [Time]
Gen_aux.tau_G = 0;

% Primary to electrical energy efficiency in the generator
Gen_aux.eta_G = 0;

% Minimum requested power from generator [MW] - control lower bound
Gen_aux.u_Gmin = 0;

% Maximum requested power from generator [MW] - control upper bound
Gen_aux.u_Gmax = 0;

% Minimum power plant power level - state [MW]
Gen_aux.x_Gmin = 0;

% Maximum power plant power level - state [MW]
Gen_aux.x_Gmax = 0;

% Initial power level of the power plant - state [MW]
Gen_aux.x_G0 = 0;


%------------------------------------------------------------------------%

% Overnight capital cost for the storage [$/MW-time]
Storage_aux.OCC_S = 0;

% Fixed O&M cost in [$/MWh/time] 
Storage_aux.FOM_S = 0;

% Variable O&M cost in [$/MW-time] 
Storage_aux.VOM_S = 0;

% Minimum storage capacity - plant lower bound [MW-time] or [kg] or [other]
Storage_aux.P_Smin = 0;

% Maximum storage capacity - plant upper bound
Storage_aux.P_Smax = 0;

% Minimum input power to storage [MW] - control lower bound
Storage_aux.u1_Smin = 0;

% Minimum output power from storage - control lower bound [MW] or [kg/time]
Storage_aux.u2_Smin = 0;

% Minimum revenue portion of control - control lower bound
Storage_aux.u3_Smin = 0;

% Maximum input power to storage [MW] - control upper bound
Storage_aux.u1_Smax = 0;

% Maximum output power from storage - control upper bound [MW] or [kg/time]
Storage_aux.u2_Smax = 0;

% Maximum revenue portion of control - control upper bound
Storage_aux.u3_Smax = 0;

% Initial stored energy - state [MWh] or [kg]
Storage_aux.x_S0 = 0;

% Final stored energy - state [MWh] or [kg]
Storage_aux.x_Sf = 0;

% Efficiency of charge
Storage_aux.eta1_S = 0;

% Efficiency of discharge
Storage_aux.eta2_S = 0;

% Conversion Efficiency (electricity to tertiary)
Storage_aux.eta_c_E2T = 0;

% Conversion Efficiency (tertiary to electricity)
Storage_aux.eta_c_T2E = 0;

end