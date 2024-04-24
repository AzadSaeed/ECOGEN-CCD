function PlotGrid(T,U,Y,P,F,auxdata,Opts, out)

xGrid = out.nodes.Grid;
E_Price = auxdata.PriceFunctions.c_electricity(T);
E_Price_norm = E_Price./max(E_Price);



% Plot electricity sold to grid_normalized
commonFigureProperties;
hf = figure;  hf.Color = 'w';  hold on
stairs(T, E_Price_norm,'.-',...
    'linewidth',linewidth,'markersize',8,...
    'Color', auxdata.Colors.ElectricityPrice_Color,...
    'MarkerEdgeColor', auxdata.Colors.ElectricityPrice_Color)

stairs(T, xGrid./auxdata.Generator.u_Gmax,'.-',...
    'linewidth',linewidth,'markersize',8,...
    'Color', auxdata.Colors.GridColor,'MarkerEdgeColor',...
    auxdata.Colors.GridColor)
ylabel('Normalized power to grid and electricity prices')
xlabel(auxdata.General.TimeFlag)
lgnd = {'Electricity Price','Power to Grid'};
legend(lgnd,'Location','best')
PlotName = 'Grid_norm.pdf';
exportgraphics(gca,strcat(auxdata.General.CaseStudy_path, filesep,PlotName));
% close(hf)




% Plot electricity sold to grid, not normalized
commonFigureProperties;
hf = figure;
left_color = auxdata.Colors.GridColor;
right_color = auxdata.Colors.ElectricityPrice_Color;
set(hf,'defaultAxesColorOrder',[left_color; right_color]);
hf.Color = 'w';  hold on
yyaxis left
stairs(T, xGrid,'.-',...
    'linewidth',linewidth,'markersize',10,...
    'Color', auxdata.Colors.GridColor,'MarkerEdgeColor', auxdata.Colors.GridColor)
ylabel('Power to grid')

yyaxis right
stairs(T, E_Price,'.-',...
    'linewidth',linewidth,'markersize',8,...
    'Color', auxdata.Colors.ElectricityPrice_Color,'MarkerEdgeColor', auxdata.Colors.ElectricityPrice_Color)
ylabel('Electricity price')
xlabel(auxdata.General.TimeFlag)
lgnd = {'Power to Grid','Electricity Price'};
legend(lgnd,'Location','best')
PlotName = 'Grid.pdf';
exportgraphics(gca,strcat(auxdata.General.CaseStudy_path, filesep,PlotName));
% close(hf)



% Specify indecies and required variables shared in the upcoming plots
[u_charge_idx, u_discharge_idx, u_rev_idx] = GetIndices(auxdata);
idx_State_G = auxdata.IDX.Generator.State;





% percentage of generator power spent on loads, charge, etc.? 
commonFigureProperties; hf = figure;

% Generator total electric power
Gen_Power_all = sum(Y(1:end-1,idx_State_G));

% Power spent on charging primary storage
if isfield(auxdata.IDX,'Storage') && isfield(auxdata.IDX.Storage,'Primary')
    P_charge = U(:,u_charge_idx);
    P_Charge_all = sum(U(1:end-1,u_charge_idx));
else
    P_charge = zeros(size(T));
    P_Charge_all = 0;
end

% Power spent on satisfying primary load by the generator
LGP_all = sum(out.PrimaryLoad.Gen(1:end-1));


% Power spent on satisfying primary load for tertiary storage
PrimaryLoad_T_all = sum(out.Tertiary.PrimaryLoad_T(1:end-1));

% Loss due to generator thermal efficiency
Loss_ =(Y(:,idx_State_G) - P_charge - out.PrimaryLoad.Gen - out.Tertiary.PrimaryLoad_T).*(1-auxdata.Generator.eta_G);
Loss = sum(Loss_(1:end-1));

% Power spent on charging electrical or tertiary
if isfield(auxdata.IDX,'Storage') && ~isfield(auxdata.IDX.Storage,'Primary')
    Charge_all = sum(U(1:end-1,u_charge_idx));
else
    Charge_all = sum(P_Charge_all);
end

% Power spent on satisfying the electrical load
LGE_all = sum(out.ElectricalLoad.Gen(1:end-1));

