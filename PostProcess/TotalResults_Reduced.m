close all
clear all
clc

%% Load data
nbcr_all=zeros(45,3);
nbcr_PF_all=zeros(45,3);
Y_Dist_min=zeros(45,6);
BR_stats=zeros(45,5);
H_stats=zeros(45,5);
%load names
base='E:\MatlabFiles\MatFiles_newruns\Results/Outcomes_';
loadnames1=[base '6A.mat';base '6B.mat';base '6C.mat';base '6G.mat';base '6H.mat';base '6I.mat';base '6J.mat';base '6K.mat';base '6L.mat';base '8A.mat';base '8B.mat';base '8C.mat';base '8G.mat';base '8H.mat';base '8I.mat';base '8J.mat';base '8K.mat';base '8L.mat'];
loadnames2=[base '10A.mat';base '10B.mat';base '10C.mat';base '10G.mat';base '10H.mat';base '10I.mat';base '10J.mat';base '10K.mat';base '10L.mat';base '12A.mat';base '12B.mat';base '12C.mat';base '12G.mat';base '12H.mat';base '12I.mat';base '12J.mat';base '12K.mat';base '12L.mat';base '14A.mat';base '14B.mat';base '14C.mat';base '14G.mat';base '14H.mat';base '14I.mat';base '14J.mat';base '14K.mat';base '14L.mat'];

for i=1:45
    if i<19
       load (loadnames1(i,:))
    else
       load (loadnames2((i-18),:))
    end
    nbcr_all(i,:)=nbcrs;
    nbcr_PF_all(i,:)=nbcrs_PF;
    Y_Dist_min(i,:)=Y_DistsMin;
    BR_stats(i,:)=Stats(1:5);
    H_stats(i,:)=Stats(6:10);
end
BR_Stats=BR_stats(1:9:end,:);
BR_Stats(:,1)=BR_Stats(:,1)-sqrt(131.7^2+64.58^2);
BR_Stats=round(BR_Stats,2);
H_Stats=H_stats(1:3:end,:);
H_Stats(:,1)=H_Stats(:,1)-sqrt(131.7^2+64.58^2);
H_Stats=round(H_Stats,2);
%% bar plot blade hub
BrootDia=5.04;
HrootDia=5.08;
D_crit=BrootDia/2+HrootDia/2;

X = categorical({'1,6A,0','1,6A,90','1,6A,-140','2,6B,0','1,6B,90','2,6B,-140','3,6C,0','3,6C,90','3,6C,-140','4,8A,0','4,8A,90','4,8A,-140','5,8B,0','5,8B,90','5,8B,-140','6,8C,0','6,8C,90','6,8C,-140','7,10A,0','7,10A,90','7,10A,-140','8,10B,0','8,10B,90','8,10B,-140','9,10C,0','9,10C,90','9,10C,-140','10,12A,0','10,12A,90','10,12A,-140','11,12B,0','11,12B,90','11,12B,-140','12,12C,0','12,12C,90','12,12C,-140','13,14A,0','13,14A,90','13,14A,-140','14,14B,0','14,14B,90','14,14B,-140','15,14C,0','15,14C,90','15,14C,-140'});
X = reordercats(X,{'1,6A,0','1,6A,90','1,6A,-140','2,6B,0','1,6B,90','2,6B,-140','3,6C,0','3,6C,90','3,6C,-140','4,8A,0','4,8A,90','4,8A,-140','5,8B,0','5,8B,90','5,8B,-140','6,8C,0','6,8C,90','6,8C,-140','7,10A,0','7,10A,90','7,10A,-140','8,10B,0','8,10B,90','8,10B,-140','9,10C,0','9,10C,90','9,10C,-140','10,12A,0','10,12A,90','10,12A,-140','11,12B,0','11,12B,90','11,12B,-140','12,12C,0','12,12C,90','12,12C,-140','13,14A,0','13,14A,90','13,14A,-140','14,14B,0','14,14B,90','14,14B,-140','15,14C,0','15,14C,90','15,14C,-140'});

