frac=.1:.05:1;
for i=1:numel(frac)
    [T,mw(i),error,Q_sg(i),Q(i)]=Th2(frac(i));
end

Q=Q-15;
%
figure 
plot(frac,Q./Q_sg,'x-')
xlabel('Percentage of mass flow rate')
ylabel('Energy generation ratio')

figure 
plot(frac,mw,'x-')
xlabel('Percentage of mass flow rate')
ylabel('Mass Flow rate of water')


figure 
plot(frac,Q,'x-')
xlabel('Percentage of mass flow rate')
ylabel('Electricity Generated')

