function sol = SolveProblem(setup, opts, auxdata)

[T,U,Y,P,F,in,opts] = DTQP_solve(setup,opts);

sol.T = T;
sol.U = U;
sol.Y = Y;
sol.P = P;
sol.F = F;
sol.in = in;
sol.opts = opts;

% Get node values for optimal solution
out = PostProcess(T,U,Y,P,F,auxdata,opts);

% Plots
if auxdata.General.PlotFlag
    
    PlotStates(T,Y,P,auxdata);
    PlotControls(T,U,auxdata,opts);
    PlotLoadConstraints(T,U,Y,P,F,auxdata,opts,out)
    PlotGrid(T,U,Y,P,F,auxdata,opts,out);

end


sol.nodes = out.nodes;
sol.PrimaryLoad = out.PrimaryLoad;
sol.ElectricalLoad = out.ElectricalLoad;
sol.Tertiary = out.Tertiary;
sol.auxdata = auxdata;


% Save solution
savename = strcat(auxdata.General.CaseStudy_path,filesep,'Solution');
save(savename,'sol')

end