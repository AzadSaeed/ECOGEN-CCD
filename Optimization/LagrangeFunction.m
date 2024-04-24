function L  = LagrangeFunction(Opts, auxdata)
% This function calls and assembles all the largange terms to be passed to 
% DTQP.
%
% Saeed Azad

% Lagrange terms for generator
if isfield(auxdata.IDX,'Generator')
    L = Lagrane_Generator(auxdata,Opts);
else
    error('Generator must be defined')
end



% Add terms from the primary storage if its on
TFP = auxdata.General.PET(1,1);
if TFP
    L = Lagrane_Primary_Storage(L,auxdata,Opts);
end


% Add terms from the Electrical storage if its on
TFP = auxdata.General.PET(1,2);
if TFP
    L = Lagrane_Electrical_Storage(L,auxdata,Opts);
end


% Add terms from the Tertiary storage if its on
TFP = auxdata.General.PET(1,3);
if TFP
    L = Lagrane_Tertiary_Storage(L,auxdata,Opts);
end




end

















