close all
clear all
clc

%% Loadnames
allcases1=['6A';'6B';'6C';'6D';'6E';'6F';'6G';'6H';'6I';'8A';'8B';'8C';'8D';'8E';'8F';'8G';'8H';'8I'];
allcases2=['10A';'10B';'10C';'10D';'10E';'10F';'10G';'10H';'10I';'12A';'12B';'12C';'12D';'12E';'12F';'14A';'14B';'14C';'14D';'14E';'14F'];

BRoutcrS=zeros(3,2000);
cfreq_BRxS=zeros(3,2000);
nbcr_BRxS=zeros(3,1);
yBRxS=zeros(3,1);

for w=1:3
%     if w==1
%         x='C';
%     elseif w==2
%         x='A';
%     else
%         x='B';
%     end
    x=num2str(w); %for only one case
    % for b=1:39 %if all cases should be processed
    % if b<19
    %     x=allcases1(b,:);
    % else
    %     x=allcases2((b-18),:);
    % end
    
    for j=1
        BladeHubLoad=['E:\MatlabFiles\MatFiles_newruns/BladeHubMotions_Tug' x '.mat'];
        SemiMotions=['E:\MatlabFiles\MatFiles_newruns/SemiMotions_Tug' x '.mat'];
        PinFlange=['E:\MatlabFiles\MatFiles_newruns/PinFlangeMotions_Tug' x '.mat'];
        CraneMotions=['E:\MatlabFiles\MatFiles_newruns/CraneMotions_Tug' x '.mat'];
    end
    %% BladeRoot & Hub
    
    for j=1
        for i=1
            phi=deg2rad(-30);
            rXl=88*cos(phi)-(-23.31)*sin(phi);
            rYl=88*sin(phi)+(-23.31)*cos(phi);
            
            hXl=88.5*cos(phi)-(-24.18)*sin(phi);
            hYl=88.5*sin(phi)+(-24.18)*cos(phi);
            BrootDia=5.04;
            HrootDia=5.08;
            D_crit=BrootDia/2+HrootDia/2;
        end
        
        load (BladeHubLoad)
        for i=1
            %rename XYZ
            L1_BR_X=BladeRootXl;
            L1_BR_Y=BladeRootYl;
            L1_BR_Z=BladeRootZ;
            L1_H_X=HubXl;
            L1_H_Y=HubYl;
            L1_H_Z=HubZ;
            L1_B_X=BladeXturn;
            L1_B_Y=BladeYturn;
            L1_B_Z=BladeZ;
            L1_B_Xr=BladeRoll;
            L1_B_Yr=BladePitch;
            L1_B_Zr=BladeYaw;
            
            %means
            L1_MeanRootX=mean(L1_BR_X);
            L1_MeanRootY=mean(L1_BR_Y);
            L1_MeanRootZ=mean(L1_BR_Z);
            L1_meandriftrX=rXl-L1_MeanRootX;
            L1_meandriftrY=rYl-L1_MeanRootY;
            L1_MeanHubX=mean(L1_H_X);
            L1_MeanHubY=mean(L1_H_Y);
            L1_MeanHubZ=mean(L1_H_Z);
            L1_meandrifthX=hXl-L1_MeanHubX;
            L1_meandrifthY=hYl-L1_MeanHubY;
            
            %motion radius
            L1_BladeRootPos=[L1_BR_X L1_BR_Z];
            L1_meanBRPos=mean(L1_BladeRootPos);
            L1_BR_Radius=zeros(length(L1_BR_X),1);
            for m=1:length(L1_BR_X)
                L1_BR_Radius(m)=norm(L1_BladeRootPos(m,:)-L1_meanBRPos);
            end
            
            BRoutcr=linspace(0,1.5,2000);
            cfreq_BR_L1=zeros(1,length(BRoutcr));
            for t=1:length(BRoutcr)
                index = find(L1_BR_Radius >= BRoutcr(t));
                count=length(index);
                cfreq_BR_L1(t)=count/1800;
            end
            
            L1_HubPos=[L1_H_X L1_H_Z];
            L1_meanHubPos=mean(L1_HubPos);
            L1_H_Radius=zeros(length(L1_H_X),1);
            for m=1:length(L1_H_X)
                L1_H_Radius(m)=norm(L1_HubPos(m,:)-L1_meanHubPos);
            end
            
            Houtcr=linspace(0,4,2000);
            cfreq_H_L1=zeros(1,length(Houtcr));
            for t=1:length(Houtcr)
                index = find(L1_H_Radius >= Houtcr(t));
                count=length(index);
                cfreq_H_L1(t)=count/1800;
            end
            
            %relative motions
            L1_Dist=zeros(length(L1_BR_X),1);
            for m=1:length(L1_BR_X)
                L1_Dist(m)=norm(L1_BladeRootPos(m,:)-L1_HubPos(m,:));
            end
            
            Doutcr=linspace(0,4,2000);
            cfreq_D_L1=zeros(1,length(Doutcr));
            for t=1:length(Doutcr)
                index = find(L1_Dist >= Doutcr(t));
                count=length(index);
                cfreq_D_L1(t)=count/1800;
            end
            
            L1_Y_Dist=L1_BR_Y-L1_H_Y;
            
            %blade and hub statistics
            Meanpos=sqrt(L1_MeanRootX^2+L1_MeanRootZ^2);
            L1_BR_MotionRadius=sqrt(L1_BR_X.^2+L1_BR_Z.^2);
            L1_H_MotionRadius=sqrt(L1_H_X.^2+L1_H_Z.^2);
            
            L1_BR_MR_mean=mean(L1_BR_MotionRadius);
            L1_BR_MR_max=max(L1_BR_MotionRadius)-L1_BR_MR_mean;
            L1_BR_MR_std=std(L1_BR_MotionRadius);
            L1_BR_MR_skew=skewness(L1_BR_MotionRadius);
            L1_BR_MR_kurt=kurtosis(L1_BR_MotionRadius);
            
            L1_H_MR_mean=mean(L1_H_MotionRadius);
            L1_H_MR_max=max(L1_H_MotionRadius)-L1_H_MR_mean;
            L1_H_MR_std=std(L1_H_MotionRadius);
            L1_H_MR_skew=skewness(L1_H_MotionRadius);
            L1_H_MR_kurt=kurtosis(L1_H_MotionRadius);
        end
        
        
        % ncrit plot
        vcr=5.55*10^(-3);
        for q=1
            cfreq_BR_all=cfreq_BR_L1;
            cfreq_BR=cfreq_BR_all;
            temp = abs(vcr - cfreq_BR); % Temporary "distances" array.
            nbcr_BRs = BRoutcr(find(temp == min(abs(vcr - cfreq_BR)))); % Find "closest" values array wrt. target value.
            nbcr_BR = nbcr_BRs(1);
            
            cfreq_H_all=cfreq_H_L1;
            cfreq_H=cfreq_H_all;
            temp = abs(vcr - cfreq_H); % Temporary "distances" array.
            nbcr_Hs = Houtcr(find(temp == min(abs(vcr - cfreq_H)))); % Find "closest" values array wrt. target value.
            nbcr_H = nbcr_Hs(1);
            
            cfreq_D_all=cfreq_D_L1;
            cfreq_D=cfreq_D_all;
            temp = abs(vcr - cfreq_D); % Temporary "distances" array.
            nbcr_Ds = Doutcr(find(temp == min(abs(vcr - cfreq_D)))); % Find "closest" values array wrt. target value.
            nbcr_D = nbcr_Ds(1);
            
            cfreq_BR_allx=cfreq_BR_L1;
            cfreq_BRx=cfreq_BR_allx;
            temp = abs(vcr - cfreq_BRx); % Temporary "distances" array.
            nbcr_BRxs = BRoutcr(find(temp == min(abs(vcr - cfreq_BRx)))); % Find "closest" values array wrt. target value.
            nbcr_BRx = nbcr_BRxs(1);
            yBRx=cfreq_BRx(find(BRoutcr==nbcr_BRx));
            BRlegx=['Blade-root \eta_{bcr}= ' num2str(nbcr_BRx) 'm'];
            
            cfreq_H_allx=cfreq_H_L1;
            cfreq_Hx=cfreq_H_allx;
            temp = abs(vcr - cfreq_Hx); % Temporary "distances" array.
            nbcr_Hxs = Houtcr(find(temp == min(abs(vcr - cfreq_Hx)))); % Find "closest" values array wrt. target value.
            nbcr_Hx = nbcr_Hxs(1);
            yHx=cfreq_Hx(find(Houtcr==nbcr_Hx));
            Hlegx=['Hub \eta_{hcr}= ' num2str(nbcr_Hx) 'm'];
            
            cfreq_D_allx=cfreq_D_L1;
            cfreq_Dx=cfreq_D_allx;
            temp = abs(vcr - cfreq_Dx); % Temporary "distances" array.
            nbcr_Dxs = Doutcr(find(temp == min(abs(vcr - cfreq_Dx)))); % Find "closest" values array wrt. target value.
            nbcr_Dx = nbcr_Dxs(1);
            yDx=cfreq_Dx(find(Doutcr==nbcr_Dx));
            Dlegx=['Relative motion \eta_{rcr}= ' num2str(nbcr_Dx) 'm'];
            
            nbcrs = [nbcr_BR,nbcr_H,nbcr_D]
            
            if w == 1
                BRlegx=['\eta_{bcr}= ' num2str(nbcr_BRx) 'm'];
                BRlegx1=BRlegx;
            elseif w == 2
                BRlegx=['\eta_{bcr}= ' num2str(nbcr_BRx) 'm'];
                BRlegx2=BRlegx;
            else
                BRlegx=['\eta_{bcr}= ' num2str(nbcr_BRx) 'm'];
                BRlegx3=BRlegx;
            end
        end
        
        BRoutcrS(w,:)=BRoutcr;
    cfreq_BRxS(w,:)=cfreq_BRx;
    nbcr_BRxS(w,:)=nbcr_BRx;
    yBRxS(w,:)=yBRx;
        
    end
