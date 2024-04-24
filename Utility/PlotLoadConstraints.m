function PlotLoadConstraints(T,U,Y,P,F,auxdata,Opts,out)

ElectricalLoad = out.ElectricalLoad.total;
L_GE = out.ElectricalLoad.Gen;
L_SE = out.ElectricalLoad.Storage;

% Plot Electrical load constraint
commonFigureProperties;
hf = figure;  hf.Color = 'w';  hold on
stairs(T, ElectricalLoad,'s-',...
    'linewidth',linewidth,'markersize',8,...
    'Color', auxdata.Colors.LoadConstraint_Color2,'MarkerEdgeColor',auxdata.Colors.LoadConstraint_Color2)
stairs(T, L_GE+L_SE,'.-',...
    'linewidth',linewidth,'markersize',8,...
    'Color', auxdata.Colors.LoadConstraint_Color1,'MarkerEdgeColor', auxdata.Colors.LoadConstraint_Color1)
xlabel(auxdata.General.TimeFlag)
lgnd = {'Electrical load','Load satisfied by generator plus storage'};
legend(lgnd,'Location','best')
ylabel('Electrical Load constraint [MW]')
PlotName = 'ElectricalLoad.pdf';
exportgraphics(gca,strcat(auxdata.General.CaseStudy_path, filesep,PlotName));


PrimaryLoad = out.PrimaryLoad.total;
L_GP = out.PrimaryLoad.Gen;
L_SP = out.PrimaryLoad.Storage;

% Plot thermal load constraint
commonFigureProperties;
hf = figure;  hf.Color = 'w';  hold on
stairs(T, PrimaryLoad,'s-',...
    'linewidth',linewidth,'markersize',8,...
    'Color', auxdata.Colors.LoadConstraint_Color2,'MarkerEdgeColor', auxdata.Colors.LoadConstraint_Color2)
stairs(T, L_GP+L_SP,'.-',...
    'linewidth',linewidth,'markersize',8,...
    'Color', auxdata.Colors.LoadConstraint_Color1,'MarkerEdgeColor', auxdata.Colors.LoadConstraint_Color1)
xlabel(auxdata.General.TimeFlag)
lgnd = {'Thermal load','Load satisfied by generator plus storage'};
legend(lgnd,'Location','best')
ylabel('Thermal Load constraint [MW]')
PlotName = 'ThermalLoad.pdf';
exportgraphics(gca,strcat(auxdata.General.CaseStudy_path, filesep,PlotName));



end

