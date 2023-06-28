% readTimeDomainResults  Reads in results from a single simulation
%
close all
clear all
clc
%%

folderpath = 'E:\LC_14G\1759-20230409110817';

splitpath=split(folderpath,"\");
splitLC=split(splitpath(2),"_");
x=char(splitLC(2));
for r=1:6

c=num2str(r); 
foldername= [folderpath '\LC_' x '_' c];
%% User-defined input

folder = foldername;
prefix = 'sima';
bladeBody= 2; 
nacelleBody = 5; 
SemiBody = 6; 

%% Read body output
for i=1
%==========================================================================
% Read the SIMO results text file to get the channel names and number
% of steps

[nchan, nts, dt, chanNames] = readSIMO_resultstext([folder '\results.txt']);
% Read the binary file
AA = read_simoresults([folder '\results.tda'],nts);
sizeAA = size(AA);
if (sizeAA(1)<nts || nts<1); disp('Unable to read SIMO results'); return; end;
% Determine which channels to read for the platform motions, wave
% elevation
[NacMotions, NacWave] = getchannelNumbers(chanNames,nacelleBody);
if (NacMotions(1)<1 || NacWave<1); disp('Unable to read SIMO results'); return; end;
time_SIMO = AA(:,2);

%discard transient
trans=600; %s
AA(1:(trans/dt),:)=[];
% summarize data in matrix
NacelleMotions = AA(:,NacMotions);
Nacellewave = AA(:,NacWave);

[semiMotions, semiWave] = getchannelNumbers(chanNames,SemiBody);
if (semiMotions(1)<1 || semiWave<1); disp('Unable to read SIMO results'); return; end;
time_SIMO = AA(:,2);
time=linspace(0,1800,18000);
% summarize data in matrix
SemiMotions = AA(:,semiMotions);
Semiwave = AA(:,semiWave);

SemiXg=SemiMotions(:,1);
SemiYg=SemiMotions(:,2);
SemiZ=SemiMotions(:,3);

phi=deg2rad(-30);
SemiXturn=SemiXg*cos(phi)-SemiYg*sin(phi);
SemiYturn=SemiXg*sin(phi)+SemiYg*cos(phi);

SemiRollG=SemiMotions(:,4);
SemiPitchG=SemiMotions(:,5);
SemiYaw=SemiMotions(:,6);

phi=deg2rad(-30);
SemiRoll=SemiRollG*cos(phi)-SemiPitchG*sin(phi);
SemiPitch=SemiRollG*sin(phi)+SemiPitchG*cos(phi);

NacXg=NacelleMotions(:,1);
NacYg=NacelleMotions(:,2);
NacZ=NacelleMotions(:,3);

phi=deg2rad(-30);
NacXturn=NacXg*cos(phi)-NacYg*sin(phi);
NacYturn=NacXg*sin(phi)+NacYg*cos(phi);

[bladeMotions, bladeWave] = getchannelNumbers(chanNames,bladeBody);
if (bladeMotions(1)<1 || bladeWave<1); disp('Unable to read SIMO results'); return; end;
BladeMotions = AA(:,bladeMotions);
Bladewave = AA(:,bladeWave);

BladeXg=BladeMotions(:,1);
BladeYg=BladeMotions(:,2);
BladeZ=BladeMotions(:,3);

phi=deg2rad(-30);
BladeXturn=BladeXg*cos(phi)-BladeYg*sin(phi);
BladeYturn=BladeXg*sin(phi)+BladeYg*cos(phi);

BladeRollG=BladeMotions(:,4);
BladePitchG=BladeMotions(:,5);
BladeYaw=BladeMotions(:,6)-30;

phi=deg2rad(-30);
BladeRoll=BladeRollG*cos(phi)-BladePitchG*sin(phi);
BladePitch=BladeRollG*sin(phi)+BladePitchG*cos(phi);

%% Read Riflex output
fname = [folder '\' prefix '_noddis.bin'];
CC = read_rifbin(fname,0,18);
sizeCC = size(CC);
Nt = sizeCC(1);  % get the number of time steps
if Nt<2; disp('Unable to read RIFLEX wind turbine results'); return; end;
dtRif=0.05;
CC(1:(trans/dtRif),:)=[];
timeRif=linspace(0,1800,36000);
BladeRootXg=CC(:,3);
BladeRootYg=CC(:,4);
BladeRootZ=CC(:,5);

phi=deg2rad(-30);
BladeRootXl=BladeRootXg*cos(phi)-BladeRootYg*sin(phi);
BladeRootYl=BladeRootXg*sin(phi)+BladeRootYg*cos(phi);

HubXg=CC(:,9);
HubYg=CC(:,10);
HubZ=CC(:,11);

HubXl=HubXg*cos(phi)-HubYg*sin(phi);
HubYl=HubXg*sin(phi)+HubYg*cos(phi);

BlPinXg=CC(:,12);
BlPinYg=CC(:,13);
BlPinZ=CC(:,14);

BlPinXl=BlPinXg*cos(phi)-BlPinYg*sin(phi);
BlPinYl=BlPinXg*sin(phi)+BlPinYg*cos(phi);

HubFlXg=CC(:,15);
HubFlYg=CC(:,16);
HubFlZ=CC(:,17);

HubFlXl=HubFlXg*cos(phi)-HubFlYg*sin(phi);
HubFlYl=HubFlXg*sin(phi)+HubFlYg*cos(phi);
end
%% save files

BladeHubMotions = ['E:\MatlabFiles\MatFiles_newruns/BladeHubMotions_' x c '.mat'];
SemiMotions = ['E:\MatlabFiles\MatFiles_newruns/SemiMotions_' x c '.mat'];
NacMotions = ['E:\MatlabFiles\MatFiles_newruns/NacMotions_' x c '.mat'];
PinFlangeMotions = ['E:\MatlabFiles\MatFiles_newruns/PinFlangeMotions_' x c '.mat'];

save (BladeHubMotions, 'BladeRootXl', 'BladeRootYl', 'BladeRootZ', 'HubXl', 'HubYl', 'HubZ','timeRif','BladeXturn','BladeYturn','BladeZ','BladeRoll','BladePitch','BladeYaw')
save (SemiMotions, 'SemiXturn', 'SemiYturn', 'SemiZ','SemiRoll','SemiPitch','SemiYaw','time')
save (NacMotions, 'NacXturn', 'NacYturn', 'NacZ')
save (PinFlangeMotions , 'BlPinXl', 'BlPinYl', 'BlPinZ', 'HubFlXl', 'HubFlYl', 'HubFlZ')

end


