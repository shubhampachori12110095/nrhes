close all
N=50;
x=linspace(10,100,N+1)/100;
E=[];
TCo=[];
m_dot=[];
Pr=[];
Tsat=[];
THi=[];
for i=1:N+1
    [E_gen, TCO, mdot,P,Th]=THERMAL(x(i));
    Pr=[Pr P];
    E=[E E_gen];
    TCo=[TCo TCO];
    THi=[THi Th];
    m_dot=[m_dot mdot];
    Tsat=[Tsat XSteam('Tsat_p',P)];
end

figure('Name','energy')
plot(x,E)
xlabel('Fraction of total Q put into steam generation')
title('Energy fraction versus Energy generation')
ylabel('Net eletricity output')
%
figure('Name','T Out')
plot(x,TCo)
title('Energy fraction versus outlet steam temperature')
xlabel('Fraction of total Q put into steam generation')
ylabel('Steam Exit Temperature')
%
figure('Name','Mass Flow')
plot(x,m_dot)
title('Energy fraction versus mass flow rate')
xlabel('Fraction of total Q put into steam generation')
ylabel('Mass Flow Rate')
%
figure('Name','Saturation Temp')
plot(x,Tsat,x,TCo,x,THi)
legend('Saturation Temp','Steam Temperature out','Molten salt temp in','location','northwest')
ylabel('Temperature')
xlabel('Fraction of total Q put into steam generation')
