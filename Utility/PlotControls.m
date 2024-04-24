function PlotControls(T,U,auxdata,Opts)

PlotName_G  = 'ControlG.pdf';
PlotName_P  = 'ControlP.pdf';
PlotName_PR = 'ControlPR.pdf';
PlotName_E  = 'ControlE.pdf';
PlotName_ER = 'ControlER.pdf';
PlotName_T  = 'ControlT.pdf';


if isfield(auxdata.IDX,'Generator')

    idx_State_G = auxdata.IDX.Generator.State ;
    commonFigureProperties;
    hg = figure;  hg.Color = 'w';  hold on
    stairs(T, U(:,idx_State_G)./auxdata.Generator.u_Gmax,'.-',...
        'linewidth',linewidth,'markersize',8,...
        'Color',auxdata.Colors.Generator_State_Color,...
        'MarkerEdgeColor',auxdata.Colors.Generator_State_Color)
    xlabel(auxdata.General.TimeFlag)
    lgnd = {'Normalized Generator Control'};

end


if isfield(auxdata.IDX,'Storage')

    % Primary
    if isfield(auxdata.IDX.Storage,'Primary')

        idx_Control_S = auxdata.IDX.Storage.Primary.Control;
        u_charge_idx = idx_Control_S(1,1);
        u_discharge_idx = idx_Control_S(2,1);
        u_rev_idx  =  idx_Control_S(3,1);

        commonFigureProperties;

        % Plot charge signal with generator control
        figure(hg);
        stairs(T, U(:,u_charge_idx)./auxdata.Generator.u_Gmax,'.-',...
            'linewidth',linewidth,'markersize',10,...
            'Color',auxdata.Colors.Charge_Color,'MarkerEdgeColor',auxdata.Colors.Charge_Color)
        lgnd{1,length(lgnd)+1} = 'Normalized Primary Charge';



        hSP = figure;  
        left_color = [0,0,0]./255;
        right_color = auxdata.Colors.ElectricityPrice_Color;
        set(hSP,'defaultAxesColorOrder',[left_color; right_color]);
        hSP.Color = 'w';  hold on

        yyaxis left
        stairs(T, U(:,u_charge_idx),'.-',...
            'linewidth',linewidth,'markersize',10,...
            'Color',auxdata.Colors.Charge_Color,'MarkerEdgeColor',auxdata.Colors.Charge_Color)
        stairs(T, U(:,u_discharge_idx),'.-',...
            'linewidth',linewidth,'markersize',10,...
            'Color',auxdata.Colors.Discharge_Color,'MarkerEdgeColor',auxdata.Colors.Discharge_Color)
        lgndP = {'Charge';'Discharge'};
        ylabel('MW')
        xlabel('Time')

        if strcmpi(auxdata.General.GeneratorFlag{1,1},'CC221')

            yyaxis right
            Fuel_Price = auxdata.PriceFunctions.Fuel_Front(T) + auxdata.PriceFunctions.Fuel_Back(T);
            stairs(T, Fuel_Price./max(Fuel_Price),'.-',...
                'linewidth',linewidth,'markersize',6,...
                'Color',auxdata.Colors.Fuel_Color,'MarkerEdgeColor',auxdata.Colors.Fuel_Color)
            ll = length(lgndP);
            lgndP{ll+1,1} = 'Fuel Price';

        end


        yyaxis right
        stairs(T, auxdata.PriceFunctions.c_electricity(T)./max(auxdata.PriceFunctions.c_electricity(T)),'.-',...
            'linewidth',linewidth,'markersize',8,...
            'Color',auxdata.Colors.ElectricityPrice_Color,'MarkerEdgeColor',auxdata.Colors.ElectricityPrice_Color)
        ll = length(lgndP);
        lgndP{ll+1,1} = 'Electricity Price';


        legend(lgndP,'Location','best')
        exportgraphics(gca,strcat(auxdata.General.CaseStudy_path,filesep,PlotName_P));


    end

    % Electrical
    if isfield(auxdata.IDX.Storage,'Electrical')

        idx_Control_S = auxdata.IDX.Storage.Electrical.Control;
        u_charge_idx = idx_Control_S(1,1);
        u_discharge_idx = idx_Control_S(2,1);
        u_rev_idx =  idx_Control_S(3,1);

        commonFigureProperties;

        % Plot charge signal with generator control
        gca(hg);
        stairs(T, U(:,u_charge_idx)./auxdata.Generator.u_Gmax,'.-',...
            'linewidth',linewidth,'markersize',12,...
            'Color',auxdata.Colors.Charge_Color,'MarkerEdgeColor',auxdata.Colors.Charge_Color)
        lgnd{1,length(lgnd)+1} = 'Electrical Charge';

        hSE = figure;  hSE.Color = 'w';  hold on
        stairs(T, U(:,u_charge_idx),'.-',...
            'linewidth',linewidth,'markersize',12,...
            'Color',auxdata.Colors.Charge_Color,'MarkerEdgeColor',auxdata.Colors.Charge_Color)
        stairs(T, U(:,u_discharge_idx),'.-',...
            'linewidth',linewidth,'markersize',12,...
            'Color',auxdata.Colors.Discharge_Color,'MarkerEdgeColor',auxdata.Colors.Discharge_Color)
        lgndE = {'Chrage','Discharge'};
        legend(lgndE,'Location','best')
        ylabel('MW')
        xlabel('Time')

        yyaxis right
        stairs(T, auxdata.PriceFunctions.c_electricity(T),'-',...
            'linewidth',linewidth,'markersize',8,...
            'Color',auxdata.Colors.ElectricityPrice_Color,'MarkerEdgeColor',auxdata.Colors.ElectricityPrice_Color)
        ll = length(lgnd);
        lgndE{ll+1,1} = 'Electricity Price'; 
        exportgraphics(gca,strcat(auxdata.General.CaseStudy_path,filesep,PlotName_E));

        % Plot charge signal with generator control
        hSER = figure;  hSER.Color = 'w';  hold on
        stairs(T, U(:,u_rev_idx)./max(U(:,u_rev_idx)),'.-',...
            'linewidth',linewidth,'markersize',10,...
            'Color',auxdata.Colors.RevControl_Color,'MarkerEdgeColor',auxdata.Colors.RevControl_Color)
        stairs(T, auxdata.PriceFunctions.c_electricity(T)./max(auxdata.PriceFunctions.c_electricity(T)),'.-',...
            'linewidth',linewidth,'markersize',6,...
            'Color',auxdata.Colors.ElectricityPrice_Color,'MarkerEdgeColor',auxdata.Colors.ElectricityPrice_Color)
        lgndE = {'Revenue','Electrical Energy Prices'};
        legend(lgndE,'Location','best')
        xlabel('Time')
        exportgraphics(gca,strcat(auxdata.General.CaseStudy_path,filesep,PlotName_ER));

    end

    % Tertiary
    if isfield(auxdata.IDX.Storage,'Tertiary')

        idx_Control_S = auxdata.IDX.Storage.Tertiary.Control;
        u_charge_idx = idx_Control_S(1,1);
        u_discharge_idx = idx_Control_S(2,1);
        u_rev_idx =  idx_Control_S(3,1);


        commonFigureProperties;

        % Plot charge signal with generator control
        gca(hg);
        stairs(T, U(:,u_charge_idx)./auxdata.Generator.u_Gmax,'.-',...
            'linewidth',linewidth,'markersize',12,...
            'Color',auxdata.Colors.Charge_Color,'MarkerEdgeColor',auxdata.Colors.Charge_Color)
        lgnd{1,length(lgnd)+1} = 'Tertiary Charge';

        hST = figure;  hST.Color = 'w';  hold on
        stairs(T, U(:,u_charge_idx),'.-',...
            'linewidth',linewidth,'markersize',12,...
            'Color',auxdata.Colors.Charge_Color,'MarkerEdgeColor',auxdata.Colors.Charge_Color)
        stairs(T, U(:,u_discharge_idx),'.-',...
            'linewidth',linewidth,'markersize',12,...
            'Color',auxdata.Colors.Discharge_Color,'MarkerEdgeColor',auxdata.Colors.Discharge_Color)
        stairs(T, U(:,u_rev_idx),'.-',...
            'linewidth',linewidth,'markersize',12,...
            'Color',auxdata.Colors.RevControl_Color,'MarkerEdgeColor',auxdata.Colors.RevControl_Color)
        lgndT = {'Chrage','Discharge','Revenue'};
        legend(lgndT,'Location','best')
        ylabel('MW')
        xlabel('Time')
        exportgraphics(gca,strcat(auxdata.General.CaseStudy_path,filesep,PlotName_T));
    end
end

figure(hg);
legend(lgnd,'Location','best')
ylabel('Normalized Controls')
exportgraphics(gca,strcat(auxdata.General.CaseStudy_path,filesep,PlotName_G));

end