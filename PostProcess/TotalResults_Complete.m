close all
clear all
clc

%% Load data
nbcr_all=zeros(60,3);
nbcr_PF_all=zeros(60,3);
Y_Dist_min=zeros(60,6);
BR_stats=zeros(60,5);
H_stats=zeros(60,5);
%load names
base='E:\MatlabFiles\MatFiles_newruns\Results/Outcomes_';
loadnames1=[base '6A.mat';base '6B.mat';base '6C.mat';base '6D.mat';base '6E.mat';base '6F.mat';base '6G.mat';base '6H.mat';base '6I.mat';base '6J.mat';base '6K.mat';base '6L.mat';base '8A.mat';base '8B.mat';base '8C.mat';base '8D.mat';base '8E.mat';base '8F.mat';base '8G.mat';base '8H.mat';base '8I.mat';base '8J.mat';base '8K.mat';base '8L.mat'];
loadnames2=[base '10A.mat';base '10B.mat';base '10C.mat';base '10D.mat';base '10E.mat';base '10F.mat';base '10G.mat';base '10H.mat';base '10I.mat';base '10J.mat';base '10K.mat';base '10L.mat';base '12A.mat';base '12B.mat';base '12C.mat';base '12D.mat';base '12E.mat';base '12F.mat';base '12G.mat';base '12H.mat';base '12I.mat';base '12J.mat';base '12K.mat';base '12L.mat';base '14A.mat';base '14B.mat';base '14C.mat';base '14D.mat';base '14E.mat';base '14F.mat';base '14G.mat';base '14H.mat';base '14I.mat';base '14J.mat';base '14K.mat';base '14L.mat'];

for i=1:60
    if i<25
       load (loadnames1(i,:))
    else
       load (loadnames2((i-24),:))
    end
    nbcr_all(i,:)=nbcrs;
    %nbcr_PF_all(i,:)=nbcrs_PF;
    Y_Dist_min(i,:)=Y_DistsMin;
    BR_stats(i,:)=Stats(1:5);
    
    H_stats(i,:)=Stats(6:10);
    
end

%% bar plot blade hub
BrootDia=5.04;
HrootDia=5.08;
D_crit=BrootDia/2+HrootDia/2;

X = categorical({'6A','6B','6C','6D','6E','6F','6G','6H','6I','6J','6K','6L','8A','8B','8C','8D','8E','8F','8G','8H','8I','8J','8K','8L','10A','10B','10C','10D','10E','10F','10G','10H','10I','10J','10K','10L','12A','12B','12C','12D','12E','12F','12G','12H','12I','12J','12K','12L','14A','14B','14C','14D','14E','14F','14G','14H','14I','14J','14K','14L'});
X = reordercats(X,{'6A','6B','6C','6D','6E','6F','6G','6H','6I','6J','6K','6L','8A','8B','8C','8D','8E','8F','8G','8H','8I','8J','8K','8L','10A','10B','10C','10D','10E','10F','10G','10H','10I','10J','10K','10L','12A','12B','12C','12D','12E','12F','12G','12H','12I','12J','12K','12L','14A','14B','14C','14D','14E','14F','14G','14H','14I','14J','14K','14L'});
f1=figure('Renderer', 'painters', 'Position', [10 10 900 600]);
bar(X,nbcr_all)
grid on
yline(D_crit,'--r')
legend('\eta_{b}','\eta_{h}','\eta_{r}','R_{crit}')
xlabel({'Environmental conditions (EC): A,B,C: mean, D,E,F: -35% H_s, G,H,I: +35% H_s, J,K,L: +35% T_p';  'A,D,G,J: \beta_{wind}: 0° B,E,H,K: \beta_{wind}: +90° C,F,I,L: \beta_{wind}: -140°'})
ylabel('Critical motion radius \eta_{cr} [m]')
title('Outcrossing rates of blade root and hub, critical outcrossing rate one in three minutes: \nu_{cr}=5.5*10^{-3} Hz')
exportgraphics(f1,'Allncrs.pdf')
%% bar plot pin flange
% PinDia=0.028;
% FlDia=0.03;
% D_crit_PF=0.004;
% 
% figure()
% bar(X,nbcr_PF_all)
% grid on
% yline(D_crit_PF,'--r')
% legend('\eta_{p}','\eta_{p}','\eta_{r}','R_{crit}')
% xlabel('Environmental conditions (EC)')
% ylabel('Critical motion radius \eta_{cr} [m]')


%% YDist check
YDist_check=zeros(1,60);
for b=1:60
index = find(Y_Dist_min(b,:)<0.1); %set 0.1m as minimum limit
YDist_check(b) = length(index);
end

figure()
 bar(X,YDist_check)
 grid on
 xlabel({'Environmental conditions (EC): A,B,C: mean, D,E,F: -35% H_s, G,H,I: +35% H_s, J,K,L: +35% T_p';  'A,D,G,J: \beta_{wind}: 0° B,E,H,K: \beta_{wind}: +90° C,F,I,L: \beta_{wind}: -140°'})
 ylabel('No of y exceedance out of six simulation')

 