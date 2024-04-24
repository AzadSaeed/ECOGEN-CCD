function c = HydrogenPrices(TimeFlag,NumHours, NumDays, NumYears,Plot_hydrogen)


switch upper(TimeFlag)

    case 'HOUR'
        
        t_Length = NumYears*365*24 + NumYears*6 + NumDays*24 + NumHours;

        % Create Base daily Profile
        t_ = 0:23;
        c_base = 7*ones(1,length(t_));

        % Repeat the base for all days
        t = 0:1:(t_Length-1);
        c = repmat(c_base, [1,floor(t_Length/24)]);
        c = [c,c_base(1:(NumHours))];
        remaining_hours = t_Length - length(c);
        if remaining_hours>0
            c = [c,c_base(1:(remaining_hours))];
        end

        if Plot_hydrogen
            commonFigureProperties; hf = figure; hf.Color = 'w';
            hold on
            stairs(t,c,'.-','linewidth',linewidth,'markersize',12,...
                'Color',C.grey(5,:),'MarkerEdgeColor',C.grey(5,:))
            xlabel('Hours')
            ylabel('Fuel~Price[$\$/kg~H_{2}$]')
        end


        rng default;

        % Create random numbers between -5 and 5
        r = -0 + (0+0)*rand(1,t_Length);

        % Final electricity price signal
        C_fuel = c + r;

        if Plot_hydrogen
            stairs(t,C_fuel,'.-','linewidth',linewidth,'markersize',12,...
                'Color',C.green(5,:),'MarkerEdgeColor',C.green(5,:))
            ylim([0,0.3])
            legend({'base price','final price'})
            close(hf)
        end

        % Create the price function
        F     = griddedInterpolant(t,C_fuel,'previous');
        c     = @(t)F(t);


    case 'DAY'

         error ('No daily prices are available')
        
    case 'YEAR'
       
        error ('No daily prices are available')
end

end