function PrB=Pr_bar(T)
Temp=T:1:(T+20);
for i = 1:numel(Temp)
    X(i)=XSteam('pr_pt',258.8,Temp(i));
end
PrB= trapz(Temp,X)/20;
end