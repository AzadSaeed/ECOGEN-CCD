function PriceSignal = PriceFunctions(varargin)

if nargin == 0
    msg = 'Input is required for this function.';
    error(msg)
elseif nargin == 1
    auxdata = varargin{1,1};
elseif nargin > 1
    msg = 'Too many inputs.';
    error(msg)
end

% Extract required information from auxdata
TimeFlag = auxdata.General.TimeFlag;
NumHours = auxdata.General.NumHours;
NumDays  = auxdata.General.NumDays;
NumYears = auxdata.General.NumYears;


%-------------------------------------------------------------------------%
%--------------------- Electricity Price Signal --------------------------%
%-------------------------------------------------------------------------%

% Plot flag for electricity price signal
Plot_elec = 0;

c_electricity = ElectricityPrices(TimeFlag,NumHours, NumDays, NumYears, ...
                Plot_elec);

PriceSignal.c_electricity  =c_electricity;
%-------------------------------------------------------------------------%


%-------------------------------------------------------------------------%
%------------------------- Carbon tax arbon ------------------------------%
%-------------------------------------------------------------------------%
% Plot flag for carbon price signal
Plot_carbon = 0;

c_carbon  = CarbonPrices(TimeFlag,NumHours, NumDays, NumYears, ...
                Plot_carbon);
PriceSignal.c_carbon  = c_carbon;
%-------------------------------------------------------------------------%


%-------------------------------------------------------------------------%
%------------------------------ Fuel Prices ------------------------------%
%-------------------------------------------------------------------------%
for G = 1:length(auxdata.General.GeneratorFlag)

    Gen = auxdata.General.GeneratorFlag{G};

    switch Gen

        case 'CC221' %  Natural Gas Price Signal

            % Plot flag for natural gas price signal
            Plot_ng = 0;

            % Function to create/load natural gas prices
            [c_ng_f, c_ng_b] = NaturalGasPrices(TimeFlag,NumHours, NumDays, NumYears, ...
                Plot_ng);

            PriceSignal.Fuel_Front(G) = c_ng_f;
            PriceSignal.Fuel_Back(G)  = c_ng_b;

        case 'ADVANCED_NUCLEAR'

            % Plot flag for uranium price signal
            Plot_uranium = 0;

            [c_uranium_front,c_uranium_back]  = UraniumPrices(TimeFlag,NumHours, NumDays, NumYears, ...
                Plot_uranium);

            PriceSignal.Fuel_Front(G) = c_uranium_front;
            PriceSignal.Fuel_Back(G)  = c_uranium_back;

        otherwise

            PriceSignal.Fuel_Front(G) = @(t)zeros(size(t));
            PriceSignal.Fuel_Back(G)  = @(t)zeros(size(t));
    end

end
%-------------------------------------------------------------------------%


%-------------------------------------------------------------------------%
%------------------------ Energy Market Prices ---------------------------%
%-------------------------------------------------------------------------%

for S = 1:length(auxdata.General.StorageFlag)

    Str = auxdata.General.StorageFlag{S};

    switch Str

        case 'THERMAL'

            % Plot flag for thermal energy price signal
            Plot_thermal = 1;

            c_thermal = ThermalEnergyPrices(TimeFlag,NumHours, NumDays, NumYears, ...
                Plot_thermal);

            PriceSignal.Primary(S)  = c_thermal;

        case 'HYDROGEN_HTSE'

            % Plot flag for thermal energy price signal
            Plot_hydrogen = 1;

            c_hydrogen = HydrogenPrices(TimeFlag,NumHours, NumDays, NumYears, ...
                Plot_hydrogen);

            PriceSignal.Tertiary(S)  = c_hydrogen;

        otherwise

            PriceSignal.Primary(S) = @(t)zeros(size(t));
            PriceSignal.Tertiary(S)  = @(t)zeros(size(t));

    end

end


end