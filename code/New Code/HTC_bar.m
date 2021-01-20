function HTC=HTC_bar(T,G,Di)
Re = @(T) G*Di/XSteam('my_pt',258.8,T); %Reynolds number
Pr= @(T) XSteam('pr_pt',258.8,T); % Prandtl at the constant pressure
Pr_avg= @(T) Pr_bar(T);
Nu= @(T) 0.0061*Re(T)^.904*Pr_bar(T)^0.684*(XSteam('rho_pT', 258.8, T+40)/XSteam('rho_pT', 258.8, T))^.564;
HTC= @(T) Nu(T)*XSteam('tc_pt',258.8,T)/Di;
Temp=287:1:T;

for i= 1:numel(Temp)
    X(i)=HTC(Temp(i)); 
end
HTC = trapz(Temp,X)/(T-287);
end