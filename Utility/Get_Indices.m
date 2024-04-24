function [Generator,Storage] = Get_Indices(PST)

% Get generator indices
Generator.State = 1;
Generator.Control = 1;


% Get storage indices
if PST(1,1) && ~PST(1,2) && ~PST(1,3)

    Primary.Plant = 1;
    Primary.State = Generator.State+1;
    Primary.Control = [Generator.Control+1;Generator.Control+2;Generator.Control+3];
    Storage.Primary = Primary;

elseif ~PST(1,1) && PST(1,2) && ~PST(1,3)

    Electrical.Plant = 1;
    Electrical.State = Generator.State+1;
    Electrical.Control = [Generator.Control+1;Generator.Control+2;Generator.Control+3];
    Storage.Electrical = Electrical;

elseif ~PST(1,1) && ~PST(1,2) && PST(1,3)

    Tertiary.Plant = 1;
    Tertiary.State = Generator.State+1;
    Tertiary.Control = [Generator.Control+1;Generator.Control+2;Generator.Control+3];
    Storage.Tertiary = Tertiary;

elseif PST(1,1) && PST(1,2) && ~PST(1,3)

    Primary.Plant = 1;
    Primary.State = Generator.State+1;
    Primary.Control = [Generator.Control+1;Generator.Control+2; Generator.Control+3];

    Electrical.Plant = 2;
    Electrical.State = Generator.State+2;
    Electrical.Control = [Generator.Control+4; Generator.Control+5; Generator.Control+6];

    Storage.Primary = Primary;
    Storage.Electrical = Electrical;

elseif PST(1,1) && ~PST(1,2) && PST(1,3)

    Primary.Plant = 1;
    Primary.State = Generator.State+1;
    Primary.Control = [Generator.Control+1;Generator.Control+2;Generator.Control+3];

    Tertiary.Plant = 2;
    Tertiary.State = Generator.State+2;
    Tertiary.Control = [Generator.Control+4;Generator.Control+5;Generator.Control+6];

    Storage.Primary = Primary;
    Storage.Tertiary = Tertiary;

elseif ~PST(1,1) && PST(1,2) && PST(1,3)

    Electrical.Plant = 1;
    Electrical.State = Generator.State+1;
    Electrical.Control =[Generator.Control+1;Generator.Control+2;Generator.Control+3];

    Tertiary.Plant = 2;
    Tertiary.State = Generator.State+2;
    Tertiary.Control = [Generator.Control+4;Generator.Control+5;Generator.Control+6];

    Storage.Electrical = Electrical;
    Storage.Tertiary = Tertiary;

elseif PST(1,1) && PST(1,2) && PST(1,3)

    Primary.Plant = 1;
    Primary.State = Generator.State+1;
    Primary.Control = [Generator.Control+1;Generator.Control+2;Generator.Control+3];

    Electrical.Plant = 2;
    Electrical.State = Generator.State+2; 
    Electrical.Control = [Generator.Control+4;Generator.Control+5;Generator.Control+6];

    Tertiary.Plant = 3; 
    Tertiary.State = Generator.State+3;
    Tertiary.Control = [Generator.Control+7;Generator.Control+8;Generator.Control+9];

    Storage.Primary = Primary;
    Storage.Electrical = Electrical;
    Storage.Tertiary = Tertiary;

elseif ~PST(1,1) && ~PST(1,2) && ~PST(1,3)
    Storage = [];
end

end
































% Plant_G = subsys.Np_G;
% State_G = subsys.Nx_G; 
% Control_G = subsys.Nu_G;











