frac=.1:.05:1;
for i=1:numel(frac)
    [T,mw(i),error,Q_sg(i),Q(i)]=Th2(frac(i));
end

Q=Q-15;
%%
close all
figure 
plot(frac*100,Q./(frac*max(Q)),'x-')
xlabel('Percentage of Molten Salt')
ylabel('Energy generation ratio')

figure 
plot(Q_sg,mw,'x-')
xlabel('Transferred Thermal Heat [MW]')
ylabel('Mass Flow rate of water [kg/s]')


figure 
plot(Q_sg,Q,'x-')
xlabel('TransferredThermal Heat [MW]')
ylabel('Electricity Generated [MW]')

