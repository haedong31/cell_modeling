clc
clearvars
close all

%% Cell greometry parameters
Acap=1.534e-4; %Capacitive membrane area:cm^2
Vmyo=25.84e-6; %Myoplasmic volume:ul
VJSR=0.12e-6; %Juncional SR volume:ul
VNSR=2.098e-6; %Network SR volume:ul
Vss=1.485e-9; %Subspace volume:ul

%% Extracellular io concentrations
Ko=5400; %Exracellular K+ concentration:uM
Nao=140000; %Exracellular Na+ concentration:uM
Cao=1800; %Exracellular Ca+ concentration:uM

%% SR parameters
nu1=4.5; %Maximum RyR channel Ca+ permeability:ms^-1
nu2=1.74e-5; %Ca+ leak rate constant from the NSR:ms^-1
nu3=0.45; %SR Ca+-ATPase maximum pump rate:uM/ms
Km_up=0.5; %Half-saturation constant for SR Ca+-ATPase pump:uM
tautr=20.0; %Time constant for transfer from NSR to JSR:ms
tauxfer=8.0; %Time constant for transfer from subspace to myoplasm:ms
ka1=0.006075; %RyR Pc1-Po1 rate constant:uM^-4/ms
ka2=0.07125; %RyR Po1-Pc1 rate constant:ms^-1
kb1=0.00405; %RyR Po1-Po2 rate constant:uM^-3/ms
kb2=0.965; %RyR Po2-Po1 rate constant:ms^-1
kc1=0.009; %RyR Po1-Pc2 rate constant:ms^-1
kc2=0.0008; %RyR Pc2-Po1 rate constant:ms^-1
n=4; %RyR Ca+ cooperativity parameter Pc1-Po1
m=3; %RyR Ca+ cooperativity parameter Po1-Po2

%% L-type Ca+ channel parameters
GCaL=0.1729; %Specific maximum conductivity for L-type Ca+ channel:mS/uF
ECa_L=63.0; %Reversal potential for L-type Ca+ channel:mV
Kpc_max=0.23324; %Maximum time constant for Ca+-induced inactivation:ms^-1
Kpc_half=20.0; %Half-saturation constant for Ca+-induced inactivation:uM
Kpcb=0.0005; %Voltage-insensitive rate constant for inactivation:ms^-1
ICaL_max=7.0; %normalization constant for L-type Ca+ current:pA/pF

%% Buffering parameters
LTRPN_tot=70.0; %Total myoplasmic troponin low-affinity site concentration:uM
HTRPN_tot=140.0; %Total myoplasmic troponin high-affinity site concentration:uM
khtrpn1=0.00237; %Ca+ on rate constant for troponin high-affinity sites:uM^-1/ms
khtrpn2=3.2e-5; %Ca+ off rate constant for troponin high-affinity sites:ms^-1
kltrpn1=0.0327; %Ca+ on rate constant for troponin low-affinity sites:uM^-1/ms
kltrpn2=0.0196; %Ca+ off rate constant for troponin low-affinity sites:ms^-1
CMDN_tot=50.0; %Total myoplasmic calmodulin concentration:uM
CSQN_tot=15000.0; %Total junctional SR calsequestrin concentration:uM
Km_CMDN=0.238; %Ca+ half-saturaion constant for calmodulin:uM
Km_CSQN=800.0; %Ca+ half-saturaion constant for calsequestrin:uM

%% Membrane current parameters
Cm=1.0; %Specific membrane capacitance:uF/cm^2
F=96.5; %Faraday constant:C/mmol
T=298; %Absolute temperature:K
R=8.314; %Ideal gas constant:J*mol^-1*K^-1
kNaCa=292.8; %Scaling factor of Na+/Ca+ exchange:pA/pF
Km_Na=87500; %Na+ half-saturation constant for Na+/Ca+ exchange:uM
Km_Ca=1380; %Ca+ half-saturation constant for Na+/Ca+ exchange:uM
ksat=0.1; %Na+/Ca+ exchange saaturation factor at very negative potentials
yita=0.35; %Contals voltage dependence of Na+/Ca+ exchange
INaK_max=0.88; %Maximum Na+/K+ exchange current:pA/pF
Km_Nai=21000; %Na+ half-saturation constant for Na+/K+ exchange currant:uM
Km_Ko=1500; %K+ half-saturation constant for Na+/K+ exchange currant:uM
Ip_Ca_max=1.0; %Maximun Ca+ pump current:pA/pF
Km_p_Ca=0.5; %Ca+ half-saturation constant for Ca+pump current:uM
GCab=0.000367; %Maximun background Ca+ current conductance:mS/uF
GNa=13.0; %Maximun fast Na+ current conductance:mS/uF
GNab=0.0026; %Maximun background Na+ current conductance:mS/uF
GKs=0.00575; %Maximum slow delayed-rectifier K+ current conductance:mS/uF