% Generator power not spent on loads/charge
Gen_Power_available_all = Gen_Power_all - Charge_all - LGP_all - LGE_all - PrimaryLoad_T_all - Loss;

data_ = [LGP_all, PrimaryLoad_T_all, Loss, Charge_all, LGE_all, Gen_Power_available_all];
names_ = ["LGP","PrimaryLoad_T","Loss","Charge","LGE","Gen Energy"];
mycolors_ = [auxdata.Colors.LoadConstraint_Color1;
              auxdata.Colors.PrimaryLoad_T;
              auxdata.Colors.Loss;
              auxdata.Colors.Charge_Color;
              auxdata.Colors.LoadConstraint_Color2;
              auxdata.Colors.Generator_State_Color];


[Data,Names,Mycolors] = removezero(data_,names_,mycolors_);
donutchart(Data,Names,'InnerRadius',0.4)
colororder(Mycolors)
PlotName = 'Pie_Genpower.pdf';
exportgraphics(gca,strcat(auxdata.General.CaseStudy_path, filesep,PlotName));
% close(hf)




% How much thermal load satisfied by generator versus storage? 
if auxdata.Loads.LP_G~=0

    commonFigureProperties; hf = figure;

    % Primary Load satisfied by generator
    LGP_all = sum(out.PrimaryLoad.Gen(1:end-1));

    % Primary load satisfied by storage
    LSP_all = sum(out.PrimaryLoad.Storage(1:end-1));

    data_     = [LGP_all,LSP_all];
    names_    = ["Generator","Storage"];
    mycolors_ = [auxdata.Colors.Generator_State_Color;
        auxdata.Colors.Storage_State_Color];

    [Data,Names,Mycolors] = removezero(data_,names_,mycolors_);
    donutchart(Data,Names,'InnerRadius',0.4)
    colororder(Mycolors)

    PlotName = 'Pie_Primary.pdf';
    title('Primary Load')
    exportgraphics(gca,strcat(auxdata.General.CaseStudy_path, filesep,PlotName));
    % close(hf)

end



% How much electrical load satisfied by generator versus storage?
if auxdata.Loads.LE~=0

    commonFigureProperties; hf = figure;

    % Electrical Load satisfied by generator
    LGE_all = sum(out.ElectricalLoad.Gen(1:end-1));

    % Primary load satisfied by storage
    LSE_all = sum(out.ElectricalLoad.Storage(1:end-1));

    data_     = [LGE_all,LSE_all];
    names_    = ["Generator","Storage"];
    mycolors_ = [auxdata.Colors.Generator_State_Color;
        auxdata.Colors.Storage_State_Color];

    [Data,Names,Mycolors] = removezero(data_,names_,mycolors_);
    donutchart(Data,Names,'InnerRadius',0.4)
    colororder(Mycolors)

    PlotName = 'Pie_Electrical.pdf';
    title('Electrical Load')
    exportgraphics(gca,strcat(auxdata.General.CaseStudy_path, filesep,PlotName));
    % close(hf)

end



% How much revenue comes from sales from storage versus from genertor
% directly?

% Year function based on 365.25 days 
year = auxdata.Economics.year;

% Rate of return
r  = auxdata.Economics.r;

% Revenue generated by directly selling energy
if isfield(auxdata.IDX,'Storage') && isfield(auxdata.IDX.Storage,'Primary')

    % Discharge efficiency
    eta_S = auxdata.Storage.eta2_S;

    % Revenue from direct energy sales
    Rev_storage = eta_S.*U(:,u_rev_idx).*auxdata.PriceFunctions.Primary(T);
    
    % Revenue from storage contributions by satisfying primary load 
    Load_portion = eta_S.*(U(:,u_discharge_idx) - U(:,u_rev_idx)).*auxdata.Generator.eta_G.*auxdata.PriceFunctions.c_electricity(T);   

    % Calculate revenue portion from selling electricity to the grid 
    Rev_Gen_total = out.nodes.node9.*auxdata.PriceFunctions.c_electricity(T);

    % Revenue portion from generator
    Rev_Gen = Rev_Gen_total-Load_portion; 

    % revenue portion from storage
    Rev_storage = Rev_storage+Load_portion;

