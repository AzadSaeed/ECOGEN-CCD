function Colors = PlotColors

% Define RGB values for all signals:

% Generator state color
Colors.Generator_State_Color = [29,63,115]./255;

% Fuel color
Colors.Fuel_Color = [105, 105, 105]./255;

% Electricity color
Colors.ElectricityPrice_Color = [205,55,0]./255;

% Storage state color
Colors.Storage_State_Color = [29,106,115]./255;

% Charge (control) color
Colors.Charge_Color = [63,115,29]./255;

% Discharge (control) color
Colors.Discharge_Color = [115,29,63]./255;

% Revenue (control) color
Colors.RevControl_Color = [18,102,79]./255;

% Load color for LGP and LGE Constraints
Colors.LoadConstraint_Color1 = [64,78,124]./255;
Colors.LoadConstraint_Color2 = [244,211,94]./255;

% Grid Color 
Colors.GridColor = [106, 115, 29]./255;

% Wind Color
Colors.WindColor = [129,195,215]./255;

% Primary load for Tertiary Storage color
Colors.PrimaryLoad_T = [255, 166, 48]./255;

% Loss color
Colors.Loss = [235, 235, 235]./255;


end