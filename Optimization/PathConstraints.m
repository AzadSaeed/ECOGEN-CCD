function Z = PathConstraints(auxdata, Opts)

Z = [];


% Generator path constraint - only for renewables such as wind
% U_gen(t) < = u_available(t)
if auxdata.GenRenFlag
    Z = PathConstraint_Renewable(Z,auxdata, Opts);
end



% Signal sent by the generator to satisfy the thermal and electrical loads
% must be positive and smaller than the power available in the generator
% 0 <= L_GP(t)
% 0 <= L_PT(t)
% 0 <= L_GE(t)
% L_GP <= x_gen(t) - u_Charge_P(t)
% L_GE <= eta_G(x_gen(t) - u_Charge_P(t) - L_GP - LPT) - u_Charge_E(t)
Z = PathConstraint_G2(Z,auxdata, Opts);


% Storage state smaller than plant (i.e. capacity) 
% x_storgae <= Storage capacity
if isfield(auxdata.IDX,'Storage')
    Z = PathConstraintG3(Z,auxdata, Opts);
end



% Charging signal smaller than generator power level 
% u_Charge_P(t) <= x_gen(t)
% u_Charge_E(t) <= x_gen(t) - u_Charge_P(t) - L_GP
if isfield(auxdata.IDX,'Storage')
    Z = PathConstraintG4(Z,auxdata, Opts);
end



% Revenue signal is always smaller or equal to the discharge 
% U_R <= U_Discharge
if isfield(auxdata.IDX,'Storage')
    Z = PathConstraintG5(Z,auxdata, Opts);
end


% Discrete market demand constriant: sales can be made only at certain times 
if isfield(auxdata.IDX,'Storage') && isfield(auxdata.IDX.Storage,'Tertiary')
    Z = Path_DiscreteMarketDemand(Z,auxdata,Opts);
end


% Load following constraint
if auxdata.Demand_cons
    Z = Path_DemandFollowing(Z,auxdata,Opts);
end

end

%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%






%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%



%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%



%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%



%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
% function Z = PathConstraint4(Z,auxdata, Opts)
% 
% idx = length(Z);
% 
% % Number of controls and states
% N_Control  = Opts.DTQP.subsys.Nu_G+Opts.DTQP.subsys.Nu_S;
% N_State  = Opts.DTQP.subsys.Nx_G+Opts.DTQP.subsys.Nx_S;
% 
% % Create a zero vector
% Control_mat = zeros(N_Control,1);
% State_mat = zeros(N_State,1);


% if auxdata.Loads.LE~=0
% 
%     % L_GE < = power left in the signal 
%     idx = idx + 1;
% 
%     % L_GE = LE*x_G - eta_discharge_E*E_discharge + eta_discharge_E*u_ER
%     Z(idx).linear(1).right = 2; Z(idx).linear(1).matrix = State_mat;
%     Z(idx).linear(2).right = 1; Z(idx).linear(2).matrix = Control_mat;
%     Z(idx).linear(3).right = 1; Z(idx).linear(3).matrix = Control_mat;
% 
%     % Available power in the signal
%     Z(idx).linear(4).right = 2; Z(idx).linear(4).matrix = State_mat;
%     Z(idx).linear(5).right = 1; Z(idx).linear(5).matrix = Control_mat;
%     Z(idx).linear(6).right = 2; Z(idx).linear(6).matrix = State_mat;
%     Z(idx).linear(7).right = 1; Z(idx).linear(7).matrix = Control_mat;
%     Z(idx).linear(8).right = 1; Z(idx).linear(8).matrix = Control_mat;
%     Z(idx).linear(9).right = 1; Z(idx).linear(9).matrix = Control_mat;
%     Z(idx).b = 0;
% 
%     if isfield(auxdata.IDX,'Generator')
%         idx_State_G = auxdata.IDX.Generator.State;
%         Z(idx).linear(1).matrix(idx_State_G,1) = auxdata.Loads.LE;
%         Z(idx).linear(4).matrix(idx_State_G,1) = -auxdata.Generator.eta_G;
%         Z(idx).linear(6).matrix(idx_State_G,1) = -auxdata.Generator.eta_G*auxdata.Loads.LP;
%     end
% 
%     if isfield(auxdata.IDX.Storage,'Primary')
% 
%         idx_Control_S = auxdata.IDX.Storage.Primary.Control;
%         u_charge_idx = idx_Control_S(1,1);
%         u_discharge_idx = idx_Control_S(2,1);
% 
%         u_rev_idx = idx_Control_S(3,1);
%         eta_p_discharge = auxdata.Storage.eta2_S;
% 
%         for i = 1:length(auxdata.General.StorageFlag)
% 
%             if strcmpi(auxdata.General.StorageFlag{1,i},'Thermal')
%                 Z(idx).linear(5).matrix(u_charge_idx,1) = auxdata.Generator.eta_G;
%                 Z(idx).linear(7).matrix(u_discharge_idx,1) = -auxdata.Generator.eta_G*eta_p_discharge;
%                 Z(idx).linear(8).matrix(u_rev_idx,1) = auxdata.Generator.eta_G*eta_p_discharge;
%             end
%         end
% 
%     end
% 
% 
%     if isfield(auxdata.IDX.Storage,'Electrical')
% 
%         idx_Control_S = auxdata.IDX.Storage.Electrical.Control;
%         u_charge_idx = idx_Control_S(1,1);
%         u_discharge_idx = idx_Control_S(2,1);
%         u_rev_idx = idx_Control_S(3,1);
%         eta_e_discharge = auxdata.Storage.eta2_S;
% 
%         for i = 1:length(auxdata.General.StorageFlag)
% 
%             if strcmpi(auxdata.General.StorageFlag{1,i},'BESS')
%                 Z(idx).linear(2).matrix(u_discharge_idx,1) = -eta_e_discharge;
%                 Z(idx).linear(3).matrix(u_rev_idx,1) = eta_e_discharge;
%                 Z(idx).linear(9).matrix( u_charge_idx,1) =1;
%             end
%         end
% 
%     end
% 
% end
% 
% end

