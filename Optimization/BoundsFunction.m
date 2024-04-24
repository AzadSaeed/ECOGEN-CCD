function [LB, UB] = BoundsFunction(auxdata, Opts)
% This function defines the simple bounds associated with the problem. This
% in cludes bounds on plants, controls, and states, as well as initial and 
% final states.
%
% Saeed Azad, PhD

% Initial States
[LB, UB] = InitialStates(auxdata,Opts);

% Plants
[LB, UB] = PlantBounds(LB,UB,auxdata,Opts);

% Controls
[LB, UB] = ControlBounds(LB,UB,auxdata,Opts);

% States
[LB, UB] = StateBounds(LB,UB,auxdata,Opts);

% Final States
[LB, UB] = FinalStates(LB,UB,auxdata,Opts);

end


%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%

function [LB, UB] = InitialStates(auxdata,Opts)

if isfield(auxdata.IDX,'Generator')

    idx_State_G = auxdata.IDX.Generator.State ;
    idx_Control_G = auxdata.IDX.Generator.Control;

end

% Number of States 
N_State  = Opts.DTQP.subsys.Nx_G+Opts.DTQP.subsys.Nx_S;

% Create a zero vector
State_mat = zeros(N_State,1);

% Initial Generator state
idx = 1;
LB(idx).right = 4; LB(idx).matrix = State_mat;
UB(idx).right = 4; UB(idx).matrix = State_mat;


% Generator
LB(idx).matrix(idx_State_G,1) = auxdata.Generator.x_G0;
UB(idx).matrix(idx_State_G,1) = auxdata.Generator.x_G0;

% Storages
if isfield(auxdata.IDX,'Storage')

    % Primary
    if isfield(auxdata.IDX.Storage,'Primary')

        idx_State_S = auxdata.IDX.Storage.Primary.State ;

        for i = 1:length(auxdata.General.StorageFlag)

            if strcmpi(auxdata.General.StorageFlag{1,i},'Thermal')
                IDX = i;
                LB(idx).matrix(idx_State_S,1) = auxdata.Storage.x_S0(1,IDX);
                UB(idx).matrix(idx_State_S,1) = auxdata.Storage.x_S0(1,IDX);
            end
        end

    end

    % Electrical
    if isfield(auxdata.IDX.Storage,'Electrical')

        idx_State_S = auxdata.IDX.Storage.Electrical.State ;

        for i = 1:length(auxdata.General.StorageFlag)

            if strcmpi(auxdata.General.StorageFlag{1,i},'BESS')
                IDX = i;
                LB(idx).matrix(idx_State_S,1) = auxdata.Storage.x_S0(1,IDX);
                UB(idx).matrix(idx_State_S,1) = auxdata.Storage.x_S0(1,IDX);
            end
        end

    end


    % Tertiary
    if isfield(auxdata.IDX.Storage,'Tertiary')

        idx_State_S = auxdata.IDX.Storage.Tertiary.State ;

        for i = 1:length(auxdata.General.StorageFlag)

            if strcmpi(auxdata.General.StorageFlag{1,i},'HYDROGEN_HTSE')
                IDX = i;
                LB(idx).matrix(idx_State_S,1) = auxdata.Storage.x_S0(1,IDX);
                UB(idx).matrix(idx_State_S,1) = auxdata.Storage.x_S0(1,IDX);
            end
        end

    end

end

end

%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%

function [LB, UB] = PlantBounds(LB,UB,auxdata, Opts)
    
idx = length(LB);

% Number of plants 
N_Plant  = Opts.DTQP.subsys.Np_G+Opts.DTQP.subsys.Np_S;


if Opts.DTQP.subsys.Np_G > 0
    msg = 'Generator plant is not developed yet!';
    error(msg);
end

if isfield(auxdata.IDX,'Storage')

    % Create a zero vector
    plant_mat = zeros(N_Plant,1);

    % Capacity_min <= Capacity <= Capacity_max
    idx = idx + 1;
    LB(idx).right = 3; LB(idx).matrix = plant_mat;
    LB(idx).matrix = auxdata.Storage.P_Smin';

    UB(idx).right = 3; UB(idx).matrix = plant_mat;
    UB(idx).matrix = auxdata.Storage.P_Smax';

end


end

%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%

function [LB, UB] = ControlBounds(LB,UB,auxdata,Opts)

idx = length(LB);

% Number of controls 
N_Control  = Opts.DTQP.subsys.Nu_G+Opts.DTQP.subsys.Nu_S;


% Create a zero vector
Control_mat = zeros(N_Control,1);

