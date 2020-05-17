clc
close all
clear variables


%% Main
% parameters for voltage clamp
holding_p = -140; %mV
holding_t = 10; %msec
P1s = -130:10:50; %mV
P1_t = 80; % msec
P2 = -20; % mV
P2_t = 100; % msec

% run the model
t_container = cell(1,length(P1s));
S_container = cell(1,length(P1s));
A_container = cell(1,length(P1s));
for i=1:length(P1s)
    [t,S,A,C] = Rasmusson(holding_p,holding_t,P1s(i),P1_t,P2,P2_t);
    t_container{i} = t;
    S_container{i} = S;
    A_container{i} = A;
end

% plots
figure(1);
for i=1:length(P1s)
    hold on
    subplot(2,2,1);
    plot(t_container{i},A_container{i}(:,72));
    axis tight;
    xlabel('Time (msec)');
    ylabel('V (mV)');
    title('Two-Pulse Protocol');
    hold off
    
    % A40; Fast Na+ current
    hold on
    subplot(2,2,2);
    plot(t_container{i},A_container{i}(:,58));
    axis tight
    xlabel('time (msec)');
    ylabel('(pA/pF)');
    title('Fast Na+ Current I_{Na}');
    hold off
    
    % A3; Cass
    hold on
    subplot(2,2,3);
    plot(t_container{i},S_container{i}(:,3));
    axis tight
    xlabel('Time (msec)');
    ylabel('uM');
    title('[Ca^{2+}]_{ss}');
    hold off
    
    % A67; I_Kto,f
    hold on
    subplot(2,2,4);
    plot(t_container{i},A_container{i}(:,61));
    axis tight
    xlabel('Time (msec)');
    ylabel('pA/pF');
    title('I_{Kto,f}');
    hold off
end

% [t,S,A,C] = Ito(holding_p,holding_t,P1,P1_t,P2,P2_t,[30,30,13.5,33.5,33.5,33.5]);
% [t,S,A,C] = Rasmusson(holding_p,holding_t,P1,P1_t,P2,P2_t);

% visualization
% subplot(2,1,1)
% plot(t, A(:,66))
% subplot(2,1,2)
% plot(t, A(:,61))


%% transform .mat arrays to Excel files
file_names = dir('./results/*.mat');
for i=1:length(file_names)
    file_name = file_names(i);
    read_path = sprintf('./results/%s', file_name.name);
    load(read_path)
    
    [~, write_name, ~] = fileparts(file_name.name);
    write_path = sprintf('./results/%s.xlsx', write_name);
    xlswrite(write_path, rst)
end


%% compare GA-fitted models and the Rasmusson
clc
close all
clear variables

load('./results/GA_Iss_ko_10.mat')
ga_iss_ko = mean(rst, 1);
load('./results/GA_Iss_wt_10.mat')
ga_iss_wt = mean(rst, 1);
load('./results/GA_Ito_ko_10.mat')
ga_ito_ko = mean(rst, 1);
load('./results/GA_Ito_wt_10.mat')
ga_ito_wt = mean(rst, 1);
raw_trace = readtable('trace.xlsx');

holding_p = -70; %mV
holding_t = 4.5*1000; %ms
P1 = 50; %mV
P1_t = 29.5*1000; % ms
P2 = -70; % mV
P2_t = P1_t; % ms

% fit models
[t1, ~, A1, ~] = Iss(holding_p, holding_t, P1, P1_t, P2, P2_t, ga_iss_ko(1:4));
[t2, ~, A2, ~] = Iss(holding_p, holding_t, P1, P1_t, P2, P2_t, ga_iss_wt(1:4));
[t3, ~, A3, ~] = Ito(holding_p, holding_t, P1, P1_t, P2, P2_t, ga_ito_ko(1:6));
[t4, ~, A4, ~] = Ito(holding_p, holding_t, P1, P1_t, P2, P2_t, ga_ito_wt(1:6));

% plots
figure(1)
plot(raw_trace.time, raw_trace.trace)
hold on
plot(t1, A1(:,66))
plot(t2, A2(:,66))
hold off
title('I_{SS}')
xlabel('Time (sec)')
ylabel('pA/pF')
legend('Rasmusson', 'GA KO', 'GA WT')
axis tight

figure(2)
plot(raw_trace.time, raw_trace.trace)
hold on
plot(t3, A3(:,61)*257.9375)
plot(t4, A4(:,61)*207.8214)
hold off
title('I_{to}')
xlabel('Time (sec)')
ylabel('pA/pF')
legend('Rasmusson', 'GA KO', 'GA WT')
axis tight


%% compare GA-fitted models and the raw traces
clc
close all
clear variables

load('./results/GA_Iss_ko_10.mat')
ga_iss_ko = mean(rst, 1);
load('./results/GA_Iss_wt_10.mat')
ga_iss_wt = mean(rst, 1);
load('./results/GA_Ito_ko_10.mat')
ga_ito_ko = mean(rst, 1);
load('./results/GA_Ito_wt_10.mat')
ga_ito_wt = mean(rst, 1);

holding_p = -70; %mV
holding_t = 4.5*100; %ms
P1 = 50; %mV
P1_t = 29.5*100; % msec
P2 = -70; % mV
P2_t = P1_t; % msec
[t, ~, A, ~] = RasmussonUnparam(holding_p, holding_t, P1, P1_t, P2, P2_t);
[t1, ~, A1, ~] = Iss(holding_p, holding_t, P1, P1_t, P2, P2_t, ga_iss_ko(1:4));
[t2, ~, A2, ~] = Iss(holding_p, holding_t, P1, P1_t, P2, P2_t, ga_iss_wt(1:4));
[t3, ~, A3, ~] = Ito(holding_p, holding_t, P1, P1_t, P2, P2_t, ga_ito_ko(1:6));
[t4, ~, A4, ~] = Ito(holding_p, holding_t, P1, P1_t, P2, P2_t, ga_ito_wt(1:6));


%% draw raw traces
plot(trace.time, trace.KO, 'LineWidth', 2)
hold on
plot(trace.time, trace.WT, 'LineWidth', 2)
plot(Itotrace.time, Itotrace.KO, 'LineWidth', 2)
plot(Itotrace.time, Itotrace.WT, 'LineWidth', 2)
hold off
legend('KO', 'WT', 'Ito KO', 'Ito WT')


%% sampling
IKsum = A(:,61) + A(:,62) + A(:,63) + A(:,64) + A(:,65) + A(:,66) + A(:,67);
plot(t, IKsum)

sub_ktrace = downsample(ktrace, 3);
plot(sub_ktrace.time, sub_ktrace.KO)


X = [22.5000, 2.05800, 45.2000, 1200.00, 45.2000, 0.493000, 170.000];
X2 = -5:1:5;
X2 = transpose(X2);
X1 = X(1)*ones(length(X2), 1);
X3 = X(3)*ones(length(X2), 1);
X4 = X(4)*ones(length(X2), 1);
X5 = X(5)*ones(length(X2), 1);
X6 = X(6)*ones(length(X2), 1);
X7 = X(7)*ones(length(X2), 1);
newX = [X1, X2, X3, X4, X5, X6, X7];

y = zeros(length(X2), 1);
for i=1:length(X2)
    fprintf('### Iter %i \n', i)
    [~,~,A,~] = IKslow1(holding_p,holding_t,P1,P1_t,P2,P2_t,newX(i,:));
    y(i) = max(A(:,65));
end


%%
