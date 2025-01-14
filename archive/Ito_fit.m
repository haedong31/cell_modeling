clc
close all
clear variables


K_data = readtable('./potassium-KO.xlsx');
% K_data = readtable('./MGAT1_Data_tidy/JMCC/K Currents 14 Weeks/potassium-WT.xlsx');

Iss_amp = K_data.IssFF;
% Iss_amp = K_data.Iss;
Iss_amp = nanmean(Iss_amp);

Ito_amp = K_data.A3FF;
% Ito_amp = K_data.A3;
Ito_amp = nanmean(Ito_amp);

tau_to = K_data.Tau3FF;
% tau_to = K_data.Tau3;
tau_to = nanmean(tau_to);

IKslow1_amp = K_data.A2FF;
% IKslow1_amp = K_data.A2;
IKslow1_amp = nanmean(IKslow1_amp);

tau1 = K_data.Tau2FF;
% tau1 = K_data.Tau2;
tau1 = nanmean(tau1);

IKslow2_amp = K_data.A1FF;
% IKslow2_amp = K_data.A1;
IKslow2_amp = nanmean(IKslow2_amp);

tau2 = K_data.Tau1FF;
% tau2 = K_data.Tau1;
tau2 = nanmean(tau2);

cap = K_data.CapFF;
% cap = K_data.Cap;
cap = nanmean(cap);

X0 = [30.0, 30.0, 13.5, 33.5, 7.0];
low_bd = [0.0, 0.0, 0.0, 20.0, 2.0];

num_vars = 5;
fit_fn = @(X) Ito_fitness(X, Ito_amp, tau_to);
opts = optimoptions('ga', 'PlotFcn',@gaplotbestf, 'PopulationSize',40, 'MaxTime',18000);
[param,fval] = ga(fit_fn,num_vars,[],[],[],[],low_bd,[],[],opts);