GKtof=0.4067; %Maximum transient outward K+ current conductance(apex):mS/uF
GKto_f=0.0798; %Maximum transient outward K+ current conductance(septum):mS/uF

GKtos=0.0; %Maximum transient outward K+ current conductance(apex):mS/uF
GKto_s=0.0629; %Maximum transient outward K+ current conductance(septum):mS/uF

GKur=0.160; %Maximum ultrarapidly delayed-rectifier K+ current conductance(apex):mS/uF
GK_ur=0.0975; %Maximum ultrarapidly delayed-rectifier K+ current conductance(septum):mS/uF

GKss=0.050; %Maximum noninactivating steady-state K+ current conductance(apex):mS/uF
GK_ss=0.0324; %Maximum noninactivating steady-state K+ current conductance(septum):mS/uF

GKr=0.078; %Maximum rapid delayed-rectifier K+ current conductance:mS/uF
kf=0.023761; %Rate constant for rapid delayed-rectifier K+ current:ms^-1
kb=0.036778; %Rate constant for rapid delayed-rectifier K+ current:ms^-1
GCl_Ca=10.0; %Maximum Ca+-activated Cl- current conductance:mS/uF
Km_Cl=10.0; %Half-saturaon constant for Ca+-activated Cl- current:uM
ECl=-40.0; %Reversal potential for Ca+-activated Cl- current:mV

%% Initial conditions
t=0.0; %Time:ms
V=-82.4202; %Membrane potential:mV
Cai=0.115001; %Myoplasmic Ca+ concentration:uM
Cass=0.115001; %Subspace SR Ca+ concentration:uM
CaJSR=1299.50; %JSR Ca+ concentration:uM
CaNSR=1299.50; %NSR Ca+ concentration:uM
LTRPNCa=11.2684; %Concentration Ca+ bound low-affinity troponin-binding sites:uM
HTRPNCa=125.290; %Concentration Ca+ bound high-affinity troponin-binding sites:uM
O=0.930308e-18; %L-type Ca+ channel conducting state
C1=0.999876; %L-type Ca+ channel closed state
C2=0.124216e-3; %L-type Ca+ channel closed state
C3=0.578679e-8; %L-type Ca+ channel closed state
C4=0.119816e-12; %L-type Ca+ channel closed state
I1=0.497923e-18; %L-type Ca+ channel inacticated state
I2=0.345847e-13; %L-type Ca+ channel inacticated state
I3=0.185106e-13; %L-type Ca+ channel inacticated state
PC1=0.999817; %Fraction of RyR channels in sate PCl
PC2=0.167740e-3; %Fraction of RyR channels in sate PC2
PO1=0.149102e-4; %Fraction of RyR channels in sate POl
PO2=0.951726e-10; %Fraction of RyR channels in sate PO2
PRyR=0.0; %RyR modulation factor
CNa3=0.624646; %Closed state of fast Na+ channel
CNa2=0.020752; %Closed state of fast Na+ channel
CNa1=0.279132e-3; %Closed state of fast Na+ channel
ONa=0.713483e-6; %Open state of fast Na+ channel
IFNa=0.153176e-3; %Fast inactivated state of fast Na+ channel
I1Na=0.673345e-6; %Slow inactivated state 1 of fast Na+ channel
I2Na=0.155787e-8; %Slow inactivated state 2 of fast Na+ channel
ICNa2=0.0113879; %Cloesd-inactivated state of fast Na+ channel
ICNa3=0.342780; %Cloesd-inactivated state of fast Na+ channel
Nai=14237.1; %Myoplasmic Na+ concentration:uM
Ki=143720; %Myoplasmic K+ concentration:uM
ato_f=0.265563e-2; %Gating variable for transient outward K+ current
ito_f=0.999977; %Gating variable for transient outward K+ current
nKs=0.262753e-3; %Gating variable for slow delayed-rectifier K+ current
ato_s=0.417069e-3; %Gating variable for transient outward K+ current
ito_s=0.998543; %Gating variable for transient outward K+ current
aur=0.417069e-3; %Gating variable for ultrarapidly activating delayed-rectifier K+ current
iur=0.998543; %Gating variable for ultrarapidly activating delayed-rectifier K+ current
aKss=0.417069e-3;  %Gating variable for noninactivating steady-state K+ current
iKss=1.0;  %Gating variable for noninactivating steady-state K+ current
CK0=0.998159; %mERG channel closed state
CK1=0.992513e-3; %mERG channel closed state
CK2=0.641229e-3; %mERG channel closed state
OK=0.175298e-3; %mERG channel open state
IK=0.319129e-4; %mERG channel inactivated state

