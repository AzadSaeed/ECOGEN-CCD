function Econ_aux = EconomicOptions(GeneratorFlag,StorageFlag)

T_con_G = NaN(1,length(GeneratorFlag));
T_con_S = NaN(1,length(StorageFlag));

for G = 1:length(GeneratorFlag)

    switch GeneratorFlag{1,G}

        case 'CC221'

            T_con_G(G) = 3;

        case 'ADVANCED_NUCLEAR'

            T_con_G(G) = 7;

        case 'ONSHORE_WIND'

            T_con_G(G) = 5;
    end

    Econ_aux.T_con_G(G) = T_con_G(G);

    % Rate of return
    Econ_aux.r = 0.075;

    % Interest during construction
    Econ_aux.idc_G = (Econ_aux.r/2).*Econ_aux.T_con_G(G) +...
        ((Econ_aux.r^2)/6).*(Econ_aux.T_con_G(G).^2);
end


for S = 1:length(StorageFlag)

    switch StorageFlag{1,S}

        case 'THERMAL'

            T_con_S(S) = 2;

        case 'BESS'

            T_con_S(S) = 1;

        case 'HYDROGEN_HTSE'

            T_con_S(S) = 5;
    end

    Econ_aux.T_con_S(S) = T_con_S(S);

    % Rate of return
    Econ_aux.r = 0.075;

    % Interest during construction
    Econ_aux.idc_S = (Econ_aux.r/2).*Econ_aux.T_con_S(S) +...
        ((Econ_aux.r^2)/6).*(Econ_aux.T_con_S(S).^2);

end


% Year function based on 365.25 days 
Econ_aux.year = @(t)floor(t/8766);


end