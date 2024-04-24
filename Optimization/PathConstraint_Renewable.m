function Z = PathConstraint_Renewable(Z,auxdata, Opts)
% This function defines the path constraints associated with the renewable
% energy resources, ensuring that the generator state is caped by the
% available resource at any given time.
%
% Saeed Azad

idx = length(Z);

% Create the state matrix of the apropriate size
N_State  = Opts.DTQP.subsys.Nx_G+Opts.DTQP.subsys.Nx_S;

% Create cells for matrices
State_mat = repmat({zeros(1,1)},1,N_State);

% State index
idx_State_G = auxdata.IDX.Generator.State ;

% xG <= Gmax(t) 
idx = idx + 1;
Z(idx).linear(1).right = 2;  Z(idx).linear(1).matrix = State_mat;
Z(idx).b = @(t)auxdata.Generator.RenLim(t);
Z(idx).linear(1).matrix{idx_State_G,1} = 1;

end