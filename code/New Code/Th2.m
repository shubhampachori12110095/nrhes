function [Tf,mw_guess,error,Q_sg,Q_egen,H_gen]=Th2(m_perc)
% Salt information %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Assume salt cp stays nearly constant throughout changing temperatures
%
%temp of salt in
Ts_in=570;
Tw_out=550;
To=Tw_out+10;
N=0;

%% Molten salt
Ts_out=344; %Temp of salt out
md_s=(1633-278)*m_perc; %m dot salt kg/s
cp_salt= @(T) 1443+0.172*T; % T in Celsius
L=5.772; 

cp_salt_avg=integral(cp_salt,Ts_in,Ts_out)/(Ts_out-Ts_in);
Q_sg=md_s*cp_salt_avg*(Ts_in-Ts_out); %Q through the steam generator

%% Water
Tw_in=287;
md_w=224*2;
hw= @(P,T) XSteam('h_pt',P,T);
hci=hw(258.8, Tw_in); 
hco=hw(256.5, Tw_out);
mw_guess=Q_sg/1000/(hco-hci);
%
while abs(To-Tw_out)>2 & N<30
%% Dimensionless parameters
Di=7.5/1000; %hydraulic equivalent diameter
Ai=4.4/1224; %area of one bundle
G=mw_guess/Ai; %mass flux
Df=11.5/1000; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Re = @(T,G,Di) G*Di/XSteam('my_pt',258.8,T); %Reynolds number
Pr= @(T) XSteam('pr_pt',258.8,T); % Prandtl at the constant pressure
Pr_avg= @(T) Pr_bar(T);
Nu= @(T,G,Di) 0.0061*Re(T,G,Di)^.904*Pr_bar(T)^0.684*(XSteam('rho_pT', 258.8, T+20)/XSteam('rho_pT', 258.8, T))^.564;
HTC= @(T,G,Di) Nu(T,G,Di)*XSteam('tc_pt',258.8,T)/Di;
%%
To=Tw_in+Q_sg/(Df*42*pi*L*.4915)/HTC_bar(Tw_out,G,Di)
    if To>Tw_out
  
            mw_guess=mw_guess+.7;
    else
         if abs(To-Tw_out) > 9
            mw_guess=mw_guess-5;
        else
            mw_guess=mw_guess-1;
         end
    end
mw_guess
N=N+1
end
Tf=To;
error=abs(Q_sg/1000-mw_guess*(hw(258,Tf)-hci))/(Q_sg/1000);
%% Dummy Energy Output
hh1=XSteam('s_pT',255,550);
hc1=XSteam('s_pT',39.3,343);
hh2=XSteam('h_pT',38.4,550);
hc2=XSteam('h_pT',.05,32);

m1=224*2;
m2=197*2;
Q_egen=((hh1-hc1)*m1+(hh2-hc2)*m2)/1000; % in MWth
eff=515/Q_egen;
effC=1-(32+273)/(550+273);
effrat=eff/effC;
%% Energy output
rat=197/224;
effC2=1-(32+273)/(Tw_out+273);
hh1=XSteam('s_pT',255,Tw_out);
hc1=XSteam('s_pT',39.3,343);
hh2=XSteam('h_pT',38.4,Tw_out);
hc2=XSteam('h_pT',.05,32);

m1=mw_guess*2;
m2=m1*rat;
Q_egen=((hh1-hc1)*m1+(hh2-hc2)*m2)/1000*eff; 
Q_sg=Q_sg/10^6/md_s*(md_s+278*m_perc);

%%
H_gen=((cp_salt_avg*1633*(1-m_perc)*(Ts_in-Ts_out))/10^6)/(499.5/2); %kg/s

end