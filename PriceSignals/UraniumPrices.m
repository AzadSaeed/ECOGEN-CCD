function [c, c_b] = UraniumPrices(TimeFlag,NumHours, NumDays, NumYears,Plot_hydrogen)


switch upper(TimeFlag)

    case 'HOUR'
        
        % t_Length = NumYears*365*24 + NumYears*6 + NumDays*24 + NumHours;

        % Assume Uranium prices based on predictions in "Forecasting the 
        % price of uranium based on the costs of uranium deposits 
        % exploitation" - page 13
        %
        %
        %

        year_base   = [1, 5, 10, 15, 20, 25, 30];
        price_base  = [91, 90, 91, 97, 108, 118, 130];
        yr_int      = griddedInterpolant(year_base,price_base,'linear');
        yr_int_f    = @(t)yr_int(t);
        P_          = [];

        for i = 1:30

            Yearly_price = yr_int_f(i);
            Hours_in_year = 24*365.25;

            P_year = repmat(Yearly_price,[1,Hours_in_year]);

            id0 = length(P_)+1;
            idf = id0 + (24*365.25)-1;
            P_(id0:idf,1) = P_year;

        end


        t = 0:1:(24*365.25*30)-1;

        if Plot_hydrogen
            commonFigureProperties; hf = figure; hf.Color = 'w';
            hold on
            stairs(t,P_,'.-','linewidth',linewidth,'markersize',12,...
                'Color',C.grey(5,:),'MarkerEdgeColor',C.grey(5,:))
            xlabel('Hours')
            ylabel('Fuel~Price[$\$/kg~UO_{2}$]')
        end

        % Create the price function
        F     = griddedInterpolant(t,P_,'previous');
        c     = @(t)F(t);


        % create the back-end fuel cost as 10% of the front end cost
        c_fuel_b = 0.1*P_;
        F_b = griddedInterpolant(t,c_fuel_b,'previous');   
        c_b = @(t)F_b(t);


    case 'DAY'

        error ('No daily prices are available')
        
    case 'YEAR'
       
        error ('No yearly prices are available')

end








% switch upper(TimeFlag)
% 
%     case 'DAY'
% 
%         % filename
%         fn  = 'NaturalGasPrices.csv';
% 
%         % Readfile
%         T_ = readtable(fn);
% 
%         % Extract prices for Algonquin Citygates for each month
%         PriceHub = 'Algonquin Citygates';
%         ph = T_.PriceHub; 
%         id = find(arrayfun(@(n) any(strcmp(ph{n},PriceHub)),1:numel(ph)));
% 
%         Date_  = T_.TradeDate(id);
%         m      = month(Date_);
%         d      = day(Date_);
% 
%         % price in $/MMBtu
%         price_ = T_.WtdAvgPrice__MMBtu(id);
% 
%         % Convert to $/kg
%         % 1 MMBtu is 1.055056*10^9 joules
%         % heat value of natural gas assumed to be 53.2*10^6 joules/kg
%         price_ = price_*(1/(1.055056*10^9))*(53.2*10^6);
% 
%         % Organize data for each month
%         t = 1:30; % assume 30 days per month
%         for i = 1:12
%             idx = find(m==i);
%             p_  = price_(idx);
%             pf  = griddedInterpolant(d(idx),p_);
%             id0 = (i-1)*(30)+1;
%             idf = id0+29; 
%             P(id0:idf)    = pf(t);
% 
%             plot(d(idx),p_,'*r')
%             hold on
%             stairs(t,P(id0:idf),'.-b')
%             close all
%         end
% 
%         % test
%         P(13) = P(13)-0.13;
%         P(61) = 0.002;
%         P(62) = 0.002;
%         P(63) = 0.002;
%         P(64) = 0.002;
%         P(65) = 0.002;
% 
%         P(70) = 0.002;
%         P(71) = 0.002;
%         P(72) = 0.002;
%         P(73) = 0.002;
%         P(74) = 0.002;
%         P(75) = 0.002;
% 
%         % Interpolate the entire price signal
%         Time = 1:(12*30*Numyears);
%         price = repmat(P,[1,Numyears]);
%         F     = griddedInterpolant(Time,price);
%         c     = @(t)F(t);
% 
%         if PlotFlag
%             commonFigureProperties;
%             hf = figure; % create a new figure and save handle
%             hf.Color = 'w'; % change the figure background color
%             hold on % do this once!
%             stairs(Time,c(Time),'.-','linewidth',linewidth,'markersize',12,...
%             'Color',C.grey(5,:),'MarkerEdgeColor',C.grey(5,:))
%             xlabel('days')
%             ylabel('Fuel~Price[$\$/kg~NG$]')
%             close all;
%         end
% 
%  end


end