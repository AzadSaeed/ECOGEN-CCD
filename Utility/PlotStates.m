function PlotStates(T,Y,P,auxdata)


if isfield(auxdata.IDX,'Generator')

    idx_State_G = auxdata.IDX.Generator.State ;
    
    commonFigureProperties;
    hf = figure;  hf.Color = 'w';  hold on
    stairs(T, Y(:,idx_State_G),'.-',...
        'linewidth',linewidth,'markersize',10,...
        'Color',auxdata.Colors.Generator_State_Color,'MarkerEdgeColor',...
        auxdata.Colors.Generator_State_Color)
    lgnd = {'Generator State'};
    
    xlabel(auxdata.General.TimeFlag)
    ylabel('Generator State [MW]')
    PlotName = 'State_Gen.pdf';

    if auxdata.GenRenFlag
        hold on
        stairs(T, auxdata.Generator.RenLim(T),'.-',...
            'linewidth',linewidth,'markersize',8,...
            'Color',auxdata.Colors.WindColor,'MarkerEdgeColor',auxdata.Colors.WindColor)
        ll = length(lgnd);
        lgnd{ll+1} = 'Available Renewable Power';
    end


    % if ~auxdata.GenRenFlag
    % 
    %     yyaxis right
    %     Fuel_Price = auxdata.PriceFunctions.Fuel_Front(T) + auxdata.PriceFunctions.Fuel_Back(T);
    %     stairs(T, Fuel_Price./max(Fuel_Price),'-',...
    %         'linewidth',linewidth,'markersize',6,...
    %         'Color',auxdata.Colors.Fuel_Color,'MarkerEdgeColor',auxdata.Colors.Fuel_Color)
    %     ll = length(lgnd);
    %     lgnd{ll+1} = 'Fuel Price';
    % end


    yyaxis right
    % stairs(T, auxdata.PriceFunctions.c_electricity(T)./max(auxdata.PriceFunctions.c_electricity(T)),'-',...
    %     'linewidth',linewidth,'markersize',8,...
    %     'Color',auxdata.Colors.ElectricityPrice_Color,'MarkerEdgeColor',auxdata.Colors.ElectricityPrice_Color)
    % ylim([0.01, 1.05])
    % ylim([0.01, 1.05])
    stairs(T, auxdata.PriceFunctions.c_electricity(T),'-',...
        'linewidth',linewidth,'markersize',8,...
        'Color',auxdata.Colors.ElectricityPrice_Color,'MarkerEdgeColor',auxdata.Colors.ElectricityPrice_Color)
    % ylim([110, 210])

    ll = length(lgnd);
    lgnd{ll+1} = 'Electricity Price';
    
    ylabel('Normalized Electricity Prices')

    legend(lgnd,'Location','best')
    exportgraphics(gca,strcat(auxdata.General.CaseStudy_path, filesep,PlotName));

end


if isfield(auxdata.IDX,'Storage')

    lgnd = {};

    % Primary
    if isfield(auxdata.IDX.Storage,'Primary')

        idx_State_S = auxdata.IDX.Storage.Primary.State;
        hS = figure;  hS.Color = 'w';  hold on
        stairs(T, Y(:,idx_State_S),'.-',...
            'linewidth',linewidth,'markersize',10,...
            'Color',auxdata.Colors.Storage_State_Color,'MarkerEdgeColor',auxdata.Colors.Storage_State_Color)
        plot(T,P*ones(size(T)),'--',...
            'linewidth',linewidth,'markersize',6,...
            'Color',C.grey(5,:),'MarkerEdgeColor',C.grey(5,:))
        lgnd = {'Primary Storage State','Primary Storage Capcity'};
        legend(lgnd,'Location','best')
        ylabel('Storage State [MWh]')
        PlotName = 'State_StorageP.pdf';
        ylim([60 200])
        exportgraphics(gca,strcat(auxdata.General.CaseStudy_path, filesep,PlotName));

    end

    % Electrical
    if isfield(auxdata.IDX.Storage,'Electrical')


        idx_State_S = auxdata.IDX.Storage.Electrical.State ;
        hS = figure;  hS.Color = 'w';  hold on
        stairs(T, Y(:,idx_State_S),'.-',...
            'linewidth',linewidth,'markersize',12,...
            'Color',auxdata.Colors.Storage_State_Color,'MarkerEdgeColor',auxdata.Colors.Storage_State_Color)
        plot(T,P*ones(size(T)),'.-',...
            'linewidth',linewidth,'markersize',12,...
            'Color',C.green(9,:),'MarkerEdgeColor',C.green(9,:))
        l = length(lgnd);
        lgnd = {'Electrical Storage State','Electrical Storage Capcity'};
        legend(lgnd,'Location','best')
        ylabel('Storage State [MWh]')
        PlotName = 'State_StorageE.pdf';

        if strcmpi(auxdata.General.GeneratorFlag{1,1},'Onshore_wind')
            hold on
            yyaxis right
            stairs(T, auxdata.PriceFunctions.c_electricity(T),'-',...
                'linewidth',linewidth,'markersize',8,...
                'Color',auxdata.Colors.ElectricityPrice_Color,'MarkerEdgeColor',auxdata.Colors.ElectricityPrice_Color)
            ll = length(lgnd);
            lgnd{ll+1,1} = 'Electricity Price';
            ylabel('Electricity Prices')
        end

        exportgraphics(gca,strcat(auxdata.General.CaseStudy_path, filesep,PlotName));

    end

    % Tertiary
    if isfield(auxdata.IDX.Storage,'Tertiary')
        idx_State_S = auxdata.IDX.Storage.Tertiary.State ;
        hS = figure;  hS.Color = 'w';  hold on
        stairs(T, Y(:,idx_State_S),'.-',...
            'linewidth',linewidth,'markersize',12,...
            'Color',auxdata.Colors.Storage_State_Color,'MarkerEdgeColor',auxdata.Colors.Storage_State_Color)
        plot(T,P*ones(size(T)),'.-',...
            'linewidth',linewidth,'markersize',12,...
            'Color',C.green(9,:),'MarkerEdgeColor',C.green(9,:))

        l = length(lgnd);
        lgnd{1,l+1} = 'Tertiary Storage State';
        legend(lgnd,'Location','best')
        ylabel('Storage State [kg]')
        PlotName = 'State_StorageT.pdf';
        exportgraphics(gca,strcat(auxdata.General.CaseStudy_path, filesep,PlotName));
    end
end

end