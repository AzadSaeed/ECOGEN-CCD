function Gen_aux = GeneratorOptions2(GeneratorFlag, Gen_aux, TimeFlag, varargin)

% This function creates the requires parameters for various electricity
% generator technologies. The parameters are mostly taken from the report
% developed for the U.S. Energy Information Administration (EIA) by Sargent
% & Lundy in 2020, titled:
% "Capital Cost and Performance Characteristic Estimates for Utility
% Scale Electric Power Generating Technologies"
%
% Required fields for the generator:
%
%   Net Nomical Capacity  ------------------- [kW]
%   Overnight Construction Cost ------------- [$/kW]
%   Fixed O&M cost -------------------------- [$/kW/year]
%   variable O&M cost ----------------------- [$/MWh]
%   Fuel conversion rate rho_fuel ----------- [kg fuel/s/MW]
%   CO2 generation rate alpha_co2 ----------- [ton Co2 per kg fuel]
%   Ramp rate ------------------------------- [s]
%   Efficiency ------------------------------ [-]
%
% Primary Contributor: Saeed Azad, PhD
% January 2024


Fields = {'Net Nominal Capacity';...
    'Overnight construction cost';...
    'Fixed O&M';...
    'Variable O&M';...
    'rho_fuel';...
    'alpha_co2';
    'ramp rate';
    'Efficiency'};
Units  = {'kW';'$/kW';'$/kW/year'; '$/MWh'; 'kg fuel/s/MW';...
    'ton co2 per kg fuel'; 's'; '-'};

switch GeneratorFlag{1,1}

    case 'CC221'

        Par    = [1083000; 958; 12.20; 1.87; 0.04082; 0.0029; 500; 1];

    case 'ONSHORE_WIND'

        Par    = [200000; 1265; 26.34; 0; 0; 0; 5; 1];

    case 'ADVANCED_NUCLEAR'

        Par    = [2156000; 6041; 121.64; 2.37; 0.001/3600; 0; 1.7967; 1];
        % Par    = [2156000; 9000; 121.64; 2.37; 0.001/3600; 0; 1.7967; 1];

    otherwise

        error('Generator parameters are not defined! ')
end


% Coefficients for time adjustment
[t_rho_fuel,t_VOM, t_FOM, t_ramp] = TimeCoefficients_Gen(TimeFlag);


%---------------------------------------------------------------------%
% Overnight capital cost for the generator [$]
Gen_aux.OCC_G = Par(1)*Par(2);
%---------------------------------------------------------------------%

%---------------------------------------------------------------------%
% Fixed O&M cost of generator in correct units [$/hour] or [$/day]
Gen_aux.FOM_G = t_FOM*Par(1)*Par(3);
%---------------------------------------------------------------------%

%---------------------------------------------------------------------%
% Variable O&M cost of generator in correct units [$/MWh] or [$/MW day]
Gen_aux.VOM_G = t_VOM*Par(4);
%---------------------------------------------------------------------%

%---------------------------------------------------------------------%
% Conversion between power output and fuel consumed in the correct
% unit [kg fuel/hour/MW] or [kg fuel/day/MW]
Gen_aux.rho_fuel = t_rho_fuel*Par(5);
%---------------------------------------------------------------------%

%---------------------------------------------------------------------%
% ton of CO2 produced per kg of fuel
Gen_aux.alpha_co2 = Par(6);
%---------------------------------------------------------------------%

%---------------------------------------------------------------------%
% Time constant for the ramp rate in corrected units [h] or [day]
Gen_aux.tau_G = t_ramp*Par(7);
%---------------------------------------------------------------------%

%---------------------------------------------------------------------%
% Efficiency of energy conversion in the generator
Gen_aux.eta_G = Par(8);
%---------------------------------------------------------------------%

%---------------------------------------------------------------------%
% Minimum requested power from generator [MW] - control lower bound
Gen_aux.u_Gmin = 0;
%---------------------------------------------------------------------%

%---------------------------------------------------------------------%
% Maximum requested power from generator [MW] - control upper bound
Gen_aux.u_Gmax = Par(1)/1000;
%---------------------------------------------------------------------%

%---------------------------------------------------------------------%
% Minimum power plant power level - state [MW]
Gen_aux.x_Gmin = 0;
%---------------------------------------------------------------------%

%---------------------------------------------------------------------%
% Maximum power plant power level - state [MW]
Gen_aux.x_Gmax = Par(1)/1000;
%---------------------------------------------------------------------%

%---------------------------------------------------------------------%
% Initial power level of the power plant - state [MW]
Gen_aux.x_G0 = 0;
%---------------------------------------------------------------------%

end



%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%

function [t_rho_fuel,t_VOM, t_FOM, t_ramp] = TimeCoefficients_Gen(TimeFlag)

switch upper(TimeFlag)
    case 'HOUR'
        t_rho_fuel = 3600;
        t_VOM = 1;
        t_FOM = (1/365.25)*(1/24);
        t_ramp = 1/3600;
    case 'DAY'
        t_rho_fuel = 24*3600;
        t_VOM = 24;
        t_FOM = (1/365.25);
        t_ramp = (1/3600)*(1/24);
end

end


