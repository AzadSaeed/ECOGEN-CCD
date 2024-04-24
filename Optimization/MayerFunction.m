function M = MayerFunction(~, auxdata)
% This function creates all the Mayer terms in the problem.
%
% Saeed Azad, PhD

GeneratorFlag = auxdata.General.GeneratorFlag;
StorageFlag = auxdata.General.StorageFlag;

NG = length(GeneratorFlag);
NS = length(StorageFlag);

% Preallocate for efficiency
M(NG+NS).left = [];
M(NG+NS).right = [];
M(NG+NS).matrix = [];

% scaling factor for objective function
f_scale = auxdata.Scale.f;

%-------------------------------------------------------------------------%
% ---------------------------- Generator ---------------------------------%
%-------------------------------------------------------------------------%

if ~auxdata.RetrofitFlag
    for G = 1:length(GeneratorFlag)

        % Overnight construction cost plus costs incurred over construction
        M(G).left = 0;
        M(G).right = 0;
        M(G).matrix = (1./f_scale)*auxdata.Generator.OCC_G(G)*(1+auxdata.Economics.idc_G(G));

    end
end

%-------------------------------------------------------------------------%
% ----------------------------- Storage  ---------------------------------%
%-------------------------------------------------------------------------%

for S = 1:length(StorageFlag)

    % Minimize fixed cost of storage medium
    M(G+S).left = 0;
    M(G+S).right = 3;
    M(G+S).matrix =  (1./f_scale)*auxdata.Storage.OCC_S(S)*(1+auxdata.Economics.idc_S(S));

end



end