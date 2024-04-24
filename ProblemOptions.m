function [Opts, auxdata] = ProblemOptions(varargin)
% This function defines all the required options for the problem, including
% the time horizon, parameters assosiated with generator and storage, 
% economic options, loads, etc.
%
%
% Saeed Azad, PhD


if nargin == 1
    auxdata = varargin{1};
else
    auxdata   = [];
end

% Get appropriate indices for the problem
[gen_idx,str_idx] = Get_Indices(auxdata.General.PET);
if ~isempty(gen_idx)
    auxdata.IDX.Generator = gen_idx;
end
if ~isempty(str_idx)
    auxdata.IDX.Storage   = str_idx;
end

% Set the time duration 
auxdata.General.NumHours = 0;  % 0 <= NumHours <= 24
auxdata.General.NumDays  = 2;  % 0 <= NumDays <= 365.25 (# days in a Julian day)
auxdata.General.NumYears = 0;  % 

% Set the time flag (only hourly works with existing price signals)
auxdata.General.TimeFlag = 'Hour';

% Plot flag
auxdata.General.PlotFlag = 1;

% Retrofit or new construction: If retrofit, the generators Mayer costs
% are excluded
auxdata.RetrofitFlag = 0;

% Set up the required parameters
[Gen_aux, Storage_aux] = Parameter_Setup;

% Generator options
Gen_aux = GeneratorOptions(auxdata.General.GeneratorFlag, Gen_aux,auxdata.General.TimeFlag);


% Storage options
if ~isempty(auxdata.General.StorageFlag)
    Storage_aux = StorageOptions(auxdata.General.StorageFlag, Storage_aux,auxdata.General.TimeFlag);
end

% Primary, electricity, and tertiary price signals
PriceSignal = PriceFunctions(auxdata);

% Pass prices to the auxiliary data
auxdata.PriceFunctions = PriceSignal;

% Techno-economic options
Econ_aux = EconomicOptions(auxdata.General.GeneratorFlag, auxdata.General.StorageFlag);

% DTQP options
DTQP_Options = DTQPOptions(auxdata.General.GeneratorFlag,...
    auxdata.General.StorageFlag ,auxdata.General.NumHours,...
    auxdata.General.NumDays,auxdata.General.NumYears,...
    auxdata.General.TimeFlag);

% Load options
Load_aux = Load_Functions(auxdata.General.GeneratorFlag, auxdata.General.StorageFlag);

% Color Options for ploting
Colors = PlotColors;

% Assemble all data and options 
auxdata.Storage        = Storage_aux;
auxdata.Generator      = Gen_aux;
auxdata.Loads          = Load_aux;
auxdata.Economics      = Econ_aux;
auxdata.Colors         = Colors;
Opts.DTQP              = DTQP_Options;


% Wind speeds only for wind generator
if strcmpi(auxdata.General.GeneratorFlag{1,1}, 'Onshore_Wind')
    [~, WP] = WindSpeedFunctions(auxdata);
    auxdata.Generator.RenLim = WP;
end

% Discrete market demand constriant: sales can be made only at certain times 
if isfield(auxdata.IDX,'Storage') && isfield(auxdata.IDX.Storage,'Tertiary')
    F_fnc = DMD(auxdata);
    auxdata.Storage.DMD = F_fnc;
end

end



%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
function opts = DTQPOptions(GeneratorFlag,StorageFlag,NumHours,...
    NumDays,NumYears,TimeFlag)
% This function defines the required parameters for DTQP. 

switch upper(TimeFlag)
    case 'HOUR'
        t_Length = NumYears*365*24 +  NumDays*24 + NumHours;
    case 'DAY'
        t_Length = NumYears*365 +  NumDays*24 + floor(NumHours/24);
end


if length(GeneratorFlag) == 1
    
    % Number of plant optimization variables in generator
    opts.subsys.Np_G = 0;

    % Number of state variables in generator
    opts.subsys.Nx_G = 1;

    % Number of control variables in generator
    opts.subsys.Nu_G = 1;

else
    msg = 'So far, the code only works for a single generator.';
    error(msg)
end


if length(StorageFlag) <= 3

    % Number of plant optimization variables in storage system
    opts.subsys.Np_S = 1*length(StorageFlag);

    % Number of state variables in storage system
    opts.subsys.Nx_S = 1*length(StorageFlag);

    % Number of control variables in storage system
    opts.subsys.Nu_S = 3*length(StorageFlag);

elseif length(StorageFlag) > 3
    msg = 'So far, the code only works for only three storage devices.';
    error(msg)
end



opts.method.form       = 'linearprogram';
opts.solver.tolerance  = 1e-6;
opts.solver.maxiters   = 500;

opts.dt.defects        = 'ZO';  % zero hold
opts.dt.quadrature     = 'CEF'; % Composite Euler Forward
opts.dt.mesh           = 'ED';
opts.dt.nt             = t_Length + 1;

opts.general.displevel = 2;
opts.general.plotflag  = 1;
opts.general.saveflag  = 0;
opts.general.np        = opts.subsys.Np_G+opts.subsys.Np_S;
opts.general.nu        = opts.subsys.Nu_G+opts.subsys.Nu_S;
opts.general.ns        = opts.subsys.Nx_G+opts.subsys.Nx_S;

opts.general.t0        = 0;
opts.general.tf        = t_Length;



end



%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
function Load_aux = Load_Functions(GeneratorFlag, StorageFlag)

% Pre-allocate all possible loads

% Primary Load (from carbon capture, district heating, etc.) defined as a
% function of the generator
LP_G = 0;

% Electrical Load (from carbon capture, district heating, auc=xiliary
% loads, etc.) defined as a function of the generator
LE = 0;

% Primary Load (from tertiary storage, such as HTSE operation) defined as a
% fucntion of the tertiary charging signal
LP_T = 0;


for i = 1:length(GeneratorFlag)
    switch GeneratorFlag{1,1}
    
        case 'CC221'

            % 10% auxiliary loads
            LE = LE+0.1;

        case 'ONSHORE_WIND'

            % 10% auxiliary loads
            LE = LE+0.1;

        case 'ADVANCED_NUCLEAR'
            
            % 10% auxiliary loads
            LE = LE+0.1;

    end
end


if ~isempty(StorageFlag)
    for i = 1:length(GeneratorFlag)

        switch StorageFlag{1,1}

            case 'THERMAL'

                LP_G = 0.1;

                % Additional 10% for carbon capture
                LE   = LE + 0.1;

            case 'BESS'

                % No additional electrical load
                LE   = LE;


            case 'HYDROGEN_HTSE'

                LP_T = 0.1;

                % No additional electrical load
                LE   = LE;

        end

    end
end


% Add all loads
Load_aux.LP_G = LP_G;
Load_aux.LP_T = LP_T;
Load_aux.LE   = LE;

end

%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%

function F_fnc = DMD(auxdata)

% Create upper bound for 30 years of hourly mesh
t_all = 0:30*365.25*24;
Fval  = zeros(size(t_all));

% Sales occur every day at T_sell-1 to T_sell
T_sell = 9;

% number of days
num_days = 30*365.25;

for i = 0:num_days

    t_idx = i*(24) + T_sell;
    Fval(1,t_idx) = 1;

end


Fval = Fval.*auxdata.Storage.u3_Smax;
F_int = griddedInterpolant(t_all,Fval,'previous');
F_fnc = @(t)F_int(t);


end