function Create_Custom_Plots(varargin)

if nargin==0

    Solution = load('xxx');
    Solution = Solution.sol;

elseif nargin ==1

    Solution = varargin{1,1};
    
    % Repository
    Add_ = 'xxx';

    if ~strcmpi(Solution.auxdata.General.CaseStudy_path,Add_)
        Solution.auxdata.General.CaseStudy_path = Add_;
    end

end

TimePeriod = 1:length(Solution.T);

T = Solution.T(TimePeriod,1);
U = Solution.U(TimePeriod,:);
Y = Solution.Y(TimePeriod,:);
P = Solution.P;
F = Solution.F;
in = Solution.in;
Opts = Solution.opts;
auxdata = Solution.auxdata;

% Get node values for optimal solution
out = PostProcess(T,U,Y,P,F,auxdata,Opts);


auxdata.General.PlotFlag = 1;
PlotStates(T,Y,P,auxdata);
PlotControls(T,U,auxdata,Opts);
PlotGrid(T,U,Y,P,F,auxdata,Opts,out);


end