idx = idx + 1;
LB(idx).right = 1; LB(idx).matrix = Control_mat;
UB(idx).right = 1; UB(idx).matrix = Control_mat;


if isfield(auxdata.IDX,'Generator')
    idx_Control_G = auxdata.IDX.Generator.Control;
    LB(idx).matrix(idx_Control_G,1) = auxdata.Generator.u_Gmin;
    UB(idx).matrix(idx_Control_G,1) = auxdata.Generator.u_Gmax;
end

% Storages
if isfield(auxdata.IDX,'Storage')

    % Primary
    if isfield(auxdata.IDX.Storage,'Primary')

        idx_Control_S = auxdata.IDX.Storage.Primary.Control;
        u_charge_idx = idx_Control_S(1,1);
        u_discharge_idx = idx_Control_S(2,1);
        u_rev_idx           =  idx_Control_S(3,1);

        for i = 1:length(auxdata.General.StorageFlag)

            if strcmpi(auxdata.General.StorageFlag{1,i},'Thermal')

                IDX = i;

                LB(idx).matrix(u_charge_idx,1) = auxdata.Storage.u1_Smin(1,IDX);
                LB(idx).matrix(u_discharge_idx,1) = auxdata.Storage.u2_Smin(1,IDX);
                LB(idx).matrix(u_rev_idx,1) = auxdata.Storage.u3_Smin(1,IDX);

                UB(idx).matrix(u_charge_idx,1) = auxdata.Storage.u1_Smax(1,IDX);
                UB(idx).matrix(u_discharge_idx,1) = auxdata.Storage.u2_Smax(1,IDX);
                UB(idx).matrix(u_rev_idx,1) = auxdata.Storage.u3_Smax(1,IDX);
            end
        end

    end

    % Electrical
    if isfield(auxdata.IDX.Storage,'Electrical')

        idx_Control_S = auxdata.IDX.Storage.Electrical.Control;
        u_charge_idx = idx_Control_S(1,1);
        u_discharge_idx = idx_Control_S(2,1);
        u_rev_idx           =  idx_Control_S(3,1);

        for i = 1:length(auxdata.General.StorageFlag)

            if strcmpi(auxdata.General.StorageFlag{1,i},'BESS')

                IDX = i;

                LB(idx).matrix(u_charge_idx,1) = auxdata.Storage.u1_Smin(1,IDX);
                LB(idx).matrix(u_discharge_idx,1) = auxdata.Storage.u2_Smin(1,IDX);
                LB(idx).matrix(u_rev_idx,1) = auxdata.Storage.u3_Smin(1,IDX);

                UB(idx).matrix(u_charge_idx,1) = auxdata.Storage.u1_Smax(1,IDX);
                UB(idx).matrix(u_discharge_idx,1) = auxdata.Storage.u2_Smax(1,IDX);
                UB(idx).matrix(u_rev_idx,1) = auxdata.Storage.u3_Smax(1,IDX);
            end
        end

    end


    % Tertiary
    if isfield(auxdata.IDX.Storage,'Tertiary')

        idx_Control_S = auxdata.IDX.Storage.Tertiary.Control;
        u_charge_idx = idx_Control_S(1,1);
        u_discharge_idx = idx_Control_S(2,1);
        u_rev_idx           =  idx_Control_S(3,1);

        for i = 1:length(auxdata.General.StorageFlag)

            if strcmpi(auxdata.General.StorageFlag{1,i},'hydrogen_HTSE')

                IDX = i;

                LB(idx).matrix(u_charge_idx,1) = auxdata.Storage.u1_Smin(1,IDX);
                LB(idx).matrix(u_discharge_idx,1) = auxdata.Storage.u2_Smin(1,IDX);
                LB(idx).matrix(u_rev_idx,1) = auxdata.Storage.u3_Smin(1,IDX);

                UB(idx).matrix(u_charge_idx,1) = auxdata.Storage.u1_Smax(1,IDX);
                UB(idx).matrix(u_discharge_idx,1) = auxdata.Storage.u2_Smax(1,IDX);
                UB(idx).matrix(u_rev_idx,1) = auxdata.Storage.u3_Smax(1,IDX);
            end
        end

    end
end


end

%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%

function [LB, UB] = StateBounds(LB,UB,auxdata,Opts)

idx = length(LB);

% Number of States 
N_State  = Opts.DTQP.subsys.Nx_G+Opts.DTQP.subsys.Nx_S;

% Create a zero vector
State_mat = zeros(N_State,1);

