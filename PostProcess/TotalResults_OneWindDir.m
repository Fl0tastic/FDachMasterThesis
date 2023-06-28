close all
clear all
clc

%% Load data
nbcr_all=zeros(15,3);
nbcr_PF_all=zeros(15,3);
Y_Dist_min=zeros(15,6);
BR_stats=zeros(15,5);
H_stats=zeros(15,5);
%load names
base='E:\MatlabFiles\MatFiles_newruns\Results/Outcomes_';
loadnames1=[base '6A.mat';base '6G.mat';base '6J.mat';base '8A.mat';base '8G.mat';base '8J.mat'];
loadnames2=[base '10A.mat';base '10G.mat';base '10J.mat';base '12A.mat';base '12G.mat';base '12J.mat';base '14A.mat';base '14G.mat';base '14J.mat'];

for i=1:15
    if i<7
       load (loadnames1(i,:))
    else
       load (loadnames2((i-6),:))
    end
    nbcr_all(i,:)=nbcrs;
    nbcr_PF_all(i,:)=nbcrs_PF;
    Y_Dist_min(i,:)=Y_DistsMin;
    BR_stats(i,:)=Stats(1:5);
    H_stats(i,:)=Stats(6:10);
end
%% bar plot blade hub
BrootDia=5.04;
HrootDia=5.08;
D_crit=BrootDia/2+HrootDia/2;

X = categorical({'1,6A','2,6B','3,6C','4,8A','5,8B','6,8C','7,10A','8,10B','9,10C','10,12A','11,12B','12,12C','13,14A','14,14B','15,14C'});
X = reordercats(X,{'1,6A','2,6B','3,6C','4,8A','5,8B','6,8C','7,10A','8,10B','9,10C','10,12A','11,12B','12,12C','13,14A','14,14B','15,14C'});
f1=figure('Renderer', 'painters', 'Position', [10 10 900 600]);
bar(X,nbcr_all)
grid on
yline(D_crit,'--r')
legend('\eta_{b}','\eta_{h}','\eta_{r}','R_{sb1}')
xlabel({'Load cases, Wind speed [m/s], Case A: mean, B: +35% H_s, C: +35% T_p'})
ylabel('Critical motion radius \eta_{cr} [m]')
%title('Outcrossing rates of blade root and hub, critical outcrossing rate one in three minutes: \nu_{cr}=5.5*10^{-3} Hz')
exportgraphics(f1,'OneDirncrs.pdf')
%% bar plot pin flange
PinDia=0.0364;
FlDia=0.045;
D_crit_PF=0.004;

f2=figure('Renderer', 'painters', 'Position', [10 10 900 600]);
bar(X,nbcr_PF_all)
grid on
yline(D_crit_PF,'--r')
legend('\eta_{pcr}','\eta_{fcr}','\eta_{rcr2}','R_{sb2}')
xlabel({'Load cases, Wind speed [m/s], Case A: mean, B: +35% H_s, C: +35% T_p'})
ylabel('Critical motion radius \eta_{cr} [m]')
exportgraphics(f2,'PFOneDirNcrs03Hz.pdf')
%% YDist check
YDist_check=zeros(1,15);
for b=1:15
index = find(Y_Dist_min(b,:)<0.1); %set 0.1m as minimum limit
YDist_check(b) = length(index);
end

figure()
 bar(X,YDist_check)
 grid on
 xlabel({'Load cases (LC): A: mean, B: +35% H_s, C: +35% T_p'})
 ylabel('No of y exceedance out of six simulation')

 