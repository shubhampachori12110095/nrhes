function H=h_bar(Ti,To)
Temp=Ti:1:To;
for i = 1:numel(Temp)
    X(i)=XSteam('h_pT',258.8,Temp(i));
end
H= trapz(Temp,X)/(To-Ti);
end