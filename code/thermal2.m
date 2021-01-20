% Salt information %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Assume salt cp stays nearly constant throughout changing temperatures
%
Ts_in=570; %temp of salt in
Ts_out=344; %Temp of salt out
md_s=1633-278; %m dot salt kg/s

%% Molten salt
cp_salt= @(T) 1443+0.172*T; % T in Celsius
L=5.772; 

% n_bun=12; % number of bundles
% area_tot=4.4/1224*n_bun;
cp_salt_avg=integral(cp_salt,Ts_in,Ts_out)/(Ts_out-Ts_in);
Q_sg=md_s*cp_salt_avg*(Ts_in-Ts_out); %Q through the steam generator
%% Water
Tw_in=287;
Tw_out=550;
md_w=224;
hw= @(P,T) XSteam('h_pt',P,T);
hci=hw(258.8, 287); 

%% Dimensionless parameters
Di=7.5/1000; %hydraulic equivalent diameter
Ai=4.4/1224; %area of one bundle
G=md_w/Ai; %mass flux
Df=11.5/1000; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Re = @(T,G,Di) G*Di/XSteam('my_pt',258.8,T); %Reynolds number
Pr= @(T) XSteam('pr_pt',258.8,T); % Prandtl at the constant pressure
Pr_avg= @(T) Pr_bar(T);
Nu= @(T,G,Di) 0.0061*Re(T,G,Di)^.904*Pr_bar(T)^0.684*(XSteam('rho_pT', 258.8, T+40)/XSteam('rho_pT', 258.8, T))^.564;
HTC= @(T,G,Di) Nu(T,G,Di)*XSteam('tc_pt',258.8,T)/Di;
%%
To=Tw_in+Q_sg/(Df*42*pi*L)/HTC_bar(Tw_out,G,Di)