end
f21=figure('Renderer', 'painters', 'Position', [10 10 500 500]);
cr1=plot(BRoutcrS(1,:),cfreq_BRxS(1,:),"k."); hold on
grid on
grid minor
cr2=plot(BRoutcrS(2,:),cfreq_BRxS(2,:),"b."); hold on
cr3=plot(BRoutcrS(3,:),cfreq_BRxS(3,:),"r."); hold on
pBR1=plot(nbcr_BRxS(1),yBRxS(1),'Color','k','Marker','o');
pBR2=plot(nbcr_BRxS(2),yBRxS(2),'Color','b','Marker','^');
pBR3=plot(nbcr_BRxS(3),yBRxS(3),'Color','r','Marker','square');
legend('Default tension','Tension -33%','Tension +33%',BRlegx1, BRlegx2, BRlegx3,'Location','Northwest')
xlabel('Motion radius \eta [m]')
ylabel('Barrier of the outcrossing rate \nu [Hz]')
set(gca, 'YScale', 'log')
ylim([0 10^-1])
legend show

exportgraphics(f21,'TugVari.pdf')

% %% Semi Motions
% 
% for j=1
%     sXl=93;
%     sYl=-37.77;
%     sZl=0;
%     
%     load (SemiMotions)
%     for i=1
%         %rename XYZ
%         L1_S_X=SemiXturn;
%         L1_S_Y=SemiYturn;
%         L1_S_Z=SemiZ;
%         L1_S_Xr=SemiRoll;
%         L1_S_Yr=SemiPitch;
%         L1_S_Zr=SemiYaw;
%         
%         %means
%         L1_MeanSX=mean(L1_S_X);
%         L1_MeanSY=mean(L1_S_Y);
%         L1_meandriftSX=sXl-L1_MeanSX;
%         L1_meandriftSY=sYl-L1_MeanSY;
%         L1_meandriftSZ=sZl-mean(L1_S_Z);
%         L1_MeanSXr=mean(L1_S_Xr);
%         L1_MeanSYr=mean(L1_S_Yr);
%         
%         L1_S_Zlr=zeros(1,length(L1_S_Zr));
%         for k=1:length(L1_S_Zr)
%             if L1_S_Zr(k)>0
%                 L1_S_Zlr(k)=L1_S_Zr(k)-270;
%             end
%             if L1_S_Zr(k)<0
%                 L1_S_Zlr(k)=L1_S_Zr(k)+90;
%             end
%         end
%         L1_MeanSZr=mean( L1_S_Zlr);
%     end
%     
%     
%     driftsS=[L1_meandriftSX L1_meandriftSY L1_meandriftSZ L1_MeanSXr L1_MeanSYr L1_MeanSZr];
% end
% %% Pin & Flange
% Fs = 36000 / 1800;
% cutoffFrequency = 0.5; % Set the cutoff frequency (in Hz)
% normalizedCutoff = cutoffFrequency / (Fs/2); % Normalize cutoff frequency
% 
% 
% % Design a high-pass filter
% N = 100; % Filter order (can be adjusted)
% b = fir1(N, normalizedCutoff, 'high');
% 
% 
% cutoffFrequency3 = 0.3; % Set the cutoff frequency (in Hz)
% normalizedCutoff3 = cutoffFrequency3 / (Fs/2); % Normalize cutoff frequency
% 
% 
% % Design a high-pass filter
% b3 = fir1(N, normalizedCutoff3, 'high');
% for j=1
%     pXl=88*cos(phi)-(-23.31)*sin(phi);
%     pYl=88*sin(phi)+(-23.31)*cos(phi);
%     
%     fXl=88.5*cos(phi)-(-24.18)*sin(phi);
%     fYl=88.5*sin(phi)+(-24.18)*cos(phi);
%     PinDia=0.028;
%     FlDia=0.03;
%     D_crit_PF=0.004;
%     %'BlPinXl', 'BlPinYl', 'BlPinZ', 'HubFlXl', 'HubFlYl', 'HubFlZ'
%     load (PinFlange)
%     for i=1
%         %rename XYZ
%         L1_Pin_X=BlPinXl;
%         L1_Pin_Y=BlPinYl;
%         L1_Pin_Z=BlPinZ;
%         L1_Fl_X=HubFlXl;
%         L1_Fl_Y=HubFlYl;
%         L1_Fl_Z=HubFlZ;
%         
%         %means
%         L1_MeanPinX=mean(L1_Pin_X);
%         L1_MeanPinY=mean(L1_Pin_Y);
%         L1_meandriftpX=pXl-L1_MeanPinX;
%         L1_meandriftpY=pYl-L1_MeanPinY;
%         L1_MeanFlX=mean(L1_Fl_X);
%         L1_MeanFlY=mean(L1_Fl_Y);
%         L1_meandriftFlX=fXl-L1_MeanFlX;
%         L1_meandriftFlY=fYl-L1_MeanFlY;
%         
%         %motion radius
%         L1_PinPos=[L1_Pin_X L1_Pin_Z];
%         L1_meanPinPos=mean(L1_PinPos);
%         L1_Pin_Radius=zeros(length(L1_Pin_X),1);
%         for m=1:length(L1_Pin_X)
%             L1_Pin_Radius(m)=norm(L1_PinPos(m,:)-L1_meanPinPos);
%         end
%         % Apply high-pass filter
%         L1_Pin_Radius =filtfilt(b, 1, L1_Pin_Radius);
%         %L1_Pin_Radius = highpass(L1_Pin_Radius, normalizedCutoff);
%         
%         
%         Pinoutcr=linspace(0,1.5,2000);
%         cfreq_Pin_L1=zeros(1,length(Pinoutcr));
%         for t=1:length(Pinoutcr)
%             index = find(L1_Pin_Radius >= Pinoutcr(t));
%             count=length(index);
%             cfreq_Pin_L1(t)=count/1800;
%         end
%         
%         L1_FlPos=[L1_Fl_X L1_Fl_Z];
%         L1_meanFlPos=mean(L1_FlPos);
%         L1_Fl_Radius=zeros(length(L1_Fl_X),1);
%         for m=1:length(L1_Fl_X)
%             L1_Fl_Radius(m)=norm(L1_FlPos(m,:)-L1_meanFlPos);
%         end
%         % Apply high-pass filter
%         %L1_Fl_Radius = highpass(L1_Fl_Radius, normalizedCutoff);
%         L1_Fl_Radius  =filtfilt(b, 1,  L1_Fl_Radius);
%         
%         Floutcr=linspace(0,4,2000);
%         cfreq_Fl_L1=zeros(1,length(Floutcr));
%         for t=1:length(Floutcr)
%             index = find(L1_Fl_Radius >= Floutcr(t));
%             count=length(index);
%             cfreq_Fl_L1(t)=count/1800;
%         end
%         
%         %relative motions
%         L1_Dist_PF=zeros(length(L1_Pin_X),1);
%         for m=1:length(L1_Pin_X)
%             L1_Dist_PF(m)=norm(L1_PinPos(m,:)-L1_FlPos(m,:));
%         end
%         % Apply high-pass filter
%         %L1_Dist_PF = highpass(L1_Dist_PF, normalizedCutoff);
%         L1_Dist_PF_unfiltered=L1_Dist_PF;
%         L1_Dist_PF   =filtfilt(b, 1,  L1_Dist_PF);
%         L1_Dist_PF3   =filtfilt(b3, 1, L1_Dist_PF_unfiltered);
%         
%         PFoutcr=linspace(0,4,2000);
%         cfreq_PF_L1=zeros(1,length(PFoutcr));
%         for t=1:length(PFoutcr)
%             index = find(L1_Dist_PF >= PFoutcr(t));
%             count=length(index);
%             cfreq_PF_L1(t)=count/1800;
%         end
%         
%         L1_Y_PF_Dist=L1_Pin_Y-L1_Fl_Y;
%     end
%     
% end
% 
% %% Crane
% 
% for j=1
%     
%     
%     load (CraneMotions)
%     
%     Xstd_Cr=round(std(CraneXl),4);
%     Ystd_Cr=round(std(CraneYl),4);
%     Zstd_Cr=round(std(CraneZ),4);
%     
%     CranePos=[CraneXl CraneZ];
%     CraneMeanPos=mean(CranePos);
%     Crane_Radius=zeros(length(CraneXl),1);
%     for m=1:length(L1_BR_X)
%         Crane_Radius(m)=norm(CranePos(m,:)-CraneMeanPos);
%     end
%     
%     f26=figure('Renderer', 'painters', 'Position', [10 10 600 600]);
%     subplot(3,1,1)
%     plot(timeRif,CraneXl)
%     grid on
%     xlabel('time[s]'), ylabel('Crane tip motion in x [m]'),grid on, xlim([0 1800]),
%     CraneLegx=['Std' num2str(Xstd_Cr) 'm'];
%     legend(CraneLegx)
%     subplot(3,1,2)
%     plot(timeRif,CraneYl)
%     grid on
%     xlabel('time[s]'), ylabel('Crane tip motion in y [m]'),grid on, xlim([0 1800]),
%     CraneLegy=['Std' num2str(Ystd_Cr) 'm'];
%     legend(CraneLegy)
%     subplot(3,1,3)
%     plot(timeRif,CraneZ)
%     grid on
%     xlabel('time[s]'), ylabel('Crane tip motion in z [m]'),grid on, xlim([0 1800]),
%     CraneLegz=['Std' num2str(Zstd_Cr) 'm'];
%     legend(CraneLegz)
%     ExportName=['CraneMotions',x,'.pdf'];
%     exportgraphics(f26, ExportName)
%     
% end
% 
% 
% 
% 
% 
% %% PSDs
% 
% BladeRadius_L1=sqrt(L1_BR_X.^2+L1_BR_Z.^2);
% HubRadius_L1=sqrt(L1_H_X.^2+L1_H_Z.^2);
% [fpsd_B_L1, psd_B_L1] = Power_Spectral_Density(timeRif,BladeRadius_L1);
% [fpsd_H_L1, psd_H_L1] = Power_Spectral_Density(timeRif,HubRadius_L1);
% [fpsd_D, psd_D] = Power_Spectral_Density(timeRif,L1_Dist);
% 
% 
% f27=figure('Renderer', 'painters', 'Position', [10 10 500 400]);
% 
% plot(fpsd_D,smooth(psd_D)), hold on,
% xlabel('Frequency [Hz]'), ylabel('Spectral density of motion radius [m^2/Hz]'), grid on,
% xlim([0 0.3])
% ExportName=['DistPSD',x,'.pdf'];
% exportgraphics(f27, ExportName)
% 
% 
% 
% [fpsd_C_L1, psd_C_L1] = Power_Spectral_Density(timeRif,Crane_Radius);
% 
% 
% f28=figure('Renderer', 'painters', 'Position', [10 10 500 400]);
% 
% plot(fpsd_C_L1,smooth(psd_C_L1)), hold on,
% xlabel('Frequency [Hz]'), ylabel('Spectral density of crane motion radius [m^2/Hz]'), grid on,
% xlim([0 0.3])
% ExportName=['CranePSD',x,'.pdf'];
% exportgraphics(f28, ExportName)
% 
% 
