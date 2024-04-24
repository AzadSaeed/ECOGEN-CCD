% This script defines and implements the capacity and dispatch optimization
% problem using the open-soource DTQP software. The three case studies 
% presented here are discussed in detail in the following article:
% 
% Azad, S, Gulumjanli, Z., and Herber, D.R., 2024. "A general framework for
% supporting economic feasibility of generator and storage energy systems
% through capacity and dispatch optimization" (submitted to) ASME IDETC
% 2024
% Available at https://arxiv.org/abs/2404.14583
%
% Primary Contributer: Saeed Azad, PhD

clear; clc; close all;


% Move to the correct directory and add folder to path
dir_path = mfilename('fullpath');
pathstr  = fileparts(dir_path);
cd(pathstr);
addpath(genpath(pathstr));
auxdata.General.pathstr = pathstr;

% Generator Types
Genlist    = {'CC221', 'Onshore_Wind', 'Advanced_Nuclear'};
Generators = upper(Genlist(1,:));

% Is renewable?
GenRenFlag = [0,1,0];

% Storage Types
Storagelist = {'Thermal', 'BESS', 'hydrogen_HTSE'};
Storages    = upper(Storagelist(1,:));

% Solve cases
Cases       = {'CaseStudy1';'CaseStudy2';'CaseStudy3'};
Generator   = {Generators(1,1); Generators(1,2); Generators(1,3)};

% Define the type of storage for each study: Primary, electrial, tertiary
PET_all   = [1, 0, 0;
             0, 1, 0;
             0, 0, 1];
T_cases = table(Cases,Generator, PET_all);

% Scaling values for the objective function
f_scale_vec = [10^9, 10^9, 10^9];


for i = 1:length(Cases)

    Generator = T_cases.Generator{i,1};
    PET = T_cases.PET_all(i,:);
    CaseStudy = T_cases.Cases(i,1);
    auxdata.General.PET = PET;

    fprintf('Case Study %d is starting with %s generators and %s storage systems\n',...
        i,string(length(Generator)),string(sum(PET)))

    [~,c] = find(PET==1);
    Storage   = Storages(1,c);

    fprintf('Generator is %s.\n',Generator{1,1})

    if ~isempty(Storage)
        fprintf('Storage is %s.\n',Storage{1,1})
    end

    auxdata.General.CaseStudy = CaseStudy{1,1};

    auxdata.Scale.f = f_scale_vec(1,i);
    auxdata.GenRenFlag = GenRenFlag(1,i);

    RunCases(Generator, Storage, auxdata)
    close all;

end




%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%


