function Storage_aux = StorageOptions2(StorageFlag, Storage_aux, TimeFlag, varargin)

Fields           = {'Overnight construction cost';...
    'Fixed O&M';...
    'Variable O&M';...
    'Max input rate to storage';
    'Max output rate from storage';
    'Max revenue rate from discharge';
    'Initial state';
    'Final state';
    'Efficiency_in';
    'Efficiency_out';
    'Conversion rate_ E2H';
    'Conversion rate_ H2E'};





switch StorageFlag{1,1}

    case 'THERMAL'

        Units            = {'$/MWh';'$/MWh/year'; '$/MWh'; 'MW'; 'MW'; 'MW'; 'MW';...
            'MW'; '-';'-';'-';'-'};
        Par  = [1.048947*10^6;  41.9579*10^3; 0.75; 200; 200; 0; 25; 25; ...
            1; 1; NaN; NaN];

    case 'BESS'

        Units            = {'$/MWh';'$/MWh/year'; '$/MWh'; 'MW'; 'MW'; 'MW'; 'MW';...
            'MW'; '-';'-';'-';'-'};
        Par  = [347000; 6200; 0; 50; 50; 50; 15; 15; 1; 1; NaN; NaN];

    case 'HYDROGEN_HTSE'

        Units   =  {'$/kg';'$/kg/year'; '$/kg'; 'MW'; 'kg/h'; 'kg/h'; 'kg';...
            'kg'; '-';'-';'MWh/kg h2'; 'kg h2/MWh' };

        % Assume 1065 MW electric power input to storage capacity
        % Assume 7.775*3600 kg ouput capacity per hour
        % Assume overnight capital cost of $600/kg for hydrogen storage (based on page 40 of Frick report)
        % Assume additional capital cost of 545263737/(7.775*3600*24*365.25*30) = 0.0741 $/kg (Page 20 of Frick report)
        % Assume annual operational cost of $70752705, which leads to
        % $70752705/(7.775*3600*24*365.25) = 0.2884 $/kg  (based on page 21 of Frick report)
        Par  = [600+0.0741; 0; 0.2884; 1065; 27990; 27990; 50; 50; 1; ...
            1; (1056)/(7.775*3600); (10^6)/33600];

    otherwise

        error('Storage parameters are not defined! ')

end

% Coefficients for time adjustment
[t_FOM, t_VOM] = TimeCoefficients_Storage(TimeFlag);

%----------------------------------------------------------------%
% Overnight capital cost for the storage [$/MWh]
Storage_aux.OCC_S = Par(1);
%----------------------------------------------------------------%

%----------------------------------------------------------------%
% Fixed O&M cost of storage in correct units [$/MWh/hour] or [$/MWh/day]
Storage_aux.FOM_S = t_FOM*Par(2);
%----------------------------------------------------------------%

%----------------------------------------------------------------%
% Variable O&M cost of storage in correct units [$/MWh] or [$/MW day]
Storage_aux.VOM_S = t_VOM*Par(3);
%----------------------------------------------------------------%

%----------------------------------------------------------------%
% Minimum storage capacity - plant lower bound (MWh)
Storage_aux.P_Smin = 0;
%----------------------------------------------------------------%

%----------------------------------------------------------------%
% Maximum storage capacity - plant upper bound
Storage_aux.P_Smax = Inf;
%----------------------------------------------------------------%

%----------------------------------------------------------------%
% Minimum input power to storage [MW] - control lower bound
Storage_aux.u1_Smin = 0;
%----------------------------------------------------------------%

%----------------------------------------------------------------%
% Minimum output power from storage [MW] - control lower bound
Storage_aux.u2_Smin = 0;
%----------------------------------------------------------------%

%----------------------------------------------------------------%
% Minimum revenue portion of control in % of discharge - control lower bound
Storage_aux.u3_Smin = 0;
%----------------------------------------------------------------%

%----------------------------------------------------------------%
% Maximum input power to storage [MW] - control upper bound
Storage_aux.u1_Smax = Par(4);
%----------------------------------------------------------------%

%----------------------------------------------------------------%
% Maximum input power from storage [MW] - control upper bound
Storage_aux.u2_Smax = Par(5);
%----------------------------------------------------------------%

%----------------------------------------------------------------%
% Maximum revenue portion of control % of discharge - control upper bound
Storage_aux.u3_Smax = Par(6);
%----------------------------------------------------------------%

%----------------------------------------------------------------%
% Initial stored thermal energy - state [MWh]
Storage_aux.x_S0 = Par(7);
%----------------------------------------------------------------%

%----------------------------------------------------------------%
% Final stored thermal energy - state [MWh]
Storage_aux.x_Sf = Par(8);
%----------------------------------------------------------------%

%----------------------------------------------------------------%
% Efficiency of charge
Storage_aux.eta1_S = Par(9);
%----------------------------------------------------------------%

%----------------------------------------------------------------%
% Efficiency of discharge
Storage_aux.eta2_S = Par(10);
%----------------------------------------------------------------%

%----------------------------------------------------------------%
% Conversion Efficiency (electricity to tertiary)
Storage_aux.eta_c_E2T = Par(11);
%----------------------------------------------------------------%

%----------------------------------------------------------------%
% Conversion Efficiency (tertiary to electricity)
Storage_aux.eta_c_T2E = Par(12);
%----------------------------------------------------------------%


end





%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%

function [t_FOM, t_VOM] = TimeCoefficients_Storage(TimeFlag)

switch upper(TimeFlag)
    case 'HOUR'
        t_FOM = (1/365)*(1/24);
        t_VOM = 1;
    case 'DAY'
        t_FOM = (1/365);
        t_VOM = 24;
end

end