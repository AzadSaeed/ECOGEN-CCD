function [sol,auxdata,Opts] = RunCases(varargin)

if nargin == 1

    GeneratorFlag = varargin{1};
    StorageFlag   = 'Thermal'; % default 
    auxdata       = []; % default 

elseif nargin == 2

    GeneratorFlag = varargin{1,1};
    StorageFlag   = varargin{1,2};
    auxdata       = []; % default

elseif nargin == 3

    GeneratorFlag = varargin{1,1};
    StorageFlag   = varargin{1,2};
    auxdata       = varargin{1,3};

end


% Create a directory for the case study
auxdata = CreateDir(auxdata,GeneratorFlag);

% Pass generator and storage flags to the auxiliary data
auxdata.General.GeneratorFlag = GeneratorFlag;
auxdata.General.StorageFlag   = StorageFlag;

% Get apprpriate problem options
[Opts, auxdata] = ProblemOptions(auxdata);

% Set up DTQP
[setup,Opts,auxdata]  = DTQP_Setup_IES(Opts, auxdata);

% Solve problem
sol  = SolveProblem(setup, Opts, auxdata);


end

%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%

function auxdata = CreateDir(auxdata,GeneratorFlag)

CaseStudy_path = strcat(auxdata.General.pathstr,filesep,'Solution',...
    filesep,auxdata.General.CaseStudy,'_',GeneratorFlag{1,1});

if ~isfolder(CaseStudy_path)
    mkdir(CaseStudy_path)
end

auxdata.General.CaseStudy_path = CaseStudy_path;
end