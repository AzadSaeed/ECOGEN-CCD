function [c_f, c_b] = NaturalGasPrices(TimeFlag,NumHours, NumDays, NumYears,Plot_ng)


t_Length = NumYears*365*24 + NumYears*6 + NumDays*24 + NumHours;

switch upper(TimeFlag)

    case 'HOUR'

        NG_Flag = 'FINAL';

        switch NG_Flag

            case 'TEST'

                C_fuel = 0.5*ones(t_Length,1);
                t = 1:t_Length;
                F     = griddedInterpolant(t,C_fuel);
                c     = @(t)F(t);

            case 'FINAL'

                % filename
                fn  = 'NG.csv';

                % Readfile
                T_ = readtable(fn);

                % Price in dolalrs per thousand cubic feet
                P_monthly_22_ = T_.Data1_ColoradoPriceOfNaturalGasDeliveredToResidentialConsumers_(397:408);

                % Convert price to $/kg
                P_monthly_22 = P_monthly_22_*(1/(0.68*0.0283168*1000));
                m_ = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
                P_ = [];


                % Construct annual price
                for i = 1:length(P_monthly_22)

                    Base_p = P_monthly_22(i,1);
                    p_ = repmat(Base_p,[m_(i)*24,1]);

                    id0 = length(P_)+1;
                    idf = id0 + m_(i)*24 -1;
                    P_(id0:idf,1) = p_;

                end


                % Annual price vector
                P = P_(1:365.25*24,1);

                % create lifetime price vector
                C_fuel = repmat(P,[30,1]);
                t      = 0:(365.25*24*30-1);

                % Create the price function for front fuel costs
                Ff    = griddedInterpolant(t,C_fuel,'previous');
                c_f   = @(t)Ff(t);


                % Create the price function for front fuel costs
                Fb     = griddedInterpolant(t,0*C_fuel,'previous');
                c_b   = @(t)Fb(t);


        end


    case 'DAY'
        
        error ('No daily prices are available')
        
    case 'YEAR'

        error ('No daily prices are available')

end


end