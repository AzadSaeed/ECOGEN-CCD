function c = ElectricityPrices(TimeFlag,NumHours, NumDays, NumYears, Plot_elec)


switch upper(TimeFlag)

    case 'HOUR'

        t_Length = NumYears*365*24 + NumYears*6 + NumDays*24 + NumHours;
        PriceSignal = 'FINALSIGNAL';

        switch upper(PriceSignal)

            case 'TEST'

                % C_elec = linspace(140,160,t_Length);
                C_elec = [140*ones(10,1);150*ones(10,1);160*ones(5,1);150*ones(5,1); 140*ones(10,1);140*ones(8,1)]; 
                t = 1:t_Length;

                % Create the price function
                F     = griddedInterpolant(t,C_elec);
                c     = @(t)F(t);

            case 'SINEWAVE'

                t_ = 1:24;
                a  = 50;
                phi = 36;
                c_base = a*sin(0.5*t_+phi) + a;

                commonFigureProperties; hf = figure; hf.Color = 'w';
                hold on
                stairs(t_,c_base,'.-','linewidth',linewidth,'markersize',12,...
                    'Color',C.grey(5,:),'MarkerEdgeColor',C.grey(5,:))

                % Repeat the base for all days
                t = 1:1:t_Length;
                c = repmat(c_base, [1,floor(t_Length/24)]);
                C_elec = [c,c_base(1:(NumHours))];

                stairs(t,C_elec,'.-','linewidth',linewidth,'markersize',12,...
                    'Color',C.green(5,:),'MarkerEdgeColor',C.green(5,:))
                close all;

                % Create the price function
                F     = griddedInterpolant(t,C_elec,'previous');
                c     = @(t)F(t);

            case 'FINALSIGNAL'

                % filename
                fn  = 'EP.csv';

                % Readfile
                T_ = readtable(fn);

                % Extract prices for Algonquin Citygates for each month
                P_year = T_.LMP;
                P_Life = repmat(P_year,[30,1]);
                t_Life = 0:(30*365.25*24-1);
                F     = griddedInterpolant(t_Life,P_Life,'previous');
                c     = @(t)F(t);
 
        end

    case 'DAY'

        error ('No daily prices are available')
        
    case 'YEAR'

        error ('No yearly prices are available')
       
end

end