% Pre-allocate storage variables with NaN for the most comprehensive case
% with 3 plants, 3 states and 6 controls
% Ps_idx = NaN(3,1);
% Xs_idx = NaN(3,1);
% Us_idx = NaN(6,1);
% 
% if subsys.Nx_G == 1
%     fprintf('Generator state index is %s for %s generator.\n',string(1),GeneratorFlag{1,1});
%     % X_idx(1,1) = 1;
% elseif subsys.Nx_G == 2
%     fprintf('Not ready yet! Improve in the future.\n',string(1),'Primary');
% end
% 
% 
% if subsys.Nu_G == 1
%     fprintf('Generator control index is %s for %s generator.\n',string(1),GeneratorFlag{1,1});
%     % U_idx(1,1) = 1;
% elseif subsys.Nu_G == 2
%     fprintf('Not ready yet!Improve in the future.\n',string(1),'Primary');
% end
% 
% 
% if PST(1,1) && ~PST(1,2) && ~PST(1,3)
% 
%     fprintf('Storage plant index is %s for %s Storage.\n',string(1),'Primary');
%     Ps_idx(1,1) = 1;
% 
%     fprintf('Storage state index is %s for %s Storage.\n',string(1),'Primary');
%     Xs_idx(1,1) = 1;
% 
%     fprintf('Storage control index is %s for %s Storage charge and %s for storage discharge.\n',string(1),'Primary',string(2));
%     Us_idx(1,1) = 1;
%     Us_idx(2,1) = 2;
% 
% elseif ~PST(1,1) && PST(1,2) && ~PST(1,3)
% 
%     fprintf('Storage plant index is %s for %s Storage.\n',string(1),'Electrical');
%     Ps_idx(2,1) = 1;
% 
%     fprintf('Storage state index is %s for %s Storage.\n',string(1),'Electrical');
%     Xs_idx(2,1) = 1;
% 
%     fprintf('Storage control index is %s for %s Storage charge and %s for storage discharge.\n',string(1),'Electrical',string(2));
%     Us_idx(3,1) = 1;
%     Us_idx(4,1) = 2;
% 
% elseif ~PST(1,1) && ~PST(1,2) && PST(1,3)
% 
%     fprintf('Storage plant index is %s for %s Storage.\n',string(1),'Tertiary');
%     Ps_idx(3,1) = 1;
% 
%     fprintf('Storage state index is %s for %s Storage.\n',string(1),'Tertiary');
%     Xs_idx(3,1) = 1;
% 
%     fprintf('Storage control index is %s for %s Storage charge and %s for storage discharge.\n',string(1),'Tertiary',string(2));
%     Us_idx(5,1) = 1;
%     Us_idx(6,1) = 2;
% 
% elseif PST(1,1) && PST(1,2) && ~PST(1,3)
% 
%     fprintf('Storage plant index is %s for %s Storage.\n',string(1),'Primary');
%     fprintf('Storage plant index is %s for %s Storage.\n',string(2),'Electrical');
%     Ps_idx(1,1) = 1;
%     Ps_idx(2,1) = 2;
% 
%     fprintf('Storage state index is %s for %s Storage.\n',string(1),'Primary');
%     fprintf('Storage state index is %s for %s Storage.\n',string(2),'Electrical');
%     Xs_idx(1,1) = 1;
%     Xs_idx(2,1) = 2;
% 
%     fprintf('Storage control index is %s for %s Storage charge and %s for storage discharge .\n',string(1),'Primary',string(2));
%     fprintf('Storage control index is %s for %s Storage charge and %s for storage discharge .\n',string(3),'Electrical',string(4));
%     Us_idx(1,1) = 1;
%     Us_idx(2,1) = 2;
%     Us_idx(3,1) = 3;
%     Us_idx(4,1) = 4;
% 
% elseif PST(1,1) && ~PST(1,2) && PST(1,3)
% 
%     fprintf('Storage plant index is %s for %s Storage.\n',string(1),'Primary');
%     fprintf('Storage plant index is %s for %s Storage.\n',string(2),'Tertiary');
%     Ps_idx(1,1) = 1;
%     Ps_idx(3,1) = 2;
% 
%     fprintf('Storage state index is %s for %s Storage.\n',string(1),'Primary');
%     fprintf('Storage state index is %s for %s Storage.\n',string(2),'Tertiary');
%     Xs_idx(1,1) = 1;
%     Xs_idx(3,1) = 2;
% 
%     fprintf('Storage control index is %s for %s Storage charge and %s for storage discharge .\n',string(1),'Primary',string(2));
%     fprintf('Storage control index is %s for %s Storage charge and %s for storage discharge .\n',string(3),'Tertiary',string(4));
%     Us_idx(1,1) = 1;
%     Us_idx(2,1) = 2;
%     Us_idx(5,1) = 3;
%     Us_idx(6,1) = 4;
% 
% 
% elseif ~PST(1,1) && PST(1,2) && PST(1,3)
% 
%     fprintf('Storage plant index is %s for %s Storage.\n',string(1),'Electrical');
%     fprintf('Storage plant index is %s for %s Storage.\n',string(2),'Tertiary');
%     Ps_idx(2,1) = 1;
%     Ps_idx(3,1) = 2;
% 
%     fprintf('Storage state index is %s for %s Storage.\n',string(1),'Electrical');
%     fprintf('Storage state index is %s for %s Storage.\n',string(2),'Tertiary');
%     Xs_idx(2,1) = 1;
%     Xs_idx(3,1) = 2;
% 
%     fprintf('Storage control index is %s for %s Storage charge and %s for storage discharge .\n',string(1),'Electrical',string(2));
%     fprintf('Storage control index is %s for %s Storage charge and %s for storage discharge .\n',string(3),'Tertiary',string(4));
%     Us_idx(3,1) = 1;
%     Us_idx(4,1) = 2;
%     Us_idx(5,1) = 3;
%     Us_idx(6,1) = 4;
% 
% elseif PST(1,1) && PST(1,2) && PST(1,3)
% 
% 
%     fprintf('Storage plant index is %s for %s Storage.\n',string(1),'Primary');
%     fprintf('Storage plant index is %s for %s Storage.\n',string(2),'Electrical');
%     fprintf('Storage plant index is %s for %s Storage.\n',string(3),'Tertiary');
%     Ps_idx = [1; 2; 3];
% 
%     fprintf('Storage state index is %s for %s Storage.\n',string(1),'Primary');
%     fprintf('Storage state index is %s for %s Storage.\n',string(2),'Electrical');
%     fprintf('Storage state index is %s for %s Storage.\n',string(3),'Tertiary');
%     Xs_idx = [1;2;3];
% 
%     fprintf('Storage control index is %s for %s Storage charge and %s for storage discharge .\n',string(1),'Primary',string(2));
%     fprintf('Storage control index is %s for %s Storage charge and %s for storage discharge .\n',string(3),'Electrical',string(4));
%     fprintf('Storage control index is %s for %s Storage charge and %s for storage discharge .\n',string(5),'Tertiary',string(6));
%     Us_idx = [1;2;3;4;5;6];
% end

% 
% IDX.P_idx_storage = Ps_idx;
% IDX.X_idx_storage = Xs_idx;
% IDX.U_idx_storage = Us_idx;
% 
% 
% % Plant indices for storage
% yps = isnan(Ps_idx);
% IDX.kps = Ps_idx(~yps);
% 
% % state indices for storage 
% yxs = isnan(Xs_idx);
% IDX.kxs = Xs_idx(~yxs);
% 
% % control indices for storage
% yus = isnan(Us_idx);
% IDX.kus= Us_idx(~yus);
% 
% 
% % Plant indices for the entire system
% if Plant_G ==0
%     IDX.kp = IDX.kps;
% else
% 
% end
% 
% % state indices for the entire system
% IDX.kx = [1; [IDX.kxs]+1];
% 
% % control indices for the entire system
% IDX.ku = [1; [IDX.kus]+1];
% 
% end