f1=figure('Renderer', 'painters', 'Position', [10 10 900 600]);
bar(X,nbcr_all)
grid on
yline(D_crit,'--r')
legend('\eta_{b}','\eta_{h}','\eta_{r}','R_{sb1}')
xlabel({'Load cases (LC): A: mean, B: +35% H_s, C: +35% T_p'})
ylabel('Critical motion radius \eta_{cr} [m]')
title('Outcrossing rates of blade root and hub, critical outcrossing rate one in three minutes: \nu_{cr}=5.5*10^{-3} Hz')
exportgraphics(f1,'AllRelevantncrs.pdf')
%% bar plot pin flange
PinDia=0.0364;
FlDia=0.042;
D_crit_PF=0.004;

figure()
bar(X,nbcr_PF_all)
grid on
yline(D_crit_PF,'--r')
legend('\eta_{p}','\eta_{p}','\eta_{r}','R_{sb2}')
xlabel('Environmental conditions (EC)')
ylabel('Critical motion radius \eta_{cr} [m]')


%% YDist check
YDist_check=zeros(1,45);
for b=1:45
index = find(Y_Dist_min(b,:)<0.1); %set 0.1m as minimum limit
YDist_check(b) = length(index);
end
yl=[1 2 3 4 5 6];
f2=figure('Renderer', 'painters', 'Position', [10 10 900 600]);
 bar(X,YDist_check)
 grid on
xlabel({'Load cases, Wind speed [m/s], Case, Wind angle'})
 ylabel('No. of y-limit exceedance')
 yticks(yl) 
exportgraphics(f2,'YDistCheck.pdf')
 

%% Ncrs
NbUw=[nbcr_all(1,1) nbcr_all(10,1) nbcr_all(19,1) nbcr_all(28,1) nbcr_all(37,1)];
NhUw=[nbcr_all(1,2) nbcr_all(10,2) nbcr_all(19,2) nbcr_all(28,2) nbcr_all(37,2)];
NrUw=[nbcr_all(1,3) nbcr_all(10,3) nbcr_all(19,3) nbcr_all(28,3) nbcr_all(37,3)];

UwX=[6 8 10 12 14];
f3=figure('Renderer', 'painters', 'Position', [10 10 600 400]);
plot(UwX,NbUw,UwX,NhUw,UwX,NrUw), 
xlabel('U_w mean wind speed [m/s]'), grid on,
ylabel('Critical motion radius \eta [m]'),
legend('\eta_{bcr}','\eta_{hcr}','\eta_{rcr}')
xticks(UwX)  % Set the x-axis ticks to only display [6 8 10 12 14]
exportgraphics(f3,'UwPlot.pdf')
%%
UwX=[6 8 10 12 14];
maxis=[0.06 0.08 0.13 0.18 0.28];
stds=[0.03 0.03 0.05 0.07 0.12];

figure('Renderer', 'painters', 'Position', [10 10 600 400]);
plot(UwX,maxis,UwX,stds), 
xlabel('U_w mean wind speed [m/s]'), grid on,
ylabel('Value [m]'),
legend('max','std')
xticks(UwX)  % Set the x-axis ticks to only display [6 8 10 12 14]


%% AlignmentReduction
% Get the default values
default_values = nbcr_all(1:3:end, 3);

% Get the values for rows (2, 5, 8, 11, ...)
angle1_values = nbcr_all(2:3:end, 3);

% Get the values for rows (3, 6, 9, 12, ...)
angle2_values = nbcr_all(3:3:end, 3);

% Calculate the increase or decrease in relation to the default values
angle1_ratio = (default_values-angle1_values) ./ default_values;
angle2_ratio = (default_values-angle2_values) ./ default_values;

ratios=[-angle1_ratio -angle2_ratio]*100;

lcs=1:1:15;
f4=figure('Renderer', 'painters', 'Position', [10 10 900 600]);
bar(lcs,ratios), hold on
ylabel('Percentage change of $\eta_{rcr}$ [\%]', 'Interpreter', 'latex')
xlabel('Load Case (LC)')
grid on
legend('\beta_{wind}=90 deg','\beta_{wind}=-140 deg')
exportgraphics(f4,'RatioAngle.pdf')