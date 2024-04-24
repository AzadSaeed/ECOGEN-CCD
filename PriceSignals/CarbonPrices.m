function c_carbon = CarbonPrices(TimeFlag,NumHours, NumDays, NumYears,Plot_carbon)

switch upper(TimeFlag)

    case 'HOUR'

        t_Length = NumYears*365*24 + NumYears*6 + NumDays*24 + NumHours;
        t = 0:(365.25*24*30-1);
        c = 65*ones([365.25*24*30,1]);

        % Create the price function
        F     = griddedInterpolant(t,c,'previous');
        c_carbon    = @(t)F(t);
end


end