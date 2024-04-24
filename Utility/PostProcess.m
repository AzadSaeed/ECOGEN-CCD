function out = PostProcess(T,U,Y,P,F,auxdata,Opts)

if isfield(auxdata.IDX,'Storage') && isfield(auxdata.IDX.Storage,'Primary')

    idx_Control_S   = auxdata.IDX.Storage.Primary.Control;
    
    u_charge_idx    = idx_Control_S(1,1);
    u_discharge_idx = idx_Control_S(2,1);
    u_rev_idx       =  idx_Control_S(3,1);

    P_charge        = U(:,u_charge_idx);
    P_discharge     = U(:,u_discharge_idx);
    P_revenue       = U(:,u_rev_idx);

    % Primary load portion satisfied by storage
    L_SP = auxdata.Storage.eta2_S*(P_discharge-P_revenue);

    % Primary revenue portion of the discharge
    P_R  = auxdata.Storage.eta2_S*(P_revenue);

else

    L_SP     = zeros(size(T));
    P_charge = zeros(size(T));
    P_R      = zeros(size(T));

end


if isfield(auxdata.IDX,'Storage') && isfield(auxdata.IDX.Storage,'Electrical')

    idx_Control_S   = auxdata.IDX.Storage.Electrical.Control;

    u_charge_idx    = idx_Control_S(1,1);
    u_discharge_idx = idx_Control_S(2,1);
    u_rev_idx       = idx_Control_S(3,1);

    E_charge        = U(:,u_charge_idx);
    E_discharge     = U(:,u_discharge_idx);
    E_revenue       = U(:,u_rev_idx);

    % Electrical load portion satisfied by storage
    L_SE = auxdata.Storage.eta2_S*(E_discharge-E_revenue);

    % Electrical revenue portion of the discharge
    E_R  = auxdata.Storage.eta2_S*(E_revenue);

else

    L_SE      =  zeros(size(T));
    E_charge  =  zeros(size(T));
    E_R       =  zeros(size(T));

end


if isfield(auxdata.IDX,'Storage') && isfield(auxdata.IDX.Storage,'Tertiary')

    idx_Control_S   = auxdata.IDX.Storage.Tertiary.Control;
    
    u_charge_idx    = idx_Control_S(1,1);
    u_discharge_idx = idx_Control_S(2,1);
    u_rev_idx       = idx_Control_S(3,1);
    u_charge_idx_T  = u_charge_idx;

    T_charge        = U(:,u_charge_idx);
    T_discharge     = U(:,u_discharge_idx);
    T_revenue       = U(:,u_rev_idx);

    % Electricity generated from combusting hydrogen
    ET = (1./auxdata.Storage.eta_c_T2E)*auxdata.Storage.eta2_S*(T_discharge-T_revenue);

    % Tertiary revenue portion of the discharge
    T_R = auxdata.Storage.eta2_S*(T_revenue);

    % Primary load requirements for tertiary storage
    if auxdata.Loads.LP_T == 0
        PrimaryLoad_T = zeros(size(T));
    else
        PrimaryLoad_T = auxdata.Loads.LP_T*U(:,u_charge_idx_T);
    end

else

    ET =  zeros(size(T));
    T_charge =  zeros(size(T));
    PrimaryLoad_T = zeros(size(T));
    T_R = zeros(size(T));

end


idx_State_G = auxdata.IDX.Generator.State;

% Primary load 
PrimaryLoad = auxdata.Loads.LP_G*Y(:,idx_State_G);

% Primary load satisfied by generator
L_GP = PrimaryLoad - L_SP;

% Electrical load
ElectricalLoad = auxdata.Loads.LE*Y(:,idx_State_G);

% Electrical load satidfied by generator
L_GE = ElectricalLoad -  L_SE;


xg_1 = Y(:,idx_State_G);
xg_2 = xg_1 - P_charge;
xg_3 = xg_2 - L_GP;
xg_4 = xg_3 - PrimaryLoad_T;
xg_5 = auxdata.Generator.eta_G*xg_4;
xg_6 = xg_5 - E_charge;
xg_7 = xg_6 - L_GE;
xg_8 = xg_7 - T_charge;
xg_9 = xg_8 + ET;

% Add electricity from electrical storage
xg_10 = xg_9+ E_R;
xGrid = xg_10;


out.nodes.node1 = xg_1;
out.nodes.node2 = xg_2;
out.nodes.node3 = xg_3;
out.nodes.node4 = xg_4;
out.nodes.node5 = xg_5;
out.nodes.node6 = xg_6;
out.nodes.node7 = xg_7;
out.nodes.node8 = xg_8;
out.nodes.node9 = xg_9;
out.nodes.Grid = xGrid;

out.PrimaryLoad.total = PrimaryLoad;
out.PrimaryLoad.Gen = L_GP;
out.PrimaryLoad.Storage = L_SP;

out.ElectricalLoad.total = ElectricalLoad;
out.ElectricalLoad.Gen = L_GE;
out.ElectricalLoad.Storage = L_SE;

out.Tertiary.PrimaryLoad_T = PrimaryLoad_T;
out.Tertiary.ET = ET;
out.Tertiary.Revenue_T = T_R;

end