%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
% function Z = PathConstraint5(Z,auxdata, Opts)
% 
% idx = length(Z);
% 
% % Number of controls and states
% N_Control  = Opts.DTQP.subsys.Nu_G+Opts.DTQP.subsys.Nu_S;
% N_State  = Opts.DTQP.subsys.Nx_G+Opts.DTQP.subsys.Nx_S;
% 
% % Create a zero vector
% Control_mat = zeros(N_Control,1);
% State_mat = zeros(N_State,1);
% 
% 
% if auxdata.Loads.LP~=0
% 
% 
%     % L_GP <= Power left in the signal
%     idx = idx + 1;
% 
%     % L_GP = LP*x_G - eta_discharge_P*P_discharge + eta_discharge_P*u_PR
%     Z(idx).linear(1).right = 2; Z(idx).linear(1).matrix = State_mat;
%     Z(idx).linear(2).right = 1; Z(idx).linear(2).matrix = Control_mat;
%     Z(idx).linear(3).right = 1; Z(idx).linear(3).matrix = Control_mat;
% 
%     Z(idx).linear(4).right = 2; Z(idx).linear(4).matrix = State_mat;
%     Z(idx).linear(5).right = 1; Z(idx).linear(5).matrix = Control_mat;
% 
%     Z(idx).b = 0;
% 
%     if isfield(auxdata.IDX,'Generator')
%         idx_State_G = auxdata.IDX.Generator.State;
%         Z(idx).linear(1).matrix(idx_State_G,1) = auxdata.Loads.LP;
%         Z(idx).linear(4).matrix(idx_State_G,1) = -1;
%     end
% 
%     % Primary
%     if isfield(auxdata.IDX.Storage,'Primary')
% 
%        idx_Control_S = auxdata.IDX.Storage.Primary.Control;
%        u_charge_idx = idx_Control_S(1,1);
%         u_discharge_idx = idx_Control_S(2,1);
%         u_rev_idx = idx_Control_S(3,1);
%         eta_p_discharge = auxdata.Storage.eta2_S;
% 
%         for i = 1:length(auxdata.General.StorageFlag)
% 
%             if strcmpi(auxdata.General.StorageFlag{1,i},'Thermal')
%                 Z(idx).linear(2).matrix(u_discharge_idx,1) = -eta_p_discharge;
%                 Z(idx).linear(3).matrix(u_rev_idx,1) = eta_p_discharge;
%                 Z(idx).linear(5).matrix(u_charge_idx,1) = 1;
%             end
%         end
% 
%     end
% 
% end
% 
% end