elseif isfield(auxdata.IDX,'Storage') && isfield(auxdata.IDX.Storage,'Electrical')

    % Discharge efficiency
    eta_S = auxdata.Storage.eta2_S;

    % Revenue from direct energy sales
    Rev_storage = eta_S.*U(:,u_rev_idx).*auxdata.PriceFunctions.c_electricity(T);

    % Revenue generated by storage contributions towards satisfying primary load 
    Load_portion = eta_S.*(U(:,u_discharge_idx) - U(:,u_rev_idx)).*auxdata.PriceFunctions.c_electricity(T); 

    % Calculate revenue portion from selling electricity to the grid 
    Rev_Gen_total = out.nodes.node9.*auxdata.PriceFunctions.c_electricity(T);

    % Revenue portion from generator
    Rev_Gen = Rev_Gen_total-Load_portion; 

    % revenue portion from storage
    Rev_storage = Rev_storage+Load_portion;

elseif isfield(auxdata.IDX,'Storage') && isfield(auxdata.IDX.Storage,'Tertiary')

    % Discharge efficiency
    eta_S = auxdata.Storage.eta2_S;

    % Revenue from direct energy sales
    Rev_storage = eta_S.*U(:,u_rev_idx).*auxdata.PriceFunctions.Tertiary(T);

    % Revenue generated by converting tertiary commodity to electricity
    T2E = out.Tertiary.ET.*auxdata.PriceFunctions.Tertiary(T);

    % Calculate revenue portion from selling electricity to the grid 
    Rev_Gen  = out.nodes.node8.*auxdata.PriceFunctions.c_electricity(T);

   % Revenue portion from storage
    Rev_storage = Rev_storage+T2E;

elseif ~isfield(auxdata.IDX,'Storage') && isfield(auxdata.IDX,'Generator')

    % Calculate revenue portion from selling electricity to the grid 
    Rev_Gen = out.nodes.node9.*auxdata.PriceFunctions.c_electricity(T);

    Rev_storage = 0;

elseif ~isfield(auxdata.IDX,'Storage') && ~isfield(auxdata.IDX,'Generator')

    error('At least a generator must be defined for the study to run!')

end

    Rev_Gen_all_   = (Rev_Gen)./(1+r).^year(T);
    Rev_Gen_all = sum(Rev_Gen_all_(1:end-1));


    Rev_storage_all_   = (Rev_storage)./(1+r).^year(T);
    Rev_storage_all = sum(Rev_storage_all_(1:end-1));


    data_     = [Rev_Gen_all,Rev_storage_all];
    names_    = ["Generator","Storage"];
    mycolors_ = [auxdata.Colors.Generator_State_Color;
        auxdata.Colors.Storage_State_Color];

    [Data,Names,Mycolors] = removezero(data_,names_,mycolors_);
    donutchart(Data,Names,'InnerRadius',0.4)
    colororder(Mycolors)

    PlotName = 'Revenue.pdf';
    title('Revenue Contributions')
    exportgraphics(gca,strcat(auxdata.General.CaseStudy_path, filesep,PlotName));
    % close(hf)


end


%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%

function [u_charge_idx, u_discharge_idx, u_rev_idx] = GetIndices(auxdata)

if isfield(auxdata.IDX,'Storage') && isfield(auxdata.IDX.Storage,'Primary')

    idx_Control_S   = auxdata.IDX.Storage.Primary.Control;

elseif isfield(auxdata.IDX,'Storage') && isfield(auxdata.IDX.Storage,'Electrical')

    idx_Control_S   = auxdata.IDX.Storage.Electrical.Control;

elseif isfield(auxdata.IDX,'Storage') && isfield(auxdata.IDX.Storage,'Tertiary')

    idx_Control_S   = auxdata.IDX.Storage.Tertiary.Control;

else
    idx_Control_S   = [0;0;0];
end

u_charge_idx    = idx_Control_S(1,1);
u_discharge_idx = idx_Control_S(2,1);
u_rev_idx       =  idx_Control_S(3,1);

end


%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%

function [Data,Names,Mycolors] = removezero(data_,names_,mycolors_)

k = 1;
for i=1:length(data_)
    
    % TF = any(data_(1,i));
    TF = gt(data_(1,i),0.001);

    if TF
        Data(1,k) = data_(1,i);
        Names(1,k) = names_(1,i);
        Mycolors(k,:) = mycolors_(i,:);
        k = k+1;
    end
end


end
