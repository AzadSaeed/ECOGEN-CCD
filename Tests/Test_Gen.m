% This script tests the tool under the assumption that no storage units are
% present and thus, the generator is operating in isolation.
%
% 
% Primary Contributor: Saeed Azad, Ph.D.

clear; clc; close all;

% Move to the correct directory and add folder to path
dir_path = mfilename('fullpath');
pathstr  = fileparts(dir_path);
pathstr  = fileparts(pathstr);
cd(pathstr);
addpath(genpath(pathstr));
auxdata.General.pathstr = pathstr;


% Add the required packages and tools
Commonfilesetup;

% Generator Types
Genlist    = {'CC221', 'Onshore_Wind', 'Advanced_Nuclear'};
Generators = upper(Genlist(1,:));

% Storage Types
Storages    = {};
auxdata.General.StorageFlag   = Storages;

% Solve cases
Cases       = {'CaseStudy1';'CaseStudy2';'CaseStudy3'};
Generator   = {Generators(1,1); Generators(1,2); Generators(1,3)};
GenRenFlag  = [0,1,0];

% Define the type of storage for each study: Primary, electrial, tertiary
PET_all   = [0, 0, 0;
             0, 0, 0;
             0, 0, 0];
T_cases = table(Cases,Generator, PET_all);

% Scaling values for the objective function
f_scale_vec = [1, 1, 1];

for i = 1:length(Cases)

    % Pass generator and storage flags to the auxiliary data
    auxdata.General.GeneratorFlag = Generator{i,1};

    % Assign the name of the case study
    auxdata.General.CaseStudy = Cases{i,1};

    % Create a directory for the case study
    auxdata = CreateDir(auxdata,auxdata.General.GeneratorFlag);

    % Pass storage type for each case to the 
    auxdata.General.PET = T_cases.PET_all(i,:);

    % Pass flag for renewables
    auxdata.GenRenFlag = GenRenFlag(1,i);

    % Pass scaling parameter
    auxdata.Scale.f = f_scale_vec(1,i);

    % Get apprpriate problem options
    [Opts, auxdata] = ProblemOptions(auxdata);

    % Set up DTQP
    [setup,opts,auxdata]  = DTQP_Setup(Opts, auxdata);

    % Solve the problem
    sol  = SolveProblem(setup, Opts, auxdata);

    close all;
end



%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%

function auxdata = CreateDir(auxdata,GeneratorFlag)

CaseStudy_path = strcat(auxdata.General.pathstr,filesep,'Tests',...
    filesep,'Gen',auxdata.General.CaseStudy,'_',GeneratorFlag{1,1});

if ~isfolder(CaseStudy_path)
    mkdir(CaseStudy_path)
end

auxdata.General.CaseStudy_path = CaseStudy_path;

end