idx = idx + 1;
LB(idx).right = 2; LB(idx).matrix = State_mat;
UB(idx).right = 2; UB(idx).matrix = State_mat;

if isfield(auxdata.IDX,'Generator')
    idx_State_G = auxdata.IDX.Generator.State;
    LB(idx).matrix(idx_State_G,1) = auxdata.Generator.x_Gmin;
    UB(idx).matrix(idx_State_G,1) = auxdata.Generator.x_Gmax;
end

if isfield(auxdata.IDX,'Storage')
    % Primary
    if isfield(auxdata.IDX.Storage,'Primary')

        idx_State_S = auxdata.IDX.Storage.Primary.State;

        for i = 1:length(auxdata.General.StorageFlag)

            if strcmpi(auxdata.General.StorageFlag{1,i},'Thermal')

                IDX = i;
                LB(idx).matrix(idx_State_S,1) = 0;
                UB(idx).matrix(idx_State_S,1) = auxdata.Storage.P_Smax(1, IDX);

            end
        end

    end

    % Electrical
    if isfield(auxdata.IDX.Storage,'Electrical')

        idx_State_S = auxdata.IDX.Storage.Electrical.State;

        for i = 1:length(auxdata.General.StorageFlag)

            if strcmpi(auxdata.General.StorageFlag{1,i},'BESS')

                IDX = i;
                LB(idx).matrix(idx_State_S,1) = 0;
                UB(idx).matrix(idx_State_S,1) = auxdata.Storage.P_Smax(1, IDX);

            end
        end

    end

    % Tertiary
    if isfield(auxdata.IDX.Storage,'Tertiary')

        idx_State_S = auxdata.IDX.Storage.Tertiary.State;

        for i = 1:length(auxdata.General.StorageFlag)

            if strcmpi(auxdata.General.StorageFlag{1,i},'Hydrogen_HTSE')

                IDX = i;
                LB(idx).matrix(idx_State_S,1) = 0;
                UB(idx).matrix(idx_State_S,1) = auxdata.Storage.P_Smax(1, IDX);

            end
        end

    end

end

end

%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%

function [LB, UB] = FinalStates(LB,UB,auxdata,Opts)

idx = length(LB);


% Number of States 
N_State  = Opts.DTQP.subsys.Nx_G+Opts.DTQP.subsys.Nx_S;

% Create a zero vector
State_mat = zeros(N_State,1);

idx = idx + 1;
LB(idx).right = 5; LB(idx).matrix = State_mat;
UB(idx).right = 5; UB(idx).matrix = State_mat;

if isfield(auxdata.IDX,'Generator')
    idx_State_G = auxdata.IDX.Generator.State;
    LB(idx).matrix(idx_State_G,1) = auxdata.Generator.x_Gmin;
    UB(idx).matrix(idx_State_G,1) = auxdata.Generator.x_Gmax;
end

if isfield(auxdata.IDX,'Storage')
    % Primary
    if isfield(auxdata.IDX.Storage,'Primary')

        idx_State_S = auxdata.IDX.Storage.Primary.State;

        for i = 1:length(auxdata.General.StorageFlag)

            if strcmpi(auxdata.General.StorageFlag{1,i},'Thermal')

                IDX = i;
                LB(idx).matrix(idx_State_S,1) = auxdata.Storage.x_Sf(1, IDX);
                UB(idx).matrix(idx_State_S,1) = auxdata.Storage.x_Sf(1, IDX);

            end
        end

    end

    % Electrical
    if isfield(auxdata.IDX.Storage,'Electrical')

        idx_State_S = auxdata.IDX.Storage.Electrical.State;

        for i = 1:length(auxdata.General.StorageFlag)

            if strcmpi(auxdata.General.StorageFlag{1,i},'BESS')

                IDX = i;
                LB(idx).matrix(idx_State_S,1) =  auxdata.Storage.x_Sf(1, IDX);
                UB(idx).matrix(idx_State_S,1) = auxdata.Storage.x_Sf(1, IDX);

            end
        end

    end

    % Tertiary
    if isfield(auxdata.IDX.Storage,'Tertiary')

        idx_State_S = auxdata.IDX.Storage.Tertiary.State;

        for i = 1:length(auxdata.General.StorageFlag)

            if strcmpi(auxdata.General.StorageFlag{1,i},'Hydrogen_HTSE')

                IDX = i;
                LB(idx).matrix(idx_State_S,1) = auxdata.Storage.x_Sf(1, IDX);
                UB(idx).matrix(idx_State_S,1) = auxdata.Storage.x_Sf(1, IDX);

            end
        end

    end
end

end