%% stimulation current
SimT=2000;                    % simulation time: ms

% externals
time=0:0.01:SimT;           % sampling time set to 1 ms
I_ext=zeros(size(time));
I_ext=[time', I_ext'];
I_ext(10:11,2)=-80;    % external current: uA

%% import calibrated parameters
load('Ito_WT.mat')
to_param_wt = best_chroms;

[~, best_amps_idx] = min(best_amps);
[~, best_tau_idx] = min(best_taus);
if best_amps_idx == best_tau_idx
    best_toWt_idx = best_amps_idx;
else
    [~, best_toWt_idx] = min(best_amps+best_taus);
end

% load model fitting results - Ito KO
load('Ito_KO.mat')
to_param_ko = best_chroms;

[~, best_amps_idx] = min(best_amps);
[~, best_tau_idx] = min(best_taus);
if best_amps_idx == best_tau_idx
    best_toKo_idx = best_amps_idx;
else
    [~, best_toKo_idx] = min(best_amps+best_taus);
end

% load model fitting results - IKslow WT
load('IKslow_WT.mat')
kslow_param_wt = best_chroms;

[~, best_amps_idx] = min(best_amps);
[~, best_tau_idx] = min(best_taus);
if best_amps_idx == best_tau_idx
    best_KslowWt_idx = best_amps_idx;
else
    [~, best_KslowWt_idx] = min(best_amps+best_taus);
end

% load model fitting results - IKslow KO
load('IKslow_KO.mat')
kslow_param_ko = best_chroms;

[~, best_amps_idx] = min(best_amps);
[~, best_tau_idx] = min(best_taus);
if best_amps_idx == best_tau_idx
    best_KslowKo_idx = best_amps_idx;
else
    [~, best_KslowKo_idx] = min(best_amps+best_taus);
end


%% WT
pktof = to_param_wt(best_toWt_idx, :);
GKtof = pktof(6);
pkslow = kslow_param_wt(best_KslowWt_idx, :);
GKur = pkslow(6);

%% Mgat1KO
pktof = to_param_ko(best_toKo_idx, :);
GKtof = pktof(6);
pkslow_fit = kslow_param_ko(18, :);

pkslow(1) = pkslow_fit(1);
pkslow(2) = pkslow_fit(2);
pkslow(3) = pkslow_fit(3);
pkslow(4) = pkslow_fit(4);
pkslow(5) = pkslow_fit(5);
Gkur = pkslow_fit(6);

% 
% pktof = zeros(6,1);
% pktof(1) = 30;
% pktof(2) = 30;
% pktof(3) = 13.5;
% pktof(4) = 33.5;
% pktof(5) = 7.0;
% pktof(6) = 0.4067;
% GKtof = pktof(6);
% 
% pkslow = zeros(6,1);
% pkslow(1) = -60;
% pkslow(2) = 7.7;
% pkslow(3) = 45.2;
% pkslow(4) = 5.7;
% pkslow(5) = 1200;
% pkslow(6) = 0.160;
% GKur = pkslow(6);
