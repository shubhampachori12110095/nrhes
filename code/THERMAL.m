function [E_gen, TCo, m_dot,Psteam_out,THi]=THERMAL(frac)
% Using the values given for mass flow rate and pressure and using XSteam,
% the turbine efficiencies that provide the necessary energy production
% rate is roughly 40%.
%
%%% Some things to note
% Pressure drops 260->248 so let's assume that pressure always drops
% [(260-248)/260]*100% in steam generator
%
% Turbine efficiency at highest power will be considered to be ~40%
%
% Reheat exit temeperature is the same as stem gen exit temp
%
% Flow rate decreases from  225->162 from main to reheat. Let us assume
% that this flow rate decrease is constant or that the flow rate always
% drops [(225-162)/225]*100% between main and reheat
%
% Pressure and flow rate is provided by the pump
%
% Pressure drops through components is negligible
%
% LP turbine exit temp and pressure are always 32C and .05bar
%
% HP turbine exit temperature is 343C and entropy increase is determined by
% the current system or [(6.1396-6.5662)/6.1396]*100%

% according to bernoulli's assuming no height difference, the change in
% pressure will cause a change in the square of the velocity. Mass flow
% rate is directly proportional to the velocity (m_dot=rho*A*v. We assume
% that A stays constant and rho stays constant). This means that increasing
% the pressure by 2 would increase the velocity and thus mass flow rate by
% the square root of 2. We say the following: m_dot/P^2=m_dot0/P0^2 or
% m_dot=m_dot0*P^2/P0^2

TBeff=0.398285;
P0=260; %pressure right after pump
m_dot_t=1414; %tertiary flow rate kg/s
m_dot0=225;
m_dot_r0=m_dot0*(1-(225-162)/225);
Qin0=(m_dot0*(XSteam('h_pt',248,538)-XSteam('h_pt',260,288))+m_dot_r0*(XSteam('h_pt',38,538)-XSteam('h_pt',39,343)))/1000; %MW
Qin=Qin0*frac; % percentage of highest Q
Q_Hyd=Qin0-Qin;
%
rat=(m_dot_r0*(XSteam('h_pt',38,538)-XSteam('h_pt',39,343)))/1000/Qin0;
%
cp_t=(Qin0)/m_dot_t/(598-344); %tertriary heat xfer coeff
Tsalt_in=Qin/m_dot_t/cp_t+344;
E_gen=0; %place holder variable
error=.01;
%%% Since we set the mass flow rate and the pressure the same way, we will
% guess to solve for the proper mass flow rate that will give us the proper
% energy generation
%
%% First we are going to solve for the steam generator exit temperature
THi=Tsalt_in;
THo=344;
TCi=288;
TCo=288; %place holder variable
UA= Qin0*(1-rat)/(((344-288)-(598-538))/log((344-288)/(598-538)));
while Qin/UA<((THo-TCi)-(THi-TCo))/log((THo-TCi)/(THi-TCo))
    TCo=TCo+.001;
    if isnan(((THo-TCi)-(THi-TCo))/log((THo-TCi)/(THi-TCo))) & Qin==0
        TCo=TCo+.0001;
        break
    end
end
if Qin==0
else
TCo=TCo-.0001;
end
%
%%% We can now say that the inlet temperature of the HP turbine is TCo and
% the inlet temperature of the LP turbine is also TCo from our assumptions.
% Now to the pressure/mass_flow_rate is determined by the Q transfer we
% need which we set.
%% Pressure and Mass flow rate guessing
% Q=(h(T_steam_out,P)-h(T_steam_in,P))*m_dot+m_dot_r*(h(T_steam_out_r,P)-h(T_steam_in_r,P))
% where r means reheat. 
Psteam_in=3; %placeholder Variable
Psteam_out_HP=3; %placeholder Variable
Psteam_out=Psteam_in*(1-(260-248)/260); %placeholder Variable
m_dot=m_dot0*Psteam_in^2/P0^2;
m_dot_r=(1-(225-162)/225)*m_dot;
delH1=XSteam('h_pt',Psteam_in,TCo)-XSteam('h_pt',Psteam_out,TCi);
delH2=XSteam('h_pt',Psteam_out_HP,TCo)-XSteam('h_pt',Psteam_out_HP,343);
%
while Qin*10^3>m_dot*delH1+m_dot_r*delH2
    Psteam_in=Psteam_in+.1;
    m_dot=m_dot0*Psteam_in^2/P0^2;
    Psteam_out=Psteam_in*(1-(260-248)/260);
    m_dot_r=(1-(225-162)/225)*m_dot;
    while XSteam('s_pt',Psteam_out,THo)*(1-(6.1396-6.5662)/6.1396)<XSteam('s_pt',Psteam_out_HP,343)
        Psteam_out_HP=Psteam_out_HP+.01;
    end
delH1=XSteam('h_pt',Psteam_in,TCo)-XSteam('h_pt',Psteam_out,TCi);
delH2=XSteam('h_pt',Psteam_out_HP,538)-XSteam('h_pt',Psteam_out_HP,343);
end
delH3=XSteam('h_pt',Psteam_out_HP,TCo)-XSteam('h_pt',.05,32);    
E_gen=(delH2*m_dot+m_dot_r*delH3)/1000*TBeff;
    
    
    