clear; clc; close all;

% commonFigureProperties;
% sol_old = load('A:\Azad\Resources\EnergyStorage\ECOGEN-CCD\Solution\CaseStudy1_CC221\30Years\Solution.mat');
% sol_new = load('A:\Azad\Resources\EnergyStorage\ECOGEN-CCD\Solution\CaseStudy1_CC221\30Years_with_Demand_Following\Solution.mat');
% 
% Time_int = 1:10000;
% 
% figure(1)
% stairs(sol_old.sol.T(Time_int), sol_old.sol.Y(Time_int,1),'.-','Color',sol_new.sol.auxdata.Colors.Generator_State_Color)
% hold on
% stairs(sol_new.sol.T(Time_int), sol_new.sol.Y(Time_int,1),'.-','Color',C.orange(10,:))
% 
% 
% figure(2)
% subplot(3,1,1)
% stairs(sol_old.sol.T(Time_int), sol_old.sol.U(Time_int,2),'.-','Color',sol_new.sol.auxdata.Colors.Charge_Color)
% hold on
% stairs(sol_new.sol.T(Time_int), sol_new.sol.U(Time_int,2),'.-','Color',C.orange(10,:))
% xlabel('t')
% ylabel('$u_\textrm{charge}$')
% legend({'No demand following','With demand following'},'Location','Northwest')
% 
% subplot(3,1,2)
% stairs(sol_old.sol.T(Time_int), sol_old.sol.U(Time_int,3),'.-','Color',sol_new.sol.auxdata.Colors.Discharge_Color)
% hold on
% stairs(sol_new.sol.T(Time_int), sol_new.sol.U(Time_int,3),'.-','Color',C.orange(10,:))
% xlabel('t')
% ylabel('$u_\textrm{discharge}$')
% legend({'No demand following','With demand following'},'Location','Northwest')
% 
% 
% subplot(3,1,3)
% stairs(sol_old.sol.T(Time_int), sol_old.sol.Y(Time_int,2),'.-','Color',sol_new.sol.auxdata.Colors.Storage_State_Color)
% hold on
% stairs(sol_new.sol.T(Time_int), sol_new.sol.Y(Time_int,2),'.-','Color',C.orange(10,:))
% xlabel('t')
% ylabel('$x_\textrm{storage}$')
% legend({'No demand following','With demand following'},'Location','Northwest')
% 
% 
% % NP value
% NPV_old = sol_old.sol.F;
% NPV_new = sol_new.sol.F;
% NPV_change = ((NPV_new-NPV_old)/(NPV_old))*100;
% max_NPV = max(NPV_old,NPV_new);
% 
% % Storage Capacity
% Storage_old = sol_old.sol.P;
% Storage_new = sol_new.sol.P;
% Storage_change = ((Storage_new-Storage_old)/(Storage_old))*100;
% max_Storage = max(Storage_old,Storage_new);
% 
% figure(3)
% x = ["NoDemand","Demand"];
% y = [NPV_old/max_NPV,Storage_old/max_Storage;NPV_new/max_NPV,Storage_new/max_Storage];
% legend('c','b')
% barh(x,y)
% 


% x = ["None", "16-16", "16-17", "16-18", "16-19", "16-20"];
% F = [2.9927,   3.5307,   4.3039,   4.3257   5.0744   5.8702];
% P = [237.5290, 263.5106, 322.4310, 274.4213 333.8728 406.8284];
% barh(x,[F/max(abs(F));P/max(P)]')


x = [4000, 5000, 6000, 7000, 8000, 9000];
F = [2.1611, 4.9821, 7.8030, 10.6240, 13.4450, 16.2660 ];
P = [15079, 15079, 15079, 15079, 15079, 15079 ]
