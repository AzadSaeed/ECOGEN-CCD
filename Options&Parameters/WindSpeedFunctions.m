function [Wind_speeds,Wind_Power] = WindSpeedFunctions(auxdata)

% Extract required information from auxdata
TimeFlag = auxdata.General.TimeFlag;
NumHours = auxdata.General.NumHours;
NumDays  = auxdata.General.NumDays;
NumYears = auxdata.General.NumYears;

switch upper(TimeFlag)

    case 'HOUR'

        t_Length = NumYears*365*24 + NumYears*6 + NumDays*24 + NumHours;
        WindProfile = 'Final';

        switch upper(WindProfile)

            case 'FINAL'

                % filename (from https://www.ncei.noaa.gov/metadata/geoportal/rest/metadata/item/gov.noaa.ncdc:C01626/html)
                % fn  = 'AQW00061705.csv';
                fn  = 'WinsSpeeds2.csv';

                % Readfile
                T_ = readtable(fn);

                % Hourly winds for a year
                WS_ = T_.HLY_WIND_AVGSPD;
                Wind_speeds_ = WS_(1:8760,1);
                Wind_speeds_(8761,1) = 5.8;
                Wind_speeds_(8762,1) = 5.8;
                Wind_speeds_(8763,1) = 6;
                Wind_speeds_(8764,1) = 5;
                Wind_speeds_(8765,1) = 7.3;
                Wind_speeds_(8766,1) = 7.5;



                Wind_speeds_ = repmat(Wind_speeds_,[30,1]);
                t_Life = 0:(365.25*24*30-1);
                F     = griddedInterpolant(t_Life,Wind_speeds_,'previous');
                Wind_speeds    = @(t)F(t);
        end
end

t = 0:(365.25*24*30-1);


% Calculate the power geenrated from wind
rho_air = 1.293;
Rotor_diameter = 125;
N_turbine = 71;
Nominal_rating = 2.8; % [MW]
conversionfactor = 0.55;
% Wind Power in MW
Wind_Power = conversionfactor*((1/2)*rho_air*(pi/4)*(Rotor_diameter^2).*(Wind_speeds(t).^3))/10^6; 

% Maximum wind speed [m/s]
v_max = 25;

% Maximum power from wind farm
Wind_max = ((1/2)*rho_air*(pi/4)*(Rotor_diameter^2).*(v_max.^3))/10^6; 

% Rated region  
Wind_Power(Wind_Power>Nominal_rating) = Nominal_rating;

% Shut off at high wind speeds
Wind_Power(Wind_Power>Wind_max) = 0;

Wind_Power = N_turbine*Wind_Power;
F_P     = griddedInterpolant(t,Wind_Power,'previous');
% F_P     = griddedInterpolant(t,Wind_Power,'previous');
Wind_Power = @(t)F_P(t);

end