function c = ThermalEnergyPrices(TimeFlag,NumHours, NumDays, NumYears,Plot_thermal)


switch upper(TimeFlag)

    case 'HOUR'
        
        t_Length = NumYears*365*24 + NumYears*6 + NumDays*24 + NumHours;

        % Create Base daily Profile
        t_ = 1:24;
        c_base = [5*ones(1,5), 50*ones(1,5), 78*ones(1,6), 49*ones(1,4), 42*ones(1,4)];

        % Repeat the base for all days - 30 years
        t = 0:(365.25*24*30-1);
        c = repmat(c_base, [1, 366*30,1]);
        c = c(1:24*365.25*30);

        rng default;

        % Create random numbers between -x and x
        x = 0;
        r = -x + (x+x)*rand(1,length(c));

        % Final electricity price signal
        C_fuel = c + r;

        % Ensure non-negative prices
        C_fuel(C_fuel<0) = 0;

        % if Plot_thermal
        % stairs(t,C_fuel,'.-','linewidth',linewidth,'markersize',12,...
        %     'Color',C.green(5,:),'MarkerEdgeColor',C.green(5,:))
        % legend({'base price','final price'})
        % close(hf)
        % end

        % Create the price function
        F     = griddedInterpolant(t,C_fuel,'previous');
        c     = @(t)F(t);


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