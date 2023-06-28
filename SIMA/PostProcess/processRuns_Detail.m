close all
clear all
clc

%% Loadnames
allcases1=['6A';'6B';'6C';'6D';'6E';'6F';'6G';'6H';'6I';'8A';'8B';'8C';'8D';'8E';'8F';'8G';'8H';'8I'];
allcases2=['10A';'10B';'10C';'10D';'10E';'10F';'10G';'10H';'10I';'12A';'12B';'12C';'12D';'12E';'12F';'14A';'14B';'14C';'14D';'14E';'14F'];

x='14G'; %for only one case
% for b=1:39 %if all cases should be processed
% if b<19
%     x=allcases1(b,:);
% else
%     x=allcases2((b-18),:);
% end

for j=1
    BladeHubLoad1=['E:\MatlabFiles\MatFiles_newruns/BladeHubMotions_' x '1.mat'];
    BladeHubLoad2=['E:\MatlabFiles\MatFiles_newruns/BladeHubMotions_' x '2.mat'];
    BladeHubLoad3=['E:\MatlabFiles\MatFiles_newruns/BladeHubMotions_' x '3.mat'];
    BladeHubLoad4=['E:\MatlabFiles\MatFiles_newruns/BladeHubMotions_' x '4.mat'];
    BladeHubLoad5=['E:\MatlabFiles\MatFiles_newruns/BladeHubMotions_' x '5.mat'];
    BladeHubLoad6=['E:\MatlabFiles\MatFiles_newruns/BladeHubMotions_' x '6.mat'];
    SemiMotions1=['E:\MatlabFiles\MatFiles_newruns/SemiMotions_' x '1.mat'];
    SemiMotions2=['E:\MatlabFiles\MatFiles_newruns/SemiMotions_' x '2.mat'];
    SemiMotions3=['E:\MatlabFiles\MatFiles_newruns/SemiMotions_' x '3.mat'];
    SemiMotions4=['E:\MatlabFiles\MatFiles_newruns/SemiMotions_' x '4.mat'];
    SemiMotions5=['E:\MatlabFiles\MatFiles_newruns/SemiMotions_' x '5.mat'];
    SemiMotions6=['E:\MatlabFiles\MatFiles_newruns/SemiMotions_' x '6.mat'];
    PinFlange1=['E:\MatlabFiles\MatFiles_newruns/PinFlangeMotions_' x '1.mat'];
    PinFlange2=['E:\MatlabFiles\MatFiles_newruns/PinFlangeMotions_' x '2.mat'];
    PinFlange3=['E:\MatlabFiles\MatFiles_newruns/PinFlangeMotions_' x '3.mat'];
    PinFlange4=['E:\MatlabFiles\MatFiles_newruns/PinFlangeMotions_' x '4.mat'];
    PinFlange5=['E:\MatlabFiles\MatFiles_newruns/PinFlangeMotions_' x '5.mat'];
    PinFlange6=['E:\MatlabFiles\MatFiles_newruns/PinFlangeMotions_' x '6.mat'];
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
    
    load (BladeHubLoad1)
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
    
    load (BladeHubLoad2)
    for i=1
        %rename XYZ
        L2_BR_X=BladeRootXl;
        L2_BR_Y=BladeRootYl;
        L2_BR_Z=BladeRootZ;
        L2_H_X=HubXl;
        L2_H_Y=HubYl;
        L2_H_Z=HubZ;
        L2_B_X=BladeXturn;
        L2_B_Y=BladeYturn;
        L2_B_Z=BladeZ;
        L2_B_Xr=BladeRoll;
        L2_B_Yr=BladePitch;
        L2_B_Zr=BladeYaw;
        %means
        L2_MeanRootX=mean(L2_BR_X);
        L2_MeanRootY=mean(L2_BR_Y);
        L2_MeanRootZ=mean(L2_BR_Z);
        L2_meandriftrX=rXl-L2_MeanRootX;
        L2_meandriftrY=rYl-L2_MeanRootY;
        L2_MeanHubX=mean(L2_H_X);
        L2_MeanHubY=mean(L2_H_Y);
        L2_MeanHubZ=mean(L2_H_Z);
        L2_meandrifthX=hXl-L2_MeanHubX;
        L2_meandrifthY=hYl-L2_MeanHubY;
        
        %motion radius
        L2_BladeRootPos=[L2_BR_X L2_BR_Z];
        L2_meanBRPos=mean(L2_BladeRootPos);
        L2_BR_Radius=zeros(length(L2_BR_X),1);
        for m=1:length(L2_BR_X)
            L2_BR_Radius(m)=norm(L2_BladeRootPos(m,:)-L2_meanBRPos);
        end
        
        BRoutcr=linspace(0,1.5,2000);
        cfreq_BR_L2=zeros(1,length(BRoutcr));
        for t=1:length(BRoutcr)
            index = find(L2_BR_Radius >= BRoutcr(t));
            count=length(index);
            cfreq_BR_L2(t)=count/1800;
        end
        
        L2_HubPos=[L2_H_X L2_H_Z];
        L2_meanHubPos=mean(L2_HubPos);
        L2_H_Radius=zeros(length(L2_H_X),1);
        for m=1:length(L2_H_X)
            L2_H_Radius(m)=norm(L2_HubPos(m,:)-L2_meanHubPos);
        end
        
        Houtcr=linspace(0,4,2000);
        cfreq_H_L2=zeros(1,length(Houtcr));
        for t=1:length(Houtcr)
            index = find(L2_H_Radius >= Houtcr(t));
            count=length(index);
            cfreq_H_L2(t)=count/1800;
        end
        
        %relative motions
        L2_Dist=zeros(length(L2_BR_X),1);
        for m=1:length(L2_BR_X)
            L2_Dist(m)=norm(L2_BladeRootPos(m,:)-L2_HubPos(m,:));
        end
        
        Doutcr=linspace(0,4,2000);
        cfreq_D_L2=zeros(1,length(Doutcr));
        for t=1:length(Doutcr)
            index = find(L2_Dist >= Doutcr(t));
            count=length(index);
            cfreq_D_L2(t)=count/1800;
        end
        
        L2_Y_Dist=L2_BR_Y-L2_H_Y;
        
        %blade and hub statistics
        Meanpos=sqrt(L2_MeanRootX^2+L2_MeanRootZ^2);
        L2_BR_MotionRadius=sqrt(L2_BR_X.^2+L2_BR_Z.^2);
        L2_H_MotionRadius=sqrt(L2_H_X.^2+L2_H_Z.^2);
        
        L2_BR_MR_mean=mean(L2_BR_MotionRadius);
        L2_BR_MR_max=max(L2_BR_MotionRadius)-L2_BR_MR_mean;
        L2_BR_MR_std=std(L2_BR_MotionRadius);
        L2_BR_MR_skew=skewness(L2_BR_MotionRadius);
        L2_BR_MR_kurt=kurtosis(L2_BR_MotionRadius);
        
        L2_H_MR_mean=mean(L2_H_MotionRadius);
        L2_H_MR_max=max(L2_H_MotionRadius)-L2_H_MR_mean;
        L2_H_MR_std=std(L2_H_MotionRadius);
        L2_H_MR_skew=skewness(L2_H_MotionRadius);
        L2_H_MR_kurt=kurtosis(L2_H_MotionRadius);
    end
    
    load (BladeHubLoad3)
    for i=1
        %rename XYZ
        L3_BR_X=BladeRootXl;
        L3_BR_Y=BladeRootYl;
        L3_BR_Z=BladeRootZ;
        L3_H_X=HubXl;
        L3_H_Y=HubYl;
        L3_H_Z=HubZ;
        L3_B_X=BladeXturn;
        L3_B_Y=BladeYturn;
        L3_B_Z=BladeZ;
        L3_B_Xr=BladeRoll;
        L3_B_Yr=BladePitch;
        L3_B_Zr=BladeYaw;
        %means
        L3_MeanRootX=mean(L3_BR_X);
        L3_MeanRootY=mean(L3_BR_Y);
        L3_MeanRootZ=mean(L3_BR_Z);
        L3_meandriftrX=rXl-L3_MeanRootX;
        L3_meandriftrY=rYl-L3_MeanRootY;
        L3_MeanHubX=mean(L3_H_X);
        L3_MeanHubY=mean(L3_H_Y);
        L3_MeanHubZ=mean(L3_H_Z);
        L3_meandrifthX=hXl-L3_MeanHubX;
        L3_meandrifthY=hYl-L3_MeanHubY;
        
        %motion radius
        L3_BladeRootPos=[L3_BR_X L3_BR_Z];
        L3_meanBRPos=mean(L3_BladeRootPos);
        L3_BR_Radius=zeros(length(L3_BR_X),1);
        for m=1:length(L3_BR_X)
            L3_BR_Radius(m)=norm(L3_BladeRootPos(m,:)-L3_meanBRPos);
        end
        
        BRoutcr=linspace(0,1.5,2000);
        cfreq_BR_L3=zeros(1,length(BRoutcr));
        for t=1:length(BRoutcr)
            index = find(L3_BR_Radius >= BRoutcr(t));
            count=length(index);
            cfreq_BR_L3(t)=count/1800;
        end
        
        L3_HubPos=[L3_H_X L3_H_Z];
        L3_meanHubPos=mean(L3_HubPos);
        L3_H_Radius=zeros(length(L3_H_X),1);
        for m=1:length(L3_H_X)
            L3_H_Radius(m)=norm(L3_HubPos(m,:)-L3_meanHubPos);
        end
        
        Houtcr=linspace(0,4,2000);
        cfreq_H_L3=zeros(1,length(Houtcr));
        for t=1:length(Houtcr)
            index = find(L3_H_Radius >= Houtcr(t));
            count=length(index);
            cfreq_H_L3(t)=count/1800;
        end
        
        %relative motions
        L3_Dist=zeros(length(L3_BR_X),1);
        for m=1:length(L3_BR_X)
            L3_Dist(m)=norm(L3_BladeRootPos(m,:)-L3_HubPos(m,:));
        end
        
        Doutcr=linspace(0,4,2000);
        cfreq_D_L3=zeros(1,length(Doutcr));
        for t=1:length(Doutcr)
            index = find(L3_Dist >= Doutcr(t));
            count=length(index);
            cfreq_D_L3(t)=count/1800;
        end
        
        L3_Y_Dist=L3_BR_Y-L3_H_Y;
        
        %blade and hub statistics
        Meanpos=sqrt(L3_MeanRootX^2+L3_MeanRootZ^2);
        L3_BR_MotionRadius=sqrt(L3_BR_X.^2+L3_BR_Z.^2);
        L3_H_MotionRadius=sqrt(L3_H_X.^2+L3_H_Z.^2);
        
        L3_BR_MR_mean=mean(L3_BR_MotionRadius);
        L3_BR_MR_max=max(L3_BR_MotionRadius)-L3_BR_MR_mean;
        L3_BR_MR_std=std(L3_BR_MotionRadius);
        L3_BR_MR_skew=skewness(L3_BR_MotionRadius);
        L3_BR_MR_kurt=kurtosis(L3_BR_MotionRadius);
        
        L3_H_MR_mean=mean(L3_H_MotionRadius);
        L3_H_MR_max=max(L3_H_MotionRadius)-L3_H_MR_mean;
        L3_H_MR_std=std(L3_H_MotionRadius);
        L3_H_MR_skew=skewness(L3_H_MotionRadius);
        L3_H_MR_kurt=kurtosis(L3_H_MotionRadius);
    end
    
    load (BladeHubLoad4)
    for i=1
        %rename XYZ
        L4_BR_X=BladeRootXl;
        L4_BR_Y=BladeRootYl;
        L4_BR_Z=BladeRootZ;
        L4_H_X=HubXl;
        L4_H_Y=HubYl;
        L4_H_Z=HubZ;
        L4_B_X=BladeXturn;
        L4_B_Y=BladeYturn;
        L4_B_Z=BladeZ;
        L4_B_Xr=BladeRoll;
        L4_B_Yr=BladePitch;
        L4_B_Zr=BladeYaw;
        %means
        L4_MeanRootX=mean(L4_BR_X);
        L4_MeanRootY=mean(L4_BR_Y);
        L4_MeanRootZ=mean(L4_BR_Z);
        L4_meandriftrX=rXl-L4_MeanRootX;
        L4_meandriftrY=rYl-L4_MeanRootY;
        L4_MeanHubX=mean(L4_H_X);
        L4_MeanHubY=mean(L4_H_Y);
        L4_MeanHubZ=mean(L4_H_Z);
        L4_meandrifthX=hXl-L4_MeanHubX;
        L4_meandrifthY=hYl-L4_MeanHubY;
        
        %motion radius
        L4_BladeRootPos=[L4_BR_X L4_BR_Z];
        L4_meanBRPos=mean(L4_BladeRootPos);
        L4_BR_Radius=zeros(length(L4_BR_X),1);
        for m=1:length(L4_BR_X)
            L4_BR_Radius(m)=norm(L4_BladeRootPos(m,:)-L4_meanBRPos);
        end
        
        BRoutcr=linspace(0,1.5,2000);
        cfreq_BR_L4=zeros(1,length(BRoutcr));
        for t=1:length(BRoutcr)
            index = find(L4_BR_Radius >= BRoutcr(t));
            count=length(index);
            cfreq_BR_L4(t)=count/1800;
        end
        
        L4_HubPos=[L4_H_X L4_H_Z];
        L4_meanHubPos=mean(L4_HubPos);
        L4_H_Radius=zeros(length(L4_H_X),1);
        for m=1:length(L4_H_X)
            L4_H_Radius(m)=norm(L4_HubPos(m,:)-L4_meanHubPos);
        end
        
        Houtcr=linspace(0,4,2000);
        cfreq_H_L4=zeros(1,length(Houtcr));
        for t=1:length(Houtcr)
            index = find(L4_H_Radius >= Houtcr(t));
            count=length(index);
            cfreq_H_L4(t)=count/1800;
        end
        
        %relative motions
        L4_Dist=zeros(length(L4_BR_X),1);
        for m=1:length(L4_BR_X)
            L4_Dist(m)=norm(L4_BladeRootPos(m,:)-L4_HubPos(m,:));
        end
        
        Doutcr=linspace(0,4,2000);
        cfreq_D_L4=zeros(1,length(Doutcr));
        for t=1:length(Doutcr)
            index = find(L4_Dist >= Doutcr(t));
            count=length(index);
            cfreq_D_L4(t)=count/1800;
        end
        
        L4_Y_Dist=L4_BR_Y-L4_H_Y;
        
        %blade and hub statistics
        Meanpos=sqrt(L4_MeanRootX^2+L4_MeanRootZ^2);
        L4_BR_MotionRadius=sqrt(L4_BR_X.^2+L4_BR_Z.^2);
        L4_H_MotionRadius=sqrt(L4_H_X.^2+L4_H_Z.^2);
        
        L4_BR_MR_mean=mean(L4_BR_MotionRadius);
        L4_BR_MR_max=max(L4_BR_MotionRadius)-L4_BR_MR_mean;
        L4_BR_MR_std=std(L4_BR_MotionRadius);
        L4_BR_MR_skew=skewness(L4_BR_MotionRadius);
        L4_BR_MR_kurt=kurtosis(L4_BR_MotionRadius);
        
        L4_H_MR_mean=mean(L4_H_MotionRadius);
        L4_H_MR_max=max(L4_H_MotionRadius)-L4_H_MR_mean;
        L4_H_MR_std=std(L4_H_MotionRadius);
        L4_H_MR_skew=skewness(L4_H_MotionRadius);
        L4_H_MR_kurt=kurtosis(L4_H_MotionRadius);
    end
    
    load (BladeHubLoad5)
    for i=1
        %rename XYZ
        L5_BR_X=BladeRootXl;
        L5_BR_Y=BladeRootYl;
        L5_BR_Z=BladeRootZ;
        L5_H_X=HubXl;
        L5_H_Y=HubYl;
        L5_H_Z=HubZ;
        L5_B_X=BladeXturn;
        L5_B_Y=BladeYturn;
        L5_B_Z=BladeZ;
        L5_B_Xr=BladeRoll;
        L5_B_Yr=BladePitch;
        L5_B_Zr=BladeYaw;
        %means
        L5_MeanRootX=mean(L5_BR_X);
        L5_MeanRootY=mean(L5_BR_Y);
        L5_MeanRootZ=mean(L5_BR_Z);
        L5_meandriftrX=rXl-L5_MeanRootX;
        L5_meandriftrY=rYl-L5_MeanRootY;
        L5_MeanHubX=mean(L5_H_X);
        L5_MeanHubY=mean(L5_H_Y);
        L5_MeanHubZ=mean(L5_H_Z);
        L5_meandrifthX=hXl-L5_MeanHubX;
        L5_meandrifthY=hYl-L5_MeanHubY;
        
        %motion radius
        L5_BladeRootPos=[L5_BR_X L5_BR_Z];
        L5_meanBRPos=mean(L5_BladeRootPos);
        L5_BR_Radius=zeros(length(L5_BR_X),1);
        for m=1:length(L5_BR_X)
            L5_BR_Radius(m)=norm(L5_BladeRootPos(m,:)-L5_meanBRPos);
        end
        
        BRoutcr=linspace(0,1.5,2000);
        cfreq_BR_L5=zeros(1,length(BRoutcr));
        for t=1:length(BRoutcr)
            index = find(L5_BR_Radius >= BRoutcr(t));
            count=length(index);
            cfreq_BR_L5(t)=count/1800;
        end
        
        L5_HubPos=[L5_H_X L5_H_Z];
        L5_meanHubPos=mean(L5_HubPos);
        L5_H_Radius=zeros(length(L5_H_X),1);
        for m=1:length(L5_H_X)
            L5_H_Radius(m)=norm(L5_HubPos(m,:)-L5_meanHubPos);
        end
        
        Houtcr=linspace(0,4,2000);
        cfreq_H_L5=zeros(1,length(Houtcr));
        for t=1:length(Houtcr)
            index = find(L5_H_Radius >= Houtcr(t));
            count=length(index);
            cfreq_H_L5(t)=count/1800;
        end
        
        %relative motions
        L5_Dist=zeros(length(L5_BR_X),1);
        for m=1:length(L5_BR_X)
            L5_Dist(m)=norm(L5_BladeRootPos(m,:)-L5_HubPos(m,:));
        end
        
        Doutcr=linspace(0,4,2000);
        cfreq_D_L5=zeros(1,length(Doutcr));
        for t=1:length(Doutcr)
            index = find(L5_Dist >= Doutcr(t));
            count=length(index);
            cfreq_D_L5(t)=count/1800;
        end
        
        L5_Y_Dist=L5_BR_Y-L5_H_Y;
        
        %blade and hub statistics
        Meanpos=sqrt(L5_MeanRootX^2+L5_MeanRootZ^2);
        L5_BR_MotionRadius=sqrt(L5_BR_X.^2+L5_BR_Z.^2);
        L5_H_MotionRadius=sqrt(L5_H_X.^2+L5_H_Z.^2);
        
        L5_BR_MR_mean=mean(L5_BR_MotionRadius);
        L5_BR_MR_max=max(L5_BR_MotionRadius)-L5_BR_MR_mean;
        L5_BR_MR_std=std(L5_BR_MotionRadius);
        L5_BR_MR_skew=skewness(L5_BR_MotionRadius);
        L5_BR_MR_kurt=kurtosis(L5_BR_MotionRadius);
        
        L5_H_MR_mean=mean(L5_H_MotionRadius);
        L5_H_MR_max=max(L5_H_MotionRadius)-L5_H_MR_mean;
        L5_H_MR_std=std(L5_H_MotionRadius);
        L5_H_MR_skew=skewness(L5_H_MotionRadius);
        L5_H_MR_kurt=kurtosis(L5_H_MotionRadius);
    end
    
    load (BladeHubLoad6)
    for i=1
        %rename XYZ
        L6_BR_X=BladeRootXl;
        L6_BR_Y=BladeRootYl;
        L6_BR_Z=BladeRootZ;
        L6_H_X=HubXl;
        L6_H_Y=HubYl;
        L6_H_Z=HubZ;
        L6_B_X=BladeXturn;
        L6_B_Y=BladeYturn;
        L6_B_Z=BladeZ;
        L6_B_Xr=BladeRoll;
        L6_B_Yr=BladePitch;
        L6_B_Zr=BladeYaw;
        %means
        L6_MeanRootX=mean(L6_BR_X);
        L6_MeanRootY=mean(L6_BR_Y);
        L6_MeanRootZ=mean(L6_BR_Z);
        L6_meandriftrX=rXl-L6_MeanRootX;
        L6_meandriftrY=rYl-L6_MeanRootY;
        L6_MeanHubX=mean(L6_H_X);
        L6_MeanHubY=mean(L6_H_Y);
        L6_MeanHubZ=mean(L6_H_Z);
        L6_meandrifthX=hXl-L6_MeanHubX;
        L6_meandrifthY=hYl-L6_MeanHubY;
        
        %motion radius
        L6_BladeRootPos=[L6_BR_X L6_BR_Z];
        L6_meanBRPos=mean(L6_BladeRootPos);
        L6_BR_Radius=zeros(length(L6_BR_X),1);
        for m=1:length(L6_BR_X)
            L6_BR_Radius(m)=norm(L6_BladeRootPos(m,:)-L6_meanBRPos);
        end
        
        BRoutcr=linspace(0,1.5,2000);
        cfreq_BR_L6=zeros(1,length(BRoutcr));
        for t=1:length(BRoutcr)
            index = find(L6_BR_Radius >= BRoutcr(t));
            count=length(index);
            cfreq_BR_L6(t)=count/1800;
        end
        
        L6_HubPos=[L6_H_X L6_H_Z];
        L6_meanHubPos=mean(L6_HubPos);
        L6_H_Radius=zeros(length(L6_H_X),1);
        for m=1:length(L6_H_X)
            L6_H_Radius(m)=norm(L6_HubPos(m,:)-L6_meanHubPos);
        end
        
        Houtcr=linspace(0,4,2000);
        cfreq_H_L6=zeros(1,length(Houtcr));
        for t=1:length(Houtcr)
            index = find(L6_H_Radius >= Houtcr(t));
            count=length(index);
            cfreq_H_L6(t)=count/1800;
        end
        
        %relative motions
        L6_Dist=zeros(length(L6_BR_X),1);
        for m=1:length(L6_BR_X)
            L6_Dist(m)=norm(L6_BladeRootPos(m,:)-L6_HubPos(m,:));
        end
        
        Doutcr=linspace(0,4,2000);
        cfreq_D_L6=zeros(1,length(Doutcr));
        for t=1:length(Doutcr)
            index = find(L6_Dist >= Doutcr(t));
            count=length(index);
            cfreq_D_L6(t)=count/1800;
        end
        
        L6_Y_Dist=L6_BR_Y-L6_H_Y;
        
        %blade and hub statistics
        Meanpos=sqrt(L6_MeanRootX^2+L6_MeanRootZ^2);
        L6_BR_MotionRadius=sqrt(L6_BR_X.^2+L6_BR_Z.^2);
        L6_H_MotionRadius=sqrt(L6_H_X.^2+L6_H_Z.^2);
        
        L6_BR_MR_mean=mean(L6_BR_MotionRadius);
        L6_BR_MR_max=max(L6_BR_MotionRadius)-L6_BR_MR_mean;
        L6_BR_MR_std=std(L6_BR_MotionRadius);
        L6_BR_MR_skew=skewness(L6_BR_MotionRadius);
        L6_BR_MR_kurt=kurtosis(L6_BR_MotionRadius);
        
        L6_H_MR_mean=mean(L6_H_MotionRadius);
        L6_H_MR_max=max(L6_H_MotionRadius)-L6_H_MR_mean;
        L6_H_MR_std=std(L6_H_MotionRadius);
        L6_H_MR_skew=skewness(L6_H_MotionRadius);
        L6_H_MR_kurt=kurtosis(L6_H_MotionRadius);
    end
    
    % ncrit plot
    vcr=5.55*10^(-3);
    for q=1
        cfreq_BR_all=[cfreq_BR_L1; cfreq_BR_L2; cfreq_BR_L3; cfreq_BR_L4;cfreq_BR_L5;cfreq_BR_L6];
        cfreq_BR=mean(cfreq_BR_all);
        temp = abs(vcr - cfreq_BR); % Temporary "distances" array.
        nbcr_BRs = BRoutcr(find(temp == min(abs(vcr - cfreq_BR)))); % Find "closest" values array wrt. target value.
        nbcr_BR = nbcr_BRs(1);
        
        cfreq_H_all=[cfreq_H_L1; cfreq_H_L2; cfreq_H_L3; cfreq_H_L4;cfreq_H_L5;cfreq_H_L6];
        cfreq_H=mean(cfreq_H_all);
        temp = abs(vcr - cfreq_H); % Temporary "distances" array.
        nbcr_Hs = Houtcr(find(temp == min(abs(vcr - cfreq_H)))); % Find "closest" values array wrt. target value.
        nbcr_H = nbcr_Hs(1);
        
        cfreq_D_all=[cfreq_D_L1; cfreq_D_L2; cfreq_D_L3; cfreq_D_L4;cfreq_D_L5;cfreq_D_L6];
        cfreq_D=mean(cfreq_D_all);
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
        
        
        
        f1=figure('Renderer', 'painters', 'Position', [10 10 600 400]);
        plot(BRoutcr,cfreq_BRx,"k.", 'HandleVisibility','off'); hold on
        grid on
        grid minor
        plot(Houtcr,cfreq_Hx,"k.", 'HandleVisibility','off');
        plot(Doutcr,cfreq_Dx,"k.", 'HandleVisibility','off');
        pBR=plot(nbcr_BRx,yBRx,'Color','r','Marker','o', 'DisplayName', BRlegx);
        pH=plot(nbcr_Hx,yHx,'Color','r','Marker','^', 'DisplayName', Hlegx);
        pD=plot(nbcr_Dx,yDx,'Color','r','Marker','square', 'DisplayName', Dlegx);
        xlabel('Motion radius \eta [m]')
        ylabel('Barrier of the outcrossing rate \nu [Hz]')
        set(gca, 'YScale', 'log')
        %title(nctit)
        ylim([0 10^-1])
        legend show
        
        
        
        exportgraphics(f1,'OneCase_Outcrossing.pdf')
        %%
        
        Y_Dist_Case=[L1_Y_Dist,L2_Y_Dist,L3_Y_Dist,L4_Y_Dist,L5_Y_Dist,L6_Y_Dist];
        
        f31=figure('Renderer', 'painters', 'Position', [10 10 600 400]);
        plot(timeRif,Y_Dist_Case), hold on,
        xlabel('time[s]'), ylabel('Distance in y-direction [m]'),grid on, xlim([0 1800]),
        yline(0.1,'--r'),
        legend('Simulation 1','Simulation 2','Simulation 3','Simulation 4','Simulation 5','Simulation 6','Distance limit')
        
        exportgraphics(f31,'YDirCheckLC14.pdf')
    end
    
    
    %xz plots
    for k=1
        figure()
        subplot(2,3,1)
        plot(L1_H_X, L1_H_Z,L1_BR_X,L1_BR_Z);
        xlabel('global x position [m]')
        ylabel('global z position [m]')
        legend('Hub pos','Blade pos')
        %circle(L1_MeanRootX,mean(L1_BR_Z),BrootDia/2);
        %circle(L1_MeanHubX,mean(L1_H_Z),HrootDia/2);
        %legend('Hub pos','Blade pos','Hub root','Blade root')
        
        subplot(2,3,2)
        plot(L2_H_X, L2_H_Z,L2_BR_X,L2_BR_Z);
        xlabel('global x position [m]')
        ylabel('global z position [m]')
        legend('Hub pos','Blade pos')
        %         circle(L2_MeanRootX,mean(L2_BR_Z),BrootDia/2);
        %         circle(L2_MeanHubX,mean(L2_H_Z),HrootDia/2);
        %         legend('Hub pos','Blade pos','Hub root','Blade root')
        
        subplot(2,3,3)
        plot(L3_H_X, L3_H_Z,L3_BR_X,L3_BR_Z);
        xlabel('global x position [m]')
        ylabel('global z position [m]')
        legend('Hub pos','Blade pos')
        %         circle(L3_MeanRootX,mean(L3_BR_Z),BrootDia/2);
        %         circle(L3_MeanHubX,mean(L3_H_Z),HrootDia/2);
        %         legend('Hub pos','Blade pos','Hub root','Blade root')
        
        subplot(2,3,4)
        plot(L4_H_X, L4_H_Z,L4_BR_X,L4_BR_Z);
        xlabel('global x position [m]')
        ylabel('global z position [m]')
        legend('Hub pos','Blade pos')
        %         circle(L4_MeanRootX,mean(L4_BR_Z),BrootDia/2);
        %         circle(L4_MeanHubX,mean(L4_H_Z),HrootDia/2);
        %         legend('Hub pos','Blade pos','Hub root','Blade root')
        %
        subplot(2,3,5)
        plot(L5_H_X, L5_H_Z,L5_BR_X,L5_BR_Z);
        xlabel('global x position [m]')
        ylabel('global z position [m]')
        legend('Hub pos','Blade pos')
        %         circle(L5_MeanRootX,mean(L5_BR_Z),BrootDia/2);
        %         circle(L5_MeanHubX,mean(L5_H_Z),HrootDia/2);
        %         legend('Hub pos','Blade pos','Hub root','Blade root')
        
        
        subplot(2,3,6)
        plot(L6_H_X, L6_H_Z,L6_BR_X,L6_BR_Z);
        xlabel('global x position [m]')
        ylabel('global z position [m]')
        legend('Hub pos','Blade pos')
        %         circle(L6_MeanRootX,mean(L6_BR_Z),BrootDia/2);
        %         circle(L6_MeanHubX,mean(L6_H_Z),HrootDia/2);
        %         legend('Hub pos','Blade pos','Hub root','Blade root')
        %
        % %figure()
        % %plot3(L1_BR_X,L1_BR_Y,L1_BR_Z,L1_H_X,L1_H_Y ,L1_H_Z)
    end
    %%
    for k=1
        
        
        
        f2=figure('Renderer', 'painters', 'Position', [10 10 1100 500]);
        subplot(1,2,2)
        plot(BRoutcr,cfreq_BRx,"k.", 'HandleVisibility','off'); hold on
        grid on
        grid minor
        pBR=plot(nbcr_BRx,yBRx,'Color','r','Marker','o', 'DisplayName', BRlegx);
        xlabel('Motion radius \eta [m]')
        ylabel('Barrier of the outcrossing rate \nu [Hz]')
        set(gca, 'YScale', 'log')
        %title(nctit)
        ylim([0 10^-1])
        legend show
        subplot(1,2,1)
        plot(L1_BR_X-L1_MeanRootX,L1_BR_Z-mean(L1_BR_Z));
        xlabel('Blade root x-displacment [m]')
        ylabel('Blade root z-displacment [m]')
        grid on
        circle(0,0,D_crit);
        circle(0,0,nbcr_BRx);
        c1tit=['R_{sb1}= ',num2str(D_crit),'m'];
        c2tit=['\eta_{bcr}= ',num2str(round(nbcr_BRx,2)),'m'];
        legend('Blade pos',c1tit,c2tit)
        
        
        exportgraphics(f2,'BladePosi.pdf')
        
        f21=figure('Renderer', 'painters', 'Position', [10 10 500 500]);
        
        plot(BRoutcr,cfreq_BRx,"k.", 'HandleVisibility','off'); hold on
        grid on
        grid minor
        pBR=plot(nbcr_BRx,yBRx,'Color','r','Marker','o', 'DisplayName', BRlegx);
        xlabel('Motion radius \eta [m]')
        ylabel('Barrier of the outcrossing rate \nu [Hz]')
        set(gca, 'YScale', 'log')
        ylim([0 10^-1])
        legend show
        
        exportgraphics(f21,'BladeNbcr.pdf')
        
        cfreq_H_allx=cfreq_H_L1;
        cfreq_Hx=cfreq_H_allx;
        temp = abs(vcr - cfreq_Hx); % Temporary "distances" array.
        nbcr_Hxs = Houtcr(find(temp == min(abs(vcr - cfreq_Hx)))); % Find "closest" values array wrt. target value.
        nbcr_Hx = nbcr_Hxs(1);
        
        f3=figure('Renderer', 'painters', 'Position', [10 10 500 500]);
        plot(L1_H_X-L1_MeanHubX,L1_H_Z-mean(L1_H_Z));
        xlabel('Hub x-displacment [m]')
        ylabel('Hub z-displacment [m]')
        grid on
        circle(0,0,D_crit);
        circle(0,0,nbcr_Hx);
        c1tit=['R_{sb1}= ',num2str(D_crit),'m'];
        c2tit=['\eta_{hcr}= ',num2str(round(nbcr_Hx,2)),'m'];
        legend('Hub pos',c1tit,c2tit)
        
        
        exportgraphics(f3,'HubPosi.pdf')
        
        cfreq_D_allx=cfreq_D_L1;
        cfreq_Dx=cfreq_D_allx;
        temp = abs(vcr - cfreq_Dx); % Temporary "distances" array.
        nbcr_Dsx = Doutcr(find(temp == min(abs(vcr - cfreq_Dx)))); % Find "closest" values array wrt. target value.
        nbcr_Dx = nbcr_Dsx(1);
        
        
    
    
    drifts=[L1_meandriftrX L1_meandriftrY L1_meandrifthX L1_meandrifthY;L2_meandriftrX L2_meandriftrY L2_meandrifthX L2_meandrifthY;L3_meandriftrX L3_meandriftrY L3_meandrifthX L3_meandrifthY;L4_meandriftrX L4_meandriftrY L4_meandrifthX L4_meandrifthY;L5_meandriftrX L5_meandriftrY L5_meandrifthX L5_meandrifthY;L6_meandriftrX L6_meandriftrY L6_meandrifthX L6_meandrifthY];
    
    Dists=[L1_Dist L2_Dist L3_Dist L4_Dist L5_Dist L6_Dist];
    
    Y_Dists=[L1_Y_Dist L2_Y_Dist L3_Y_Dist L4_Y_Dist L5_Y_Dist L6_Y_Dist];
    
    BR_MR_mean=mean([L1_BR_MR_mean, L2_BR_MR_mean, L3_BR_MR_mean, L4_BR_MR_mean, L5_BR_MR_mean, L6_BR_MR_mean]);
    BR_MR_max=mean([L1_BR_MR_max, L2_BR_MR_max, L3_BR_MR_max, L4_BR_MR_max, L5_BR_MR_max, L6_BR_MR_max]);
    BR_MR_std=mean([L1_BR_MR_std, L2_BR_MR_std, L3_BR_MR_std, L4_BR_MR_std, L5_BR_MR_std, L6_BR_MR_std]);
    BR_MR_skew=mean([L1_BR_MR_skew, L2_BR_MR_skew, L3_BR_MR_skew, L4_BR_MR_skew, L5_BR_MR_skew, L6_BR_MR_skew]);
    BR_MR_kurt=mean([L1_BR_MR_kurt, L2_BR_MR_kurt, L3_BR_MR_kurt, L4_BR_MR_kurt, L5_BR_MR_kurt, L6_BR_MR_kurt]);
    
    H_MR_mean=mean([L1_H_MR_mean, L2_H_MR_mean, L3_H_MR_mean, L4_H_MR_mean, L5_H_MR_mean, L6_H_MR_mean]);
    H_MR_max=mean([L1_H_MR_max, L2_H_MR_max, L3_H_MR_max, L4_H_MR_max, L5_H_MR_max, L6_H_MR_max]);
    H_MR_std=mean([L1_H_MR_std, L2_H_MR_std, L3_H_MR_std, L4_H_MR_std, L5_H_MR_std, L6_H_MR_std]);
    H_MR_skew=mean([L1_H_MR_skew, L2_H_MR_skew, L3_H_MR_skew, L4_H_MR_skew, L5_H_MR_skew, L6_H_MR_skew]);
    H_MR_kurt=mean([L1_H_MR_kurt, L2_H_MR_kurt, L3_H_MR_kurt, L4_H_MR_kurt, L5_H_MR_kurt, L6_H_MR_kurt]);
    
    Stats=[BR_MR_mean, BR_MR_max, BR_MR_std, BR_MR_skew, BR_MR_kurt,H_MR_mean,H_MR_max,H_MR_std,H_MR_skew,H_MR_kurt];
    
    
    f5=figure('Renderer', 'painters', 'Position', [10 10 900 400]);
    subplot(1,2,2)
    plot(L1_H_X-L1_MeanHubX,L1_H_Z-mean(L1_H_Z),L1_BR_X-L1_MeanHubX,L1_BR_Z-mean(L1_H_Z));
    xlabel('Hub x-displacment [m]')
    ylabel('Hub z-displacment [m]')
    grid on
    circle(0,0,D_crit);
    circle(0,0,nbcr_Dx);
    c1tit=['R_{sb1}= ',num2str(D_crit),'m'];
    c2tit=['\eta_{rcr}= ',num2str(round(nbcr_Dx,2)),'m'];
    legend('Hub pos','Blade pos',c1tit,c2tit)
    
    subplot(1,2,1)
    plot(timeRif,Dists(:,1));
    grid on
    xlabel('time [s]')
    ylabel('Distance in xz-plane [m]')
    yline(D_crit,'--r')
    yline(nbcr_Dx, 'Color', [0.5 0.5 0.5]);
    xlim([0 1800])
    c1tit=['R_{sb1}= ',num2str(D_crit),'m'];
    c2tit=['\eta_{rcr}= ',num2str(round(nbcr_Dx,2)),'m'];
    legend('Relative motion',c1tit,c2tit)
    
    exportgraphics(f5,'RelMotionTime.pdf')
    end
    %% dist plots
    for p=1
        figure()
        subplot(2,3,1)
        plot(timeRif,Dists(:,1));
        grid on
        xlabel('time [s]')
        ylabel('distance in x-z plane [m]')
        yline(D_crit,'--r')
        
        subplot(2,3,2)
        plot(timeRif,Dists(:,2));
        grid on
        xlabel('time [s]')
        ylabel('distance in x-z plane [m]')
        yline(D_crit,'--r')
        
        
        subplot(2,3,3)
        plot(timeRif,Dists(:,3));
        grid on
        xlabel('time [s]')
        ylabel('distance in x-z plane [m]')
        yline(D_crit,'--r')
        
        
        subplot(2,3,4)
        plot(timeRif,Dists(:,4));
        grid on
        xlabel('time [s]')
        ylabel('distance in x-z plane [m]')
        yline(D_crit,'--r')
        
        subplot(2,3,5)
        plot(timeRif,Dists(:,5));
        grid on
        xlabel('time [s]')
        ylabel('distance in x-z plane [m]')
        yline(D_crit,'--r')
        
        
        subplot(2,3,6)
        plot(timeRif,Dists(:,6));
        grid on
        xlabel('time [s]')
        ylabel('distance in x-z plane [m]')
        yline(D_crit,'--r')
        
        
        
    end
    
    for f=1
        f5=figure('Renderer', 'painters', 'Position', [10 10 600 400]);
        plot(timeRif,Dists(:,1));
        grid on
        xlabel('time [s]')
        ylabel('Distance in xz-plane [m]')
        yline(D_crit,'--r')
        yline(nbcr_Dx, 'Color', [0.5 0.5 0.5]);
        xlim([0 1800])
        c1tit=['R_{sb1}= ',num2str(D_crit),'m'];
        c2tit=['\eta_{rcr}= ',num2str(round(nbcr_Dx,2)),'m'];
        legend('Relative motion',c1tit,c2tit)
        
        exportgraphics(f5,'RelMotion.pdf')
    end
end
%% Semi Motions

for j=1
    sXl=93;
    sYl=-37.77;
    sZl=0;
    
    load (SemiMotions1)
    for i=1
        %rename XYZ
        L1_S_X=SemiXturn;
        L1_S_Y=SemiYturn;
        L1_S_Z=SemiZ;
        L1_S_Xr=SemiRoll;
        L1_S_Yr=SemiPitch;
        L1_S_Zr=SemiYaw;
        
        %means
        L1_MeanSX=mean(L1_S_X);
        L1_MeanSY=mean(L1_S_Y);
        L1_meandriftSX=sXl-L1_MeanSX;
        L1_meandriftSY=sYl-L1_MeanSY;
        L1_meandriftSZ=sZl-mean(L1_S_Z);
        L1_MeanSXr=mean(L1_S_Xr);
        L1_MeanSYr=mean(L1_S_Yr);
        
        L1_S_Zlr=zeros(1,length(L1_S_Zr));
        for k=1:length(L1_S_Zr)
            if L1_S_Zr(k)>0
                L1_S_Zlr(k)=L1_S_Zr(k)-270;
            end
            if L1_S_Zr(k)<0
                L1_S_Zlr(k)=L1_S_Zr(k)+90;
            end
        end
        L1_MeanSZr=mean( L1_S_Zlr);
    end
    
    load (SemiMotions2)
    for i=1
        %rename XYZ
        L2_S_X=SemiXturn;
        L2_S_Y=SemiYturn;
        L2_S_Z=SemiZ;
        L2_S_Xr=SemiRoll;
        L2_S_Yr=SemiPitch;
        L2_S_Zr=SemiYaw;
        
        %means
        L2_MeanSX=mean(L2_S_X);
        L2_MeanSY=mean(L2_S_Y);
        L2_meandriftSX=sXl-L2_MeanSX;
        L2_meandriftSY=sYl-L2_MeanSY;
        L2_meandriftSZ=sZl-mean(L2_S_Z);
        L2_MeanSXr=mean(L2_S_Xr);
        L2_MeanSYr=mean(L2_S_Yr);
        
        L2_S_Zlr=zeros(1,length(L2_S_Zr));
        for k=1:length(L2_S_Zr)
            if L2_S_Zr(k)>0
                L2_S_Zlr(k)=L2_S_Zr(k)-270;
            end
            if L2_S_Zr(k)<0
                L2_S_Zlr(k)=L2_S_Zr(k)+90;
            end
        end
        L2_MeanSZr=mean( L2_S_Zlr);
    end
    
    load (SemiMotions3)
    for i=1
        %rename XYZ
        L3_S_X=SemiXturn;
        L3_S_Y=SemiYturn;
        L3_S_Z=SemiZ;
        L3_S_Xr=SemiRoll;
        L3_S_Yr=SemiPitch;
        L3_S_Zr=SemiYaw;
        
        %means
        L3_MeanSX=mean(L3_S_X);
        L3_MeanSY=mean(L3_S_Y);
        L3_meandriftSX=sXl-L3_MeanSX;
        L3_meandriftSY=sYl-L3_MeanSY;
        L3_meandriftSZ=sZl-mean(L3_S_Z);
        L3_MeanSXr=mean(L3_S_Xr);
        L3_MeanSYr=mean(L3_S_Yr);
        
        L3_S_Zlr=zeros(1,length(L3_S_Zr));
        for k=1:length(L3_S_Zr)
            if L3_S_Zr(k)>0
                L3_S_Zlr(k)=L3_S_Zr(k)-270;
            end
            if L3_S_Zr(k)<0
                L3_S_Zlr(k)=L3_S_Zr(k)+90;
            end
        end
        L3_MeanSZr=mean( L3_S_Zlr);
    end
    
    load (SemiMotions4)
    for i=1
        %rename XYZ
        L4_S_X=SemiXturn;
        L4_S_Y=SemiYturn;
        L4_S_Z=SemiZ;
        L4_S_Xr=SemiRoll;
        L4_S_Yr=SemiPitch;
        L4_S_Zr=SemiYaw;
        
        %means
        L4_MeanSX=mean(L4_S_X);
        L4_MeanSY=mean(L4_S_Y);
        L4_meandriftSX=sXl-L4_MeanSX;
        L4_meandriftSY=sYl-L4_MeanSY;
        L4_meandriftSZ=sZl-mean(L4_S_Z);
        L4_MeanSXr=mean(L4_S_Xr);
        L4_MeanSYr=mean(L4_S_Yr);
        
        L1_S_Zlr=zeros(1,length(L4_S_Zr));
        for k=1:length(L4_S_Zr)
            if L4_S_Zr(k)>0
                L4_S_Zlr(k)=L4_S_Zr(k)-270;
            end
            if L4_S_Zr(k)<0
                L4_S_Zlr(k)=L4_S_Zr(k)+90;
            end
        end
        L4_MeanSZr=mean( L4_S_Zlr);
    end
    
    load (SemiMotions5)
    for i=1
        %rename XYZ
        L5_S_X=SemiXturn;
        L5_S_Y=SemiYturn;
        L5_S_Z=SemiZ;
        L5_S_Xr=SemiRoll;
        L5_S_Yr=SemiPitch;
        L5_S_Zr=SemiYaw;
        
        %means
        L5_MeanSX=mean(L5_S_X);
        L5_MeanSY=mean(L5_S_Y);
        L5_meandriftSX=sXl-L5_MeanSX;
        L5_meandriftSY=sYl-L5_MeanSY;
        L5_meandriftSZ=sZl-mean(L5_S_Z);
        L5_MeanSXr=mean(L5_S_Xr);
        L5_MeanSYr=mean(L5_S_Yr);
        
        L5_S_Zlr=zeros(1,length(L5_S_Zr));
        for k=1:length(L5_S_Zr)
            if L5_S_Zr(k)>0
                L5_S_Zlr(k)=L5_S_Zr(k)-270;
            end
            if L5_S_Zr(k)<0
                L5_S_Zlr(k)=L5_S_Zr(k)+90;
            end
        end
        L5_MeanSZr=mean( L5_S_Zlr);
    end
    
    load (SemiMotions6)
    for i=1
        %rename XYZ
        L6_S_X=SemiXturn;
        L6_S_Y=SemiYturn;
        L6_S_Z=SemiZ;
        L6_S_Xr=SemiRoll;
        L6_S_Yr=SemiPitch;
        L6_S_Zr=SemiYaw;
        
        %means
        L6_MeanSX=mean(L6_S_X);
        L6_MeanSY=mean(L6_S_Y);
        L6_meandriftSX=sXl-L6_MeanSX;
        L6_meandriftSY=sYl-L6_MeanSY;
        L6_meandriftSZ=mean(L6_S_Z);
        L6_MeanSXr=mean(L6_S_Xr);
        L6_MeanSYr=mean(L6_S_Yr);
        
        L6_S_Zlr=zeros(1,length(L6_S_Zr));
        for k=1:length(L6_S_Zr)
            if L6_S_Zr(k)>0
                L6_S_Zlr(k)=L6_S_Zr(k)-270;
            end
            if L6_S_Zr(k)<0
                L6_S_Zlr(k)=L6_S_Zr(k)+90;
            end
        end
        L6_MeanSZr=mean(L6_S_Zlr);
    end
    
    
    driftsS=[L1_meandriftSX L1_meandriftSY L1_meandriftSZ L1_MeanSXr L1_MeanSYr L1_MeanSZr;L2_meandriftSX L2_meandriftSY L2_meandriftSZ L2_MeanSXr L2_MeanSYr L2_MeanSZr;L3_meandriftSX L3_meandriftSY L3_meandriftSZ L3_MeanSXr L3_MeanSYr L3_MeanSZr;L4_meandriftSX L4_meandriftSY L4_meandriftSZ L4_MeanSXr L4_MeanSYr L4_MeanSZr;L5_meandriftSX L5_meandriftSY L5_meandriftSZ L5_MeanSXr L5_MeanSYr L5_MeanSZr;L6_meandriftSX L6_meandriftSY L6_meandriftSZ L6_MeanSXr L6_MeanSYr L6_MeanSZr];
end
%% Pin & Flange
Fs = 36000 / 1800;
cutoffFrequency = 0.5; % Set the cutoff frequency (in Hz)
normalizedCutoff = cutoffFrequency / (Fs/2); % Normalize cutoff frequency


% Design a high-pass filter
N = 100; % Filter order (can be adjusted)
b = fir1(N, normalizedCutoff, 'high');


cutoffFrequency3 = 0.3; % Set the cutoff frequency (in Hz)
normalizedCutoff3 = cutoffFrequency3 / (Fs/2); % Normalize cutoff frequency


% Design a high-pass filter
b3 = fir1(N, normalizedCutoff3, 'high');
for j=1
        pXl=88*cos(phi)-(-23.31)*sin(phi);
        pYl=88*sin(phi)+(-23.31)*cos(phi);
    
        fXl=88.5*cos(phi)-(-24.18)*sin(phi);
        fYl=88.5*sin(phi)+(-24.18)*cos(phi);
        PinDia=0.028;
        FlDia=0.03;
        D_crit_PF=0.004;
        %'BlPinXl', 'BlPinYl', 'BlPinZ', 'HubFlXl', 'HubFlYl', 'HubFlZ'
        load (PinFlange1)
        for i=1
            %rename XYZ
            L1_Pin_X=BlPinXl;
            L1_Pin_Y=BlPinYl;
            L1_Pin_Z=BlPinZ;
            L1_Fl_X=HubFlXl;
            L1_Fl_Y=HubFlYl;
            L1_Fl_Z=HubFlZ;
    
            %means
            L1_MeanPinX=mean(L1_Pin_X);
            L1_MeanPinY=mean(L1_Pin_Y);
            L1_meandriftpX=pXl-L1_MeanPinX;
            L1_meandriftpY=pYl-L1_MeanPinY;
            L1_MeanFlX=mean(L1_Fl_X);
            L1_MeanFlY=mean(L1_Fl_Y);
            L1_meandriftFlX=fXl-L1_MeanFlX;
            L1_meandriftFlY=fYl-L1_MeanFlY;
    
            %motion radius
            L1_PinPos=[L1_Pin_X L1_Pin_Z];
            L1_meanPinPos=mean(L1_PinPos);
            L1_Pin_Radius=zeros(length(L1_Pin_X),1);
            for m=1:length(L1_Pin_X)
                L1_Pin_Radius(m)=norm(L1_PinPos(m,:)-L1_meanPinPos);
            end
            % Apply high-pass filter
            L1_Pin_Radius =filtfilt(b, 1, L1_Pin_Radius);
            %L1_Pin_Radius = highpass(L1_Pin_Radius, normalizedCutoff);
            
            
            Pinoutcr=linspace(0,1.5,2000);
            cfreq_Pin_L1=zeros(1,length(Pinoutcr));
            for t=1:length(Pinoutcr)
                index = find(L1_Pin_Radius >= Pinoutcr(t));
                count=length(index);
                cfreq_Pin_L1(t)=count/1800;
            end
    
            L1_FlPos=[L1_Fl_X L1_Fl_Z];
            L1_meanFlPos=mean(L1_FlPos);
            L1_Fl_Radius=zeros(length(L1_Fl_X),1);
            for m=1:length(L1_Fl_X)
                L1_Fl_Radius(m)=norm(L1_FlPos(m,:)-L1_meanFlPos);
            end
            % Apply high-pass filter
            %L1_Fl_Radius = highpass(L1_Fl_Radius, normalizedCutoff);
            L1_Fl_Radius  =filtfilt(b, 1,  L1_Fl_Radius);
            
            Floutcr=linspace(0,4,2000);
            cfreq_Fl_L1=zeros(1,length(Floutcr));
            for t=1:length(Floutcr)
                index = find(L1_Fl_Radius >= Floutcr(t));
                count=length(index);
                cfreq_Fl_L1(t)=count/1800;
            end
    
            %relative motions
            L1_Dist_PF=zeros(length(L1_Pin_X),1);
            for m=1:length(L1_Pin_X)
                L1_Dist_PF(m)=norm(L1_PinPos(m,:)-L1_FlPos(m,:));
            end
            % Apply high-pass filter
            %L1_Dist_PF = highpass(L1_Dist_PF, normalizedCutoff);
            L1_Dist_PF_unfiltered=L1_Dist_PF;
            L1_Dist_PF   =filtfilt(b, 1,  L1_Dist_PF);
            L1_Dist_PF3   =filtfilt(b3, 1, L1_Dist_PF_unfiltered);
            
            PFoutcr=linspace(0,4,2000);
            cfreq_PF_L1=zeros(1,length(PFoutcr));
            for t=1:length(PFoutcr)
                index = find(L1_Dist_PF >= PFoutcr(t));
                count=length(index);
                cfreq_PF_L1(t)=count/1800;
            end
    
            L1_Y_PF_Dist=L1_Pin_Y-L1_Fl_Y;
        end
    
        load (PinFlange2)
        for i=1
            %rename XYZ
            L2_Pin_X=BlPinXl;
            L2_Pin_Y=BlPinYl;
            L2_Pin_Z=BlPinZ;
            L2_Fl_X=HubFlXl;
            L2_Fl_Y=HubFlYl;
            L2_Fl_Z=HubFlZ;
    
            %means
            L2_MeanPinX=mean(L2_Pin_X);
            L2_MeanPinY=mean(L2_Pin_Y);
            L2_meandriftpX=pXl-L2_MeanPinX;
            L2_meandriftpY=pYl-L2_MeanPinY;
            L2_MeanFlX=mean(L2_Fl_X);
            L2_MeanFlY=mean(L2_Fl_Y);
            L2_meandriftFlX=fXl-L2_MeanFlX;
            L2_meandriftFlY=fYl-L2_MeanFlY;
    
            %motion radius
            L2_PinPos=[L2_Pin_X L2_Pin_Z];
            L2_meanPinPos=mean(L2_PinPos);
            L2_Pin_Radius=zeros(length(L2_Pin_X),1);
            for m=1:length(L2_Pin_X)
                L2_Pin_Radius(m)=norm(L2_PinPos(m,:)-L2_meanPinPos);
            end
            % Apply high-pass filter
            L2_Pin_Radius = filtfilt(b, 1, L2_Pin_Radius);
            
            
            Pinoutcr=linspace(0,1.5,2000);
            cfreq_Pin_L2=zeros(1,length(Pinoutcr));
            for t=1:length(Pinoutcr)
                index = find(L2_Pin_Radius >= Pinoutcr(t));
                count=length(index);
                cfreq_Pin_L2(t)=count/1800;
            end
    
            L2_FlPos=[L2_Fl_X L2_Fl_Z];
            L2_meanFlPos=mean(L2_FlPos);
            L2_Fl_Radius=zeros(length(L2_Fl_X),1);
            for m=1:length(L2_Fl_X)
                L2_Fl_Radius(m)=norm(L2_FlPos(m,:)-L2_meanFlPos);
            end
            % Apply high-pass filter
            L2_Fl_Radius = filtfilt(b, 1, L2_Fl_Radius);
            
            Floutcr=linspace(0,4,2000);
            cfreq_Fl_L2=zeros(1,length(Floutcr));
            for t=1:length(Floutcr)
                index = find(L2_Fl_Radius >= Floutcr(t));
                count=length(index);
                cfreq_Fl_L2(t)=count/1800;
            end
    
            %relative motions
            L2_Dist_PF=zeros(length(L2_Pin_X),1);
            for m=1:length(L2_Pin_X)
                L2_Dist_PF(m)=norm(L2_PinPos(m,:)-L2_FlPos(m,:));
            end
            % Apply high-pass filter
            L2_Dist_PF = filtfilt(b, 1, L2_Dist_PF);
    
            PFoutcr=linspace(0,4,2000);
            cfreq_PF_L2=zeros(1,length(PFoutcr));
            for t=1:length(PFoutcr)
                index = find(L2_Dist_PF >= PFoutcr(t));
                count=length(index);
                cfreq_PF_L2(t)=count/1800;
            end
    
            L2_Y_PF_Dist=L2_Pin_Y-L2_Fl_Y;
        end
    
        load (PinFlange3)
        for i=1
            %rename XYZ
            L3_Pin_X=BlPinXl;
            L3_Pin_Y=BlPinYl;
            L3_Pin_Z=BlPinZ;
            L3_Fl_X=HubFlXl;
            L3_Fl_Y=HubFlYl;
            L3_Fl_Z=HubFlZ;
    
            %means
            L3_MeanPinX=mean(L3_Pin_X);
            L3_MeanPinY=mean(L3_Pin_Y);
            L3_meandriftpX=pXl-L3_MeanPinX;
            L3_meandriftpY=pYl-L3_MeanPinY;
            L3_MeanFlX=mean(L3_Fl_X);
            L3_MeanFlY=mean(L3_Fl_Y);
            L3_meandriftFlX=fXl-L3_MeanFlX;
            L3_meandriftFlY=fYl-L3_MeanFlY;
    
            %motion radius
            L3_PinPos=[L3_Pin_X L3_Pin_Z];
            L3_meanPinPos=mean(L3_PinPos);
            L3_Pin_Radius=zeros(length(L3_Pin_X),1);
            for m=1:length(L3_Pin_X)
                L3_Pin_Radius(m)=norm(L3_PinPos(m,:)-L3_meanPinPos);
            end
            % Apply high-pass filter
            L3_Pin_Radius = filtfilt(b, 1, L3_Pin_Radius);
    
            Pinoutcr=linspace(0,1.5,2000);
            cfreq_Pin_L3=zeros(1,length(Pinoutcr));
            for t=1:length(Pinoutcr)
                index = find(L3_Pin_Radius >= Pinoutcr(t));
                count=length(index);
                cfreq_Pin_L3(t)=count/1800;
            end
    
            L3_FlPos=[L3_Fl_X L3_Fl_Z];
            L3_meanFlPos=mean(L3_FlPos);
            L3_Fl_Radius=zeros(length(L3_Fl_X),1);
            for m=1:length(L3_Fl_X)
                L3_Fl_Radius(m)=norm(L3_FlPos(m,:)-L3_meanFlPos);
            end
            % Apply high-pass filter
            L3_Fl_Radius = filtfilt(b, 1, L3_Fl_Radius);
    
            Floutcr=linspace(0,4,2000);
            cfreq_Fl_L3=zeros(1,length(Floutcr));
            for t=1:length(Floutcr)
                index = find(L3_Fl_Radius >= Floutcr(t));
                count=length(index);
                cfreq_Fl_L3(t)=count/1800;
            end
    
            %relative motions
            L3_Dist_PF=zeros(length(L3_Pin_X),1);
            for m=1:length(L3_Pin_X)
                L3_Dist_PF(m)=norm(L3_PinPos(m,:)-L3_FlPos(m,:));
            end
            % Apply high-pass filter
            L3_Dist_PF = filtfilt(b, 1, L3_Dist_PF);
    
            PFoutcr=linspace(0,4,2000);
            cfreq_PF_L3=zeros(1,length(PFoutcr));
            for t=1:length(PFoutcr)
                index = find(L3_Dist_PF >= PFoutcr(t));
                count=length(index);
                cfreq_PF_L3(t)=count/1800;
            end
    
            L3_Y_PF_Dist=L3_Pin_Y-L3_Fl_Y;
        end
    
        load (PinFlange4)
        for i=1
            %rename XYZ
            L4_Pin_X=BlPinXl;
            L4_Pin_Y=BlPinYl;
            L4_Pin_Z=BlPinZ;
            L4_Fl_X=HubFlXl;
            L4_Fl_Y=HubFlYl;
            L4_Fl_Z=HubFlZ;
    
            %means
            L4_MeanPinX=mean(L4_Pin_X);
            L4_MeanPinY=mean(L4_Pin_Y);
            L4_meandriftpX=pXl-L4_MeanPinX;
            L4_meandriftpY=pYl-L4_MeanPinY;
            L4_MeanFlX=mean(L4_Fl_X);
            L4_MeanFlY=mean(L4_Fl_Y);
            L4_meandriftFlX=fXl-L4_MeanFlX;
            L4_meandriftFlY=fYl-L4_MeanFlY;
    
            %motion radius
            L4_PinPos=[L4_Pin_X L4_Pin_Z];
            L4_meanPinPos=mean(L4_PinPos);
            L4_Pin_Radius=zeros(length(L4_Pin_X),1);
            for m=1:length(L4_Pin_X)
                L4_Pin_Radius(m)=norm(L4_PinPos(m,:)-L4_meanPinPos);
            end
            % Apply high-pass filter
            L4_Pin_Radius = filtfilt(b, 1, L4_Pin_Radius);
            
            Pinoutcr=linspace(0,1.5,2000);
            cfreq_Pin_L4=zeros(1,length(Pinoutcr));
            for t=1:length(Pinoutcr)
                index = find(L4_Pin_Radius >= Pinoutcr(t));
                count=length(index);
                cfreq_Pin_L4(t)=count/1800;
            end
    
            L4_FlPos=[L4_Fl_X L4_Fl_Z];
            L4_meanFlPos=mean(L4_FlPos);
            L4_Fl_Radius=zeros(length(L4_Fl_X),1);
            for m=1:length(L4_Fl_X)
                L4_Fl_Radius(m)=norm(L4_FlPos(m,:)-L4_meanFlPos);
            end
            % Apply high-pass filter
            L4_Fl_Radius = filtfilt(b, 1, L4_Fl_Radius);
            
            Floutcr=linspace(0,4,2000);
            cfreq_Fl_L4=zeros(1,length(Floutcr));
            for t=1:length(Floutcr)
                index = find(L4_Fl_Radius >= Floutcr(t));
                count=length(index);
                cfreq_Fl_L4(t)=count/1800;
            end
    
            %relative motions
            L4_Dist_PF=zeros(length(L4_Pin_X),1);
            for m=1:length(L4_Pin_X)
                L4_Dist_PF(m)=norm(L4_PinPos(m,:)-L4_FlPos(m,:));
            end
            % Apply high-pass filter
            L4_Dist_PF = filtfilt(b, 1, L4_Dist_PF);
    
            PFoutcr=linspace(0,4,2000);
            cfreq_PF_L4=zeros(1,length(PFoutcr));
            for t=1:length(PFoutcr)
                index = find(L4_Dist_PF >= PFoutcr(t));
                count=length(index);
                cfreq_PF_L4(t)=count/1800;
            end
    
            L4_Y_PF_Dist=L4_Pin_Y-L4_Fl_Y;
        end
    
        load (PinFlange5)
        for i=1
            %rename XYZ
            L5_Pin_X=BlPinXl;
            L5_Pin_Y=BlPinYl;
            L5_Pin_Z=BlPinZ;
            L5_Fl_X=HubFlXl;
            L5_Fl_Y=HubFlYl;
            L5_Fl_Z=HubFlZ;
    
            %means
            L5_MeanPinX=mean(L5_Pin_X);
            L5_MeanPinY=mean(L5_Pin_Y);
            L5_meandriftpX=pXl-L5_MeanPinX;
            L5_meandriftpY=pYl-L5_MeanPinY;
            L5_MeanFlX=mean(L5_Fl_X);
            L5_MeanFlY=mean(L5_Fl_Y);
            L5_meandriftFlX=fXl-L5_MeanFlX;
            L5_meandriftFlY=fYl-L5_MeanFlY;
    
            %motion radius
            L5_PinPos=[L5_Pin_X L5_Pin_Z];
            L5_meanPinPos=mean(L5_PinPos);
            L5_Pin_Radius=zeros(length(L5_Pin_X),1);
            for m=1:length(L5_Pin_X)
                L5_Pin_Radius(m)=norm(L5_PinPos(m,:)-L5_meanPinPos);
            end
            % Apply high-pass filter
            L5_Pin_Radius = filtfilt(b, 1, L5_Pin_Radius);
    
            Pinoutcr=linspace(0,1.5,2000);
            cfreq_Pin_L5=zeros(1,length(Pinoutcr));
            for t=1:length(Pinoutcr)
                index = find(L5_Pin_Radius >= Pinoutcr(t));
                count=length(index);
                cfreq_Pin_L5(t)=count/1800;
            end
    
            L5_FlPos=[L5_Fl_X L5_Fl_Z];
            L5_meanFlPos=mean(L5_FlPos);
            L5_Fl_Radius=zeros(length(L5_Fl_X),1);
            for m=1:length(L5_Fl_X)
                L5_Fl_Radius(m)=norm(L5_FlPos(m,:)-L5_meanFlPos);
            end
            % Apply high-pass filter
            L5_Fl_Radius = filtfilt(b, 1, L5_Fl_Radius);
    
            Floutcr=linspace(0,4,2000);
            cfreq_Fl_L5=zeros(1,length(Floutcr));
            for t=1:length(Floutcr)
                index = find(L5_Fl_Radius >= Floutcr(t));
                count=length(index);
                cfreq_Fl_L5(t)=count/1800;
            end
    
            %relative motions
            L5_Dist_PF=zeros(length(L5_Pin_X),1);
            for m=1:length(L5_Pin_X)
                L5_Dist_PF(m)=norm(L5_PinPos(m,:)-L5_FlPos(m,:));
            end
            % Apply high-pass filter
            L5_Dist_PF = filtfilt(b, 1, L5_Dist_PF);
    
            PFoutcr=linspace(0,4,2000);
            cfreq_PF_L5=zeros(1,length(PFoutcr));
            for t=1:length(PFoutcr)
                index = find(L5_Dist_PF >= PFoutcr(t));
                count=length(index);
                cfreq_PF_L5(t)=count/1800;
            end
    
            L5_Y_PF_Dist=L5_Pin_Y-L5_Fl_Y;
        end
    
        load (PinFlange6)
        for i=1
            %rename XYZ
            L6_Pin_X=BlPinXl;
            L6_Pin_Y=BlPinYl;
            L6_Pin_Z=BlPinZ;
            L6_Fl_X=HubFlXl;
            L6_Fl_Y=HubFlYl;
            L6_Fl_Z=HubFlZ;
    
            %means
            L6_MeanPinX=mean(L6_Pin_X);
            L6_MeanPinY=mean(L6_Pin_Y);
            L6_meandriftpX=pXl-L6_MeanPinX;
            L6_meandriftpY=pYl-L6_MeanPinY;
            L6_MeanFlX=mean(L6_Fl_X);
            L6_MeanFlY=mean(L6_Fl_Y);
            L6_meandriftFlX=fXl-L6_MeanFlX;
            L6_meandriftFlY=fYl-L6_MeanFlY;
    
            %motion radius
            L6_PinPos=[L6_Pin_X L6_Pin_Z];
            L6_meanPinPos=mean(L6_PinPos);
            L6_Pin_Radius=zeros(length(L6_Pin_X),1);
            for m=1:length(L6_Pin_X)
                L6_Pin_Radius(m)=norm(L6_PinPos(m,:)-L6_meanPinPos);
            end
            % Apply high-pass filter
            L6_Pin_Radius = filtfilt(b, 1, L6_Pin_Radius);
    
            Pinoutcr=linspace(0,1.5,2000);
            cfreq_Pin_L6=zeros(1,length(Pinoutcr));
            for t=1:length(Pinoutcr)
                index = find(L6_Pin_Radius >= Pinoutcr(t));
                count=length(index);
                cfreq_Pin_L6(t)=count/1800;
            end
    
            L6_FlPos=[L6_Fl_X L6_Fl_Z];
            L6_meanFlPos=mean(L6_FlPos);
            L6_Fl_Radius=zeros(length(L6_Fl_X),1);
            for m=1:length(L6_Fl_X)
                L6_Fl_Radius(m)=norm(L6_FlPos(m,:)-L6_meanFlPos);
            end
            % Apply high-pass filter
            L6_Fl_Radius = filtfilt(b, 1, L6_Fl_Radius);
    
            Floutcr=linspace(0,4,2000);
            cfreq_Fl_L6=zeros(1,length(Floutcr));
            for t=1:length(Floutcr)
                index = find(L6_Fl_Radius >= Floutcr(t));
                count=length(index);
                cfreq_Fl_L6(t)=count/1800;
            end
    
            %relative motions
            L6_Dist_PF=zeros(length(L6_Pin_X),1);
            for m=1:length(L6_Pin_X)
                L6_Dist_PF(m)=norm(L6_PinPos(m,:)-L6_FlPos(m,:));
            end
            % Apply high-pass filter
            L6_Dist_PF = filtfilt(b, 1, L6_Dist_PF);
    
            PFoutcr=linspace(0,4,2000);
            cfreq_PF_L6=zeros(1,length(PFoutcr));
            for t=1:length(PFoutcr)
                index = find(L6_Dist_PF >= PFoutcr(t));
                count=length(index);
                cfreq_PF_L6(t)=count/1800;
            end
    
            L6_Y_PF_Dist=L6_Pin_Y-L6_Fl_Y;
        end
    
        % ncrit plot
        vcr2=1.67*10^(-2);
        for q=1
            cfreq_Pin_all=[cfreq_Pin_L1; cfreq_Pin_L2; cfreq_Pin_L3; cfreq_Pin_L4;cfreq_Pin_L5;cfreq_Pin_L6];
            cfreq_Pin=mean(cfreq_Pin_all);
            temp = abs(vcr2 - cfreq_Pin); % Temporary "distances" array.
            nbcr_Pins = Pinoutcr(find(temp == min(abs(vcr2 - cfreq_Pin)))); % Find "closest" values array wrt. target value.
            nbcr_Pin = nbcr_Pins(1);
    
            cfreq_Fl_all=[cfreq_Fl_L1; cfreq_Fl_L2; cfreq_Fl_L3; cfreq_Fl_L4;cfreq_Fl_L5;cfreq_Fl_L6];
            cfreq_Fl=mean(cfreq_Fl_all);
            temp = abs(vcr2 - cfreq_Fl); % Temporary "distances" array.
            nbcr_Fls = Floutcr(find(temp == min(abs(vcr2 - cfreq_Fl)))); % Find "closest" values array wrt. target value.
            nbcr_Fl = nbcr_Fls(1);
    
            cfreq_PF_all=[cfreq_PF_L1; cfreq_PF_L2; cfreq_PF_L3; cfreq_PF_L4;cfreq_PF_L5;cfreq_PF_L6];
            cfreq_PF=mean(cfreq_PF_all);
            temp = abs(vcr2 - cfreq_PF); % Temporary "distances" array.
            nbcr_PFs = PFoutcr(find(temp == min(abs(vcr2 - cfreq_PF)))); % Find "closest" values array wrt. target value.
            nbcr_PF = nbcr_PFs(1);
    
            nbcrs_PF = [nbcr_Pin,nbcr_Fl,nbcr_PF]
    
            yPi=cfreq_Pin(find(Pinoutcr==nbcr_Pin));
            yFl=cfreq_Fl(find(Floutcr==nbcr_Fl));
            yPF=cfreq_PF(find(PFoutcr==nbcr_PF));
            Pileg=['Pin \eta_p= ' num2str(nbcr_Pin) 'm'];
            Fleg=['Flange \eta_h= ' num2str(nbcr_Fl) 'm'];
            PFleg=['Relative motion \eta_{pf}= ' num2str(nbcr_PF) 'm'];
            nctit=['Variation in the outcrossing rate with motion radius for LC ' x];
    
            figure()
            plot(Pinoutcr,cfreq_Pin,"k.", 'HandleVisibility','off'); hold on
            grid on
            grid minor
            plot(Floutcr,cfreq_Fl,"k.", 'HandleVisibility','off');
            plot(PFoutcr,cfreq_PF,"k.", 'HandleVisibility','off');
            pPin=plot(nbcr_Pin,yPi,'Color','r','Marker','o', 'DisplayName', Pileg);
            pFl=plot(nbcr_Fl,yFl,'Color','r','Marker','^', 'DisplayName', Fleg);
            pPF=plot(nbcr_PF,yPF,'Color','r','Marker','square', 'DisplayName', PFleg);
            xlabel('Motion radius \eta [m]')
            ylabel('Barrier of the outcrossing rate \nu [Hz]')
            set(gca, 'YScale', 'log')
            title(nctit)
            ylim([0 10^-1])
            legend show
    
    
        end
    
        %xz plots
        for k=1
            % figure()
            % subplot(2,3,1)
            % plot(L1_Fl_X, L1_Fl_Z,L1_Pin_X,L1_Pin_Z);
            % xlabel('global x position [m]')
            % ylabel('global z position [m]')
            % circle(L1_MeanPinX,mean(L1_Pin_Z),PinDia/2);
            % circle(L1_MeanFlX,mean(L1_Fl_Z),FlDia/2);
            % legend('Flange pos','Pin pos','Flange','Pin')
            %
            % subplot(2,3,2)
            % plot(L2_Fl_X, L2_Fl_Z,L2_Pin_X,L2_Pin_Z);
            % xlabel('global x position [m]')
            % ylabel('global z position [m]')
            % circle(L2_MeanPinX,mean(L2_Pin_Z),PinDia/2);
            % circle(L2_MeanFlX,mean(L2_Fl_Z),FlDia/2);
            % legend('Flange pos','Pin pos','Flange','Pin')
            %
            % subplot(2,3,3)
            % plot(L3_Fl_X, L3_Fl_Z,L3_Pin_X,L3_Pin_Z);
            % xlabel('global x position [m]')
            % ylabel('global z position [m]')
            % circle(L3_MeanPinX,mean(L3_Pin_Z),PinDia/2);
            % circle(L3_MeanFlX,mean(L3_Fl_Z),FlDia/2);
            % legend('Flange pos','Pin pos','Flange','Pin')
            %
            % subplot(2,3,4)
            % plot(L4_Fl_X, L4_Fl_Z,L4_Pin_X,L4_Pin_Z);
            % xlabel('global x position [m]')
            % ylabel('global z position [m]')
            % circle(L4_MeanPinX,mean(L4_Pin_Z),PinDia/2);
            % circle(L4_MeanFlX,mean(L4_Fl_Z),FlDia/2);
            % legend('Flange pos','Pin pos','Flange','Pin')
            %
            % subplot(2,3,5)
            % plot(L5_Fl_X, L5_Fl_Z,L5_Pin_X,L5_Pin_Z);
            % xlabel('global x position [m]')
            % ylabel('global z position [m]')
            % circle(L5_MeanPinX,mean(L5_Pin_Z),PinDia/2);
            % circle(L5_MeanFlX,mean(L5_Fl_Z),FlDia/2);
            % legend('Flange pos','Pin pos','Flange','Pin')
            %
            %
            % subplot(2,3,6)
            % plot(L6_Fl_X, L6_Fl_Z,L6_Pin_X,L6_Pin_Z);
            % xlabel('global x position [m]')
            % ylabel('global z position [m]')
            % circle(L6_MeanPinX,mean(L6_Pin_Z),PinDia/2);
            % circle(L6_MeanFlX,mean(L6_Fl_Z),FlDia/2);
            % legend('Flange pos','Pin pos','Flange','Pin')
    
            %figure()
            %plot3(L1_BR_X,L1_BR_Y,L1_BR_Z,L1_H_X,L1_H_Y ,L1_H_Z)
    end
    
        drifts_PF=[L1_meandriftpX L1_meandriftpY L1_meandriftFlX L1_meandriftFlY;L2_meandriftpX L2_meandriftpY L2_meandriftFlX L2_meandriftFlY;L3_meandriftpX L3_meandriftpY L3_meandriftFlX L3_meandriftFlY;L4_meandriftpX L4_meandriftpY L4_meandriftFlX L4_meandriftFlY;L5_meandriftpX L5_meandriftpY L5_meandriftFlX L5_meandriftFlY;L6_meandriftpX L6_meandriftpY L6_meandriftFlX L6_meandriftFlY];
    
        Dists_PF=[L1_Dist_PF L2_Dist_PF L3_Dist_PF L4_Dist_PF L5_Dist_PF L6_Dist_PF];
    
        Y_Dists_PF=[L1_Y_PF_Dist L2_Y_PF_Dist L3_Y_PF_Dist L4_Y_PF_Dist L5_Y_PF_Dist L6_Y_PF_Dist];
    
        %dist plots
        for p=1
%             figure()
%             subplot(2,3,1)
%             plot(timeRif,Dists_PF(:,1));
%             xlabel('time [s]')
%             ylabel('distance in x-z plane [m]')
%             yline(D_crit_PF,'--r')
%     
%             subplot(2,3,2)
%             plot(timeRif,Dists_PF(:,2));
%             xlabel('time [s]')
%             ylabel('distance in x-z plane [m]')
%             yline(D_crit_PF,'--r')
%     
%     
%             subplot(2,3,3)
%             plot(timeRif,Dists_PF(:,3));
%             xlabel('time [s]')
%             ylabel('distance in x-z plane [m]')
%             yline(D_crit_PF,'--r')
%     
%     
%             subplot(2,3,4)
%             plot(timeRif,Dists_PF(:,4));
%             xlabel('time [s]')
%             ylabel('distance in x-z plane [m]')
%             yline(D_crit_PF,'--r')
%     
%             subplot(2,3,5)
%             plot(timeRif,Dists_PF(:,5));
%             xlabel('time [s]')
%             ylabel('distance in x-z plane [m]')
%             yline(D_crit_PF,'--r')
%     
%     
%             subplot(2,3,6)
%             plot(timeRif,Dists_PF(:,6));
%             xlabel('time [s]')
%             ylabel('distance in x-z plane [m]')
%             yline(D_crit_PF,'--r')
%     
        end
end


%% Saving
Y_DistsMin=min(Y_Dists);
saveName=['E:\MatlabFiles\MatFiles_newruns\Results/Outcomes_' x '.mat'];
save (saveName, 'drifts', 'driftsS', 'Dists','drifts_PF', 'Dists_PF','nbcrs','nbcrs_PF','Y_DistsMin','Stats')%
%save (saveName, 'drifts', 'driftsS', 'Dists','nbcrs','Y_DistsMin','Stats')


%% PSDs

%Blade & Hub
for i=1
    BladeRadius_L1=sqrt(L1_BR_X.^2+L1_BR_Z.^2);
    HubRadius_L1=sqrt(L1_H_X.^2+L1_H_Z.^2);
    [fpsd_B_L1, psd_B_L1] = Power_Spectral_Density(timeRif,BladeRadius_L1);
    [fpsd_H_L1, psd_H_L1] = Power_Spectral_Density(timeRif,HubRadius_L1);
    
    [fpsd_D_L1, psd_D_L1] = Power_Spectral_Density(timeRif,Dists(:,1));
    [fpsd_D_L2, psd_D_L2] = Power_Spectral_Density(timeRif,Dists(:,2));
    [fpsd_D_L3, psd_D_L3] = Power_Spectral_Density(timeRif,Dists(:,3));
    [fpsd_D_L4, psd_D_L4] = Power_Spectral_Density(timeRif,Dists(:,4));
    [fpsd_D_L5, psd_D_L5] = Power_Spectral_Density(timeRif,Dists(:,5));
    [fpsd_D_L6, psd_D_L6] = Power_Spectral_Density(timeRif,Dists(:,6));
    
    [fpsd_B_Su_L1, psd_B_Su_L1] = Power_Spectral_Density(time,L1_B_X);
    [fpsd_B_Sw_L1, psd_B_Sw_L1] = Power_Spectral_Density(time,L1_B_Y);
    [fpsd_B_Yw_L1, psd_B_Yw_L1] = Power_Spectral_Density(time,L1_B_Zr);
    
    [fpsd_BR_X_L1, psd_BR_X_L1] = Power_Spectral_Density(timeRif,L1_BR_X);
    [fpsd_BR_Z_L1, psd_BR_Z_L1] = Power_Spectral_Density(timeRif,L1_BR_Z);
    [fpsd_H_X_L1, psd_H_X_L1] = Power_Spectral_Density(timeRif,L1_H_X);
    [fpsd_H_Z_L1, psd_H_Z_L1] = Power_Spectral_Density(timeRif,L1_H_Z);
    [fpsd_H_Y_L1, psd_H_Y_L1] = Power_Spectral_Density(timeRif,L1_H_Y);
    
    BladeRadius_L2=sqrt(L2_BR_X.^2+L2_BR_Z.^2);
    HubRadius_L2=sqrt(L2_H_X.^2+L2_H_Z.^2);
    [fpsd_B_L2, psd_B_L2] = Power_Spectral_Density(timeRif,BladeRadius_L2);
    [fpsd_H_L2, psd_H_L2] = Power_Spectral_Density(timeRif,HubRadius_L2);
    
    [fpsd_B_Su_L2, psd_B_Su_L2] = Power_Spectral_Density(time,L2_B_X);
    [fpsd_B_Sw_L2, psd_B_Sw_L2] = Power_Spectral_Density(time,L2_B_Y);
    [fpsd_B_Yw_L2, psd_B_Yw_L2] = Power_Spectral_Density(time,L2_B_Zr);
    
    [fpsd_BR_X_L2, psd_BR_X_L2] = Power_Spectral_Density(timeRif,L2_BR_X);
    [fpsd_BR_Z_L2, psd_BR_Z_L2] = Power_Spectral_Density(timeRif,L2_BR_Z);
    [fpsd_H_X_L2, psd_H_X_L2] = Power_Spectral_Density(timeRif,L2_H_X);
    [fpsd_H_Z_L2, psd_H_Z_L2] = Power_Spectral_Density(timeRif,L2_H_Z);
    [fpsd_H_Y_L2, psd_H_Y_L2] = Power_Spectral_Density(timeRif,L2_H_Y);
    
    BladeRadius_L3=sqrt(L3_BR_X.^2+L3_BR_Z.^2);
    HubRadius_L3=sqrt(L3_H_X.^2+L3_H_Z.^2);
    [fpsd_B_L3, psd_B_L3] = Power_Spectral_Density(timeRif,BladeRadius_L3);
    [fpsd_H_L3, psd_H_L3] = Power_Spectral_Density(timeRif,HubRadius_L3);
    
    [fpsd_B_Su_L3, psd_B_Su_L3] = Power_Spectral_Density(time,L3_B_X);
    [fpsd_B_Sw_L3, psd_B_Sw_L3] = Power_Spectral_Density(time,L3_B_Y);
    [fpsd_B_Yw_L3, psd_B_Yw_L3] = Power_Spectral_Density(time,L3_B_Zr);
    
    [fpsd_BR_X_L3, psd_BR_X_L3] = Power_Spectral_Density(timeRif,L3_BR_X);
    [fpsd_BR_Z_L3, psd_BR_Z_L3] = Power_Spectral_Density(timeRif,L3_BR_Z);
    [fpsd_H_X_L3, psd_H_X_L3] = Power_Spectral_Density(timeRif,L3_H_X);
    [fpsd_H_Z_L3, psd_H_Z_L3] = Power_Spectral_Density(timeRif,L3_H_Z);
    [fpsd_H_Y_L3, psd_H_Y_L3] = Power_Spectral_Density(timeRif,L3_H_Y);
    
    BladeRadius_L4=sqrt(L4_BR_X.^2+L4_BR_Z.^2);
    HubRadius_L4=sqrt(L4_H_X.^2+L4_H_Z.^2);
    [fpsd_B_L4, psd_B_L4] = Power_Spectral_Density(timeRif,BladeRadius_L4);
    [fpsd_H_L4, psd_H_L4] = Power_Spectral_Density(timeRif,HubRadius_L4);
    
    [fpsd_B_Su_L4, psd_B_Su_L4] = Power_Spectral_Density(time,L4_B_X);
    [fpsd_B_Sw_L4, psd_B_Sw_L4] = Power_Spectral_Density(time,L4_B_Y);
    [fpsd_B_Yw_L4, psd_B_Yw_L4] = Power_Spectral_Density(time,L4_B_Zr);
    
    [fpsd_BR_X_L4, psd_BR_X_L4] = Power_Spectral_Density(timeRif,L4_BR_X);
    [fpsd_BR_Z_L4, psd_BR_Z_L4] = Power_Spectral_Density(timeRif,L4_BR_Z);
    [fpsd_H_X_L4, psd_H_X_L4] = Power_Spectral_Density(timeRif,L4_H_X);
    [fpsd_H_Z_L4, psd_H_Z_L4] = Power_Spectral_Density(timeRif,L4_H_Z);
    [fpsd_H_Y_L4, psd_H_Y_L4] = Power_Spectral_Density(timeRif,L4_H_Y);
    
    BladeRadius_L5=sqrt(L5_BR_X.^2+L5_BR_Z.^2);
    HubRadius_L5=sqrt(L5_H_X.^2+L5_H_Z.^2);
    [fpsd_B_L5, psd_B_L5] = Power_Spectral_Density(timeRif,BladeRadius_L5);
    [fpsd_H_L5, psd_H_L5] = Power_Spectral_Density(timeRif,HubRadius_L5);
    
    [fpsd_B_Su_L5, psd_B_Su_L5] = Power_Spectral_Density(time,L5_B_X);
    [fpsd_B_Sw_L5, psd_B_Sw_L5] = Power_Spectral_Density(time,L5_B_Y);
    [fpsd_B_Yw_L5, psd_B_Yw_L5] = Power_Spectral_Density(time,L5_B_Zr);
    
    [fpsd_BR_X_L5, psd_BR_X_L5] = Power_Spectral_Density(timeRif,L5_BR_X);
    [fpsd_BR_Z_L5, psd_BR_Z_L5] = Power_Spectral_Density(timeRif,L5_BR_Z);
    [fpsd_H_X_L5, psd_H_X_L5] = Power_Spectral_Density(timeRif,L5_H_X);
    [fpsd_H_Z_L5, psd_H_Z_L5] = Power_Spectral_Density(timeRif,L5_H_Z);
    [fpsd_H_Y_L5, psd_H_Y_L5] = Power_Spectral_Density(timeRif,L5_H_Y);
    
    BladeRadius_L6=sqrt(L6_BR_X.^2+L6_BR_Z.^2);
    HubRadius_L6=sqrt(L6_H_X.^2+L6_H_Z.^2);
    [fpsd_B_L6, psd_B_L6] = Power_Spectral_Density(timeRif,BladeRadius_L6);
    [fpsd_H_L6, psd_H_L6] = Power_Spectral_Density(timeRif,HubRadius_L6);
    
    [fpsd_B_Su_L6, psd_B_Su_L6] = Power_Spectral_Density(time,L6_B_X);
    [fpsd_B_Sw_L6, psd_B_Sw_L6] = Power_Spectral_Density(time,L6_B_Y);
    [fpsd_B_Yw_L6, psd_B_Yw_L6] = Power_Spectral_Density(time,L6_B_Zr);
    
    [fpsd_BR_X_L6, psd_BR_X_L6] = Power_Spectral_Density(timeRif,L6_BR_X);
    [fpsd_BR_Z_L6, psd_BR_Z_L6] = Power_Spectral_Density(timeRif,L6_BR_Z);
    [fpsd_H_X_L6, psd_H_X_L6] = Power_Spectral_Density(timeRif,L6_H_X);
    [fpsd_H_Z_L6, psd_H_Z_L6] = Power_Spectral_Density(timeRif,L6_H_Z);
    [fpsd_H_Y_L6, psd_H_Y_L6] = Power_Spectral_Density(timeRif,L6_H_Y);
    
    fpsd_B=[fpsd_B_L1;fpsd_B_L2;fpsd_B_L3;fpsd_B_L4;fpsd_B_L5;fpsd_B_L6];
    fpsd_B=mean(fpsd_B);
    fpsd_H=[fpsd_H_L1;fpsd_H_L2;fpsd_H_L3;fpsd_H_L4;fpsd_H_L5;fpsd_H_L6];
    fpsd_H=mean(fpsd_H);
    fpsd_D=[fpsd_D_L1;fpsd_D_L2;fpsd_D_L3;fpsd_D_L4;fpsd_D_L5;fpsd_D_L6];
    fpsd_D=mean(fpsd_D);
    fpsd_B_Su=[fpsd_B_Su_L1;fpsd_B_Su_L2;fpsd_B_Su_L3;fpsd_B_Su_L4;fpsd_B_Su_L5;fpsd_B_Su_L6];
    fpsd_B_Su=mean(fpsd_B_Su);
    fpsd_B_Sw=[fpsd_B_Sw_L1;fpsd_B_Sw_L2;fpsd_B_Sw_L3;fpsd_B_Sw_L4;fpsd_B_Sw_L5;fpsd_B_Sw_L6];
    fpsd_B_Sw=mean(fpsd_B_Sw);
    fpsd_B_Yw=[fpsd_B_Yw_L1;fpsd_B_Yw_L2;fpsd_B_Yw_L3;fpsd_B_Yw_L4;fpsd_B_Yw_L5;fpsd_B_Yw_L6];
    fpsd_B_Yw=mean(fpsd_B_Yw);
    fpsd_BR_X=[fpsd_BR_X_L1;fpsd_BR_X_L2;fpsd_BR_X_L3;fpsd_BR_X_L4;fpsd_BR_X_L5;fpsd_BR_X_L6];
    fpsd_BR_X=mean(fpsd_BR_X);
    fpsd_BR_Z=[fpsd_BR_Z_L1;fpsd_BR_Z_L2;fpsd_BR_Z_L3;fpsd_BR_Z_L4;fpsd_BR_Z_L5;fpsd_BR_Z_L6];
    fpsd_BR_Z=mean(fpsd_BR_Z);
    fpsd_H_X=[fpsd_H_X_L1;fpsd_H_X_L2;fpsd_H_X_L3;fpsd_H_X_L4;fpsd_H_X_L5;fpsd_H_X_L6];
    fpsd_H_X=mean(fpsd_H_X);
    fpsd_H_Z=[fpsd_H_Z_L1;fpsd_H_Z_L2;fpsd_H_Z_L3;fpsd_H_Z_L4;fpsd_H_Z_L5;fpsd_H_Z_L6];
    fpsd_H_Z=mean(fpsd_H_Z);
    fpsd_H_Y=[fpsd_H_Y_L1;fpsd_H_Y_L2;fpsd_H_Y_L3;fpsd_H_Y_L4;fpsd_H_Y_L5;fpsd_H_Y_L6];
    fpsd_H_Y=mean(fpsd_H_Y);
    psd_B=[psd_B_L1, psd_B_L2, psd_B_L3, psd_B_L4, psd_B_L5, psd_B_L6];
    psd_B=smooth(mean(psd_B,2));
    psd_H=[psd_H_L1, psd_H_L2, psd_H_L3, psd_H_L4, psd_H_L5, psd_H_L6];
    psd_H=smooth(mean(psd_H,2));
    psd_D=[psd_D_L1, psd_D_L2, psd_D_L3, psd_D_L4, psd_D_L5, psd_D_L6];
    psd_D=smooth(mean(psd_D,2));
    psd_B_Su=[psd_B_Su_L1,psd_B_Su_L2,psd_B_Su_L3,psd_B_Su_L4,psd_B_Su_L5,psd_B_Su_L6];
    psd_B_Su=smooth(mean(psd_B_Su,2));
    psd_B_Sw=[psd_B_Sw_L1,psd_B_Sw_L2,psd_B_Sw_L3,psd_B_Sw_L4,psd_B_Sw_L5,psd_B_Sw_L6];
    psd_B_Sw=smooth(mean(psd_B_Sw,2));
    psd_B_Yw=[psd_B_Yw_L1,psd_B_Yw_L2,psd_B_Yw_L3,psd_B_Yw_L4,psd_B_Yw_L5,psd_B_Yw_L6];
    psd_B_Yw=smooth(mean(psd_B_Yw,2));
    psd_BR_X=[psd_BR_X_L1,psd_BR_X_L2,psd_BR_X_L3,psd_BR_X_L4,psd_BR_X_L5,psd_BR_X_L6];
    psd_BR_X=smooth(mean(psd_BR_X,2));
    psd_BR_Z=[psd_BR_Z_L1,psd_BR_Z_L2,psd_BR_Z_L3,psd_BR_Z_L4,psd_BR_Z_L5,psd_BR_Z_L6];
    psd_BR_Z=smooth(mean(psd_BR_Z,2));
    psd_H_X=[psd_H_X_L1,psd_H_X_L2,psd_H_X_L3,psd_H_X_L4,psd_H_X_L5,psd_H_X_L6];
    psd_H_X=smooth(mean(psd_H_X,2));
    psd_H_Z=[psd_H_Z_L1,psd_H_Z_L2,psd_H_Z_L3,psd_H_Z_L4,psd_H_Z_L5,psd_H_Z_L6];
    psd_H_Z=smooth(mean(psd_H_Z,2));
    psd_H_Y=[psd_H_Y_L1,psd_H_Y_L2,psd_H_Y_L3,psd_H_Y_L4,psd_H_Y_L5,psd_H_Y_L6];
    psd_H_Y=smooth(mean(psd_H_Y,2));
    %%
    f6=figure('Renderer', 'painters', 'Position', [10 10 600 400]);
    plot(fpsd_B,smooth(psd_B)), hold on, plot(fpsd_H,smooth(psd_H)),
    xlabel('Frequency [Hz]'), ylabel('Spectral density of motion radius [m^2/Hz]'), grid on,
    xlim([0 0.5]), legend('Blade root','Hub'), ylim([0 1])
    exportgraphics(f6,'PSDRelHubBlade.pdf')
    %%
    f7=figure('Renderer', 'painters', 'Position', [10 10 500 300]);
    
    plot(fpsd_B,smooth(psd_B)), hold on,
    xlabel('Frequency [Hz]'), ylabel('Spectral density of motion radius [m^2/Hz]'), grid on,
    xlim([0 0.3])
    exportgraphics(f7,'BladeRootRelPSD.pdf')
    
    f27=figure('Renderer', 'painters', 'Position', [10 10 500 300]);
    
    plot(fpsd_D,smooth(psd_D)), hold on,
    xlabel('Frequency [Hz]'), ylabel('Spectral density of motion radius [m^2/Hz]'), grid on,
    xlim([0 0.3])
    exportgraphics(f27,'DistPSD.pdf')
    
    f17=figure('Renderer', 'painters', 'Position', [10 10 900 400]);
    subplot(1,2,1)
    plot(timeRif,BladeRadius_L1), hold on, xlabel('time[s]'), ylabel('Blade motion radius [m]'),grid on, xlim([0 1800])
    
    subplot(1,2,2)
    plot(L1_BR_X-L1_MeanRootX,L1_BR_Z-mean(L1_BR_Z));
    xlabel('Blade root x-displacment [m]')
    ylabel('Blade root z-displacment [m]')
    grid on
    circle(0,0,D_crit);
    circle(0,0,nbcr_BRx);
    c1tit=['R_{sb1}= ',num2str(D_crit),'m'];
    c2tit=['\eta_{bcr}= ',num2str(round(nbcr_BRx,2)),'m'];
    legend('Blade pos',c1tit,c2tit)
    
    exportgraphics(f17,'BladeRootTime.pdf')
    
    f8=figure('Renderer', 'painters', 'Position', [10 10 500 300]);
    plot(fpsd_H,smooth(psd_H)), hold on,
    xlabel('Frequency [Hz]'), ylabel('Spectral density of motion radius [m^2/Hz]'), grid on,
    xlim([0 0.3])
    exportgraphics(f8,'HubMoPSD.pdf')
    
    f13=figure('Renderer', 'painters', 'Position', [10 10 900 400]);
    subplot(1,2,1)
    plot(timeRif,HubRadius_L1), hold on, xlabel('time[s]'), ylabel('Hub motion radius [m]'),grid on, xlim([0 1800])
    
    subplot(1,2,2)
    plot(L1_H_X-L1_MeanHubX,L1_H_Z-mean(L1_H_Z));
    xlabel('Hub x-displacment [m]')
    ylabel('Hub z-displacment [m]')
    grid on
    circle(0,0,D_crit);
    circle(0,0,nbcr_Hx);
    c1tit=['R_{sb1}= ',num2str(D_crit),'m'];
    c2tit=['\eta_{hcr}= ',num2str(round(nbcr_Hx,2)),'m'];
    legend('Hub pos',c1tit,c2tit)
    
    exportgraphics(f13,'HubTime.pdf')
    
    %blade psds
    
    bsway=1/17; %black
    broll=1/17; %green
    byaw=1/80.3; %yellow
    
    
    f9=figure('Renderer', 'painters', 'Position', [10 10 600 800]);
    subplot(3,1,1)
    plot(fpsd_B_Su,smooth(psd_B_Su)), hold on,
    xlabel('Frequency [Hz]'), ylabel('Spectral density of surge [m^2/Hz]'), grid on,
    xlim([0 0.3])
    [max_num,loc] = max(psd_B_Su);
    xline(fpsd_B_Su(loc),'r');
    xline(bsway,'b--');
    xline(byaw,'g--');
    NatPer=num2str(1/fpsd_B_Su(loc));
    NatPerlab=['Natural period= ' NatPer 's'];
    legend('PSD',NatPerlab,'Blade nat sway & roll period','Blade nat yaw period')
    
    subplot(3,1,2)
    plot(fpsd_B_Sw,smooth(psd_B_Sw)), hold on,
    xlabel('Frequency [Hz]'), ylabel('Spectral density of sway [m^2/Hz]'), grid on,
    xlim([0 0.3])
    [max_num,loc] = max(psd_B_Sw);
    xline(fpsd_B_Sw(loc),'r');
    xline(bsway,'b--');
    xline(byaw,'g--');
    NatPer=num2str(1/fpsd_B_Sw(loc));
    NatPerlab=['Natural period= ' NatPer 's'];
    legend('PSD',NatPerlab,'Blade nat sway & roll period','Blade nat yaw period')
    
    subplot(3,1,3)
    plot(fpsd_B_Yw,smooth(psd_B_Yw)), hold on,
    xlabel('Frequency [Hz]'), ylabel('Spectral density of yaw [deg^2/Hz]'), grid on,
    xlim([0 0.3])
    [max_num,loc] = max(psd_B_Yw);
    xline(fpsd_B_Yw(loc),'r');
    xline(bsway,'b--');
    xline(byaw,'g--');
    NatPer=num2str(1/fpsd_B_Yw(loc));
    NatPerlab=['Natural period= ' NatPer 's'];
    legend('PSD',NatPerlab,'Blade nat sway & roll period','Blade nat yaw period')
    
    exportgraphics(f9,'BladePSD.pdf')
    
    %blade root psds
    f10=figure('Renderer', 'painters', 'Position', [10 10 600 600]);
    subplot(2,1,1)
    plot(fpsd_BR_X,smooth(psd_BR_X)), hold on,
    xlabel('Frequency [Hz]'), ylabel('Spectral density of motion in x [m^2/Hz]'), grid on,
    xlim([0 0.3])
    [max_num,loc] = max(psd_BR_X);
    xline(fpsd_BR_X(loc),'r');
    xline(bsway,'b--');
    xline(byaw,'g--');
    NatPer=num2str(1/fpsd_BR_X(loc));
    NatPerlab=['Natural period= ' NatPer 's'];
    legend('PSD',NatPerlab,'Blade nat sway & roll period','Blade nat yaw period')
    
    subplot(2,1,2)
    plot(fpsd_BR_Z, smooth(psd_BR_Z)), hold on,
    xlabel('Frequency [Hz]'), ylabel('Spectral density of motion in z [m^2/Hz]'), grid on,
    xlim([0 0.3])
    [max_num,loc] = max(psd_BR_Z);
    xline(fpsd_BR_Z(loc),'r');
    xline(bsway,'b--');
    xline(byaw,'g--');
    NatPer=num2str(1/fpsd_BR_Z(loc));
    NatPerlab=['Natural period= ' NatPer 's'];
    legend('PSD',NatPerlab,'Blade nat sway & roll period','Blade nat yaw period')
    exportgraphics(f10,'BladeRootPSD.pdf')
    
    %hub psds
    f11=figure('Renderer', 'painters', 'Position', [10 10 500 800]);
    subplot(3,1,1)
    plot(fpsd_H_X,smooth(psd_H_X)), hold on,
    xlabel('Frequency [Hz]'), ylabel('Spectral density of motion in x [m^2/Hz]'), grid on,
    xlim([0 0.3])
    [max_num,loc] = max(psd_H_X);
    xline(fpsd_H_X(loc),'r');
    NatPer=num2str(1/fpsd_H_X(loc));
    NatPerlab=['Natural period= ' NatPer 's'];
    legend('PSD',NatPerlab)
    
    subplot(3,1,2)
    plot(fpsd_H_Y, smooth(psd_H_Y)), hold on,
    xlabel('Frequency [Hz]'), ylabel('Spectral density of motion in y [m^2/Hz]'), grid on,
    xlim([0 0.3])
    [max_num,loc] = max(psd_H_Y);
    xline(fpsd_H_Y(loc),'r');
    NatPer=num2str(1/fpsd_H_Y(loc));
    NatPerlab=['Natural period= ' NatPer 's'];
    legend('PSD',NatPerlab)
    
    subplot(3,1,3)
    plot(fpsd_H_Z, smooth(psd_H_Z)), hold on,
    xlabel('Frequency [Hz]'), ylabel('Spectral density of motion in z [m^2/Hz]'), grid on,
    xlim([0 0.3])
    [max_num,loc] = max(psd_H_Z);
    xline(fpsd_H_Z(loc),'r');
    NatPer=num2str(1/fpsd_H_Z(loc));
    NatPerlab=['Natural period= ' NatPer 's'];
    legend('PSD',NatPerlab)
    exportgraphics(f11,'HubPSD.pdf')
end

%% Semi
for i=1
    [fpsd_Su_L1, psd_Su_L1] = Power_Spectral_Density(time,L1_S_X);
    [fpsd_Sw_L1, psd_Sw_L1] = Power_Spectral_Density(time,L1_S_Y);
    [fpsd_He_L1, psd_He_L1] = Power_Spectral_Density(time,L1_S_Z);
    [fpsd_Ro_L1, psd_Ro_L1] = Power_Spectral_Density(time,L1_S_Xr);
    [fpsd_Pi_L1, psd_Pi_L1] = Power_Spectral_Density(time,L1_S_Yr);
    [fpsd_Ya_L1, psd_Ya_L1] = Power_Spectral_Density(time,L1_S_Zr);
    
    [fpsd_Su_L2, psd_Su_L2] = Power_Spectral_Density(time,L2_S_X);
    [fpsd_Sw_L2, psd_Sw_L2] = Power_Spectral_Density(time,L2_S_Y);
    [fpsd_He_L2, psd_He_L2] = Power_Spectral_Density(time,L2_S_Z);
    [fpsd_Ro_L2, psd_Ro_L2] = Power_Spectral_Density(time,L2_S_Xr);
    [fpsd_Pi_L2, psd_Pi_L2] = Power_Spectral_Density(time,L2_S_Yr);
    [fpsd_Ya_L2, psd_Ya_L2] = Power_Spectral_Density(time,L2_S_Zr);
    
    [fpsd_Su_L3, psd_Su_L3] = Power_Spectral_Density(time,L3_S_X);
    [fpsd_Sw_L3, psd_Sw_L3] = Power_Spectral_Density(time,L3_S_Y);
    [fpsd_He_L3, psd_He_L3] = Power_Spectral_Density(time,L3_S_Z);
    [fpsd_Ro_L3, psd_Ro_L3] = Power_Spectral_Density(time,L3_S_Xr);
    [fpsd_Pi_L3, psd_Pi_L3] = Power_Spectral_Density(time,L3_S_Yr);
    [fpsd_Ya_L3, psd_Ya_L3] = Power_Spectral_Density(time,L3_S_Zr);
    
    [fpsd_Su_L4, psd_Su_L4] = Power_Spectral_Density(time,L4_S_X);
    [fpsd_Sw_L4, psd_Sw_L4] = Power_Spectral_Density(time,L4_S_Y);
    [fpsd_He_L4, psd_He_L4] = Power_Spectral_Density(time,L4_S_Z);
    [fpsd_Ro_L4, psd_Ro_L4] = Power_Spectral_Density(time,L4_S_Xr);
    [fpsd_Pi_L4, psd_Pi_L4] = Power_Spectral_Density(time,L4_S_Yr);
    [fpsd_Ya_L4, psd_Ya_L4] = Power_Spectral_Density(time,L4_S_Zr);
    
    [fpsd_Su_L5, psd_Su_L5] = Power_Spectral_Density(time,L5_S_X);
    [fpsd_Sw_L5, psd_Sw_L5] = Power_Spectral_Density(time,L5_S_Y);
    [fpsd_He_L5, psd_He_L5] = Power_Spectral_Density(time,L5_S_Z);
    [fpsd_Ro_L5, psd_Ro_L5] = Power_Spectral_Density(time,L5_S_Xr);
    [fpsd_Pi_L5, psd_Pi_L5] = Power_Spectral_Density(time,L5_S_Yr);
    [fpsd_Ya_L5, psd_Ya_L5] = Power_Spectral_Density(time,L5_S_Zr);
    
    [fpsd_Su_L6, psd_Su_L6] = Power_Spectral_Density(time,L6_S_X);
    [fpsd_Sw_L6, psd_Sw_L6] = Power_Spectral_Density(time,L6_S_Y);
    [fpsd_He_L6, psd_He_L6] = Power_Spectral_Density(time,L6_S_Z);
    [fpsd_Ro_L6, psd_Ro_L6] = Power_Spectral_Density(time,L6_S_Xr);
    [fpsd_Pi_L6, psd_Pi_L6] = Power_Spectral_Density(time,L6_S_Yr);
    [fpsd_Ya_L6, psd_Ya_L6] = Power_Spectral_Density(time,L6_S_Zr);
    
    fpsd_Su=[fpsd_Su_L1;fpsd_Su_L2;fpsd_Su_L3;fpsd_Su_L4;fpsd_Su_L5;fpsd_Su_L6];
    fpsd_Su=mean(fpsd_Su);
    fpsd_Sw=[fpsd_Sw_L1;fpsd_Sw_L2;fpsd_Sw_L3;fpsd_Sw_L4;fpsd_Sw_L5;fpsd_Sw_L6];
    fpsd_Sw=mean(fpsd_Sw);
    fpsd_He=[fpsd_He_L1;fpsd_He_L2;fpsd_He_L3;fpsd_He_L4;fpsd_He_L5;fpsd_He_L6];
    fpsd_He=mean(fpsd_He);
    psd_Su=[psd_Su_L1, psd_Su_L2, psd_Su_L3, psd_Su_L4, psd_Su_L5, psd_Su_L6];
    psd_Su=smooth(mean(psd_Su,2));
    psd_Sw=[psd_Sw_L1, psd_Sw_L2, psd_Sw_L3, psd_Sw_L4, psd_Sw_L5, psd_Sw_L6];
    psd_Sw=smooth(mean(psd_Sw,2));
    psd_He=[psd_He_L1, psd_He_L2, psd_He_L3, psd_He_L4, psd_He_L5, psd_He_L6];
    psd_He=smooth(mean(psd_He,2));
    fpsd_Ro=[fpsd_Ro_L1;fpsd_Ro_L2;fpsd_Ro_L3;fpsd_Ro_L4;fpsd_Ro_L5;fpsd_Ro_L6];
    fpsd_Ro=mean(fpsd_Ro);
    fpsd_Pi=[fpsd_Pi_L1;fpsd_Pi_L2;fpsd_Pi_L3;fpsd_Pi_L4;fpsd_Pi_L5;fpsd_Pi_L6];
    fpsd_Pi=mean(fpsd_Pi);
    fpsd_Ya=[fpsd_Ya_L1;fpsd_Ya_L2;fpsd_Ya_L3;fpsd_Ya_L4;fpsd_Ya_L5;fpsd_Ya_L6];
    fpsd_Ya=mean(fpsd_Ya);
    psd_Ro=[psd_Ro_L1, psd_Ro_L2, psd_Ro_L3, psd_Ro_L4, psd_Ro_L5, psd_Ro_L6];
    psd_Ro=smooth(mean(psd_Ro,2));
    psd_Pi=[psd_Pi_L1, psd_Pi_L2, psd_Pi_L3, psd_Pi_L4, psd_Pi_L5, psd_Pi_L6];
    psd_Pi=smooth(mean(psd_Pi,2));
    psd_Ya=[psd_Ya_L1, psd_Ya_L2, psd_Ya_L3, psd_Ya_L4, psd_Ya_L5, psd_Ya_L6];
    psd_Ya=smooth(mean(psd_Ya,2));
    
    fsurge=1/20.7; %black
    fsway=1/19.7; %red
    fheave=1/18.4; %green
    froll=1/21.1; %blue
    fpitch=1/33.3; %cyan
    fyaw=1/114.6; %yellow
    fwave=1/10.3; %magenta
    
    f12=figure('Renderer', 'painters', 'Position', [10 10 1600 900]);
    subplot(2,3,1)
    plot(fpsd_Su,smooth(psd_Su)), hold on,
    xlabel('Frequency [Hz]'), ylabel('Spectral density of surge motion [m^2/Hz]'), grid on,
    xlim([0 0.3])
    xline(fsurge,'k--');
    xline(fsway,'r--');
    xline(fheave,'g--');
    xline(froll,'b--');
    xline(fpitch,'c--');
    xline(fyaw,'y--');
    xline(fwave,'m--');
    [max_num,loc] = max(psd_Su);
    xline(fpsd_Su(loc),'r');
    NatPer=num2str(1/fpsd_Su(loc));
    NatPerlab=['Natural period= ' NatPer 's'];
    legend('PSD','Nat surge freq','Nat sway freq','Nat heave freq','Nat roll freq','Nat pitch freq','Nat yaw freq','Wave frequency',NatPerlab)
    
    subplot(2,3,2)
    plot(fpsd_Sw,smooth(psd_Sw)), hold on,
    xlabel('Frequency [Hz]'), ylabel('Spectral density of sway motion [m^2/Hz]'), grid on,
    xlim([0 0.3])
    xline(fsurge,'k--');
    xline(fsway,'r--');
    xline(fheave,'g--');
    xline(froll,'b--');
    xline(fpitch,'c--');
    xline(fyaw,'y--');
    xline(fwave,'m--');
    [max_num,loc] = max(psd_Sw);
    xline(fpsd_Sw(loc),'r');
    NatPer=num2str(1/fpsd_Sw(loc));
    NatPerlab=['Natural period= ' NatPer 's'];
    legend('PSD','Nat surge freq','Nat sway freq','Nat heave freq','Nat roll freq','Nat pitch freq','Nat yaw freq','Wave frequency',NatPerlab)
    
    subplot(2,3,3)
    plot(fpsd_He,smooth(psd_He)), hold on,
    xlabel('Frequency [Hz]'), ylabel('Spectral density of heave motion [m^2/Hz]'), grid on,
    xlim([0 0.3])
    xline(fsurge,'k--');
    xline(fsway,'r--');
    xline(fheave,'g--');
    xline(froll,'b--');
    xline(fpitch,'c--');
    xline(fyaw,'y--');
    xline(fwave,'m--');
    [max_num,loc] = max(psd_He);
    xline(fpsd_He(loc),'r');
    NatPer=num2str(1/fpsd_He(loc));
    NatPerlab=['Natural period= ' NatPer 's'];
    legend('PSD','Nat surge freq','Nat sway freq','Nat heave freq','Nat roll freq','Nat pitch freq','Nat yaw freq','Wave frequency',NatPerlab)
    
    subplot(2,3,4)
    plot(fpsd_Ro,smooth(psd_Ro)), hold on,
    xlabel('Frequency [Hz]'), ylabel('Spectral density of roll motion [deg^2/Hz]'), grid on,
    xlim([0 0.3])
    xline(fsurge,'k--');
    xline(fsway,'r--');
    xline(fheave,'g--');
    xline(froll,'b--');
    xline(fpitch,'c--');
    xline(fyaw,'y--');
    xline(fwave,'m--');
    [max_num,loc] = max(psd_Ro);
    xline(fpsd_Ro(loc),'r');
    NatPer=num2str(1/fpsd_Ro(loc));
    NatPerlab=['Natural period= ' NatPer 's'];
    legend('PSD','Nat surge freq','Nat sway freq','Nat heave freq','Nat roll freq','Nat pitch freq','Nat yaw freq','Wave frequency',NatPerlab)
    
    subplot(2,3,5)
    plot(fpsd_Pi,smooth(psd_Pi)), hold on,
    xlabel('Frequency [Hz]'), ylabel('Spectral density of pitch motion [deg^2/Hz]'), grid on,
    xlim([0 0.3])
    xline(fsurge,'k--');
    xline(fsway,'r--');
    xline(fheave,'g--');
    xline(froll,'b--');
    xline(fpitch,'c--');
    xline(fyaw,'y--');
    xline(fwave,'m--');
    [max_num,loc] = max(psd_Pi);
    xline(fpsd_Pi(loc),'r');
    NatPer=num2str(1/fpsd_Pi(loc));
    NatPerlab=['Natural period= ' NatPer 's'];
    legend('PSD','Nat surge freq','Nat sway freq','Nat heave freq','Nat roll freq','Nat pitch freq','Nat yaw freq','Wave frequency',NatPerlab)
    
    subplot(2,3,6)
    plot(fpsd_Ya,smooth(psd_Ya)), hold on,
    xlabel('Frequency [Hz]'), ylabel('Spectral density of yaw motion [deg^2/Hz]'), grid on,
    xlim([0 0.3])
    xline(fsurge,'k--');
    xline(fsway,'r--');
    xline(fheave,'g--');
    xline(froll,'b--');
    xline(fpitch,'c--');
    xline(fyaw,'y--');
    xline(fwave,'m--');
    [max_num,loc] = max(psd_Ya);
    xline(fpsd_Ya(loc),'r');
    NatPer=num2str(1/fpsd_Ya(loc));
    NatPerlab=['Natural period= ' NatPer 's'];
    legend('PSD','Nat surge freq','Nat sway freq','Nat heave freq','Nat roll freq','Nat pitch freq','Nat yaw freq','Wave frequency',NatPerlab)
    
    exportgraphics(f12,'FloaterPSD.pdf')
end
%%
Yaws=[L1_B_Zr L2_B_Zr L3_B_Zr L4_B_Zr L5_B_Zr L6_B_Zr];
BladeYaw=mean(mean(Yaws))

%%
cfreq_D_all=[cfreq_D_L1];
cfreq_D=cfreq_D_all;
temp = abs(vcr - cfreq_D); % Temporary "distances" array.
nbcr_Ds = Doutcr(find(temp == min(abs(vcr - cfreq_D)))); % Find "closest" values array wrt. target value.
nbcr_D = nbcr_Ds(1)

cfreq_D_all=[cfreq_D_L2];
cfreq_D=cfreq_D_all;
temp = abs(vcr - cfreq_D); % Temporary "distances" array.
nbcr_Ds = Doutcr(find(temp == min(abs(vcr - cfreq_D)))); % Find "closest" values array wrt. target value.
nbcr_D = nbcr_Ds(1)

cfreq_D_all=[cfreq_D_L3];
cfreq_D=cfreq_D_all;
temp = abs(vcr - cfreq_D); % Temporary "distances" array.
nbcr_Ds = Doutcr(find(temp == min(abs(vcr - cfreq_D)))); % Find "closest" values array wrt. target value.
nbcr_D = nbcr_Ds(1)

cfreq_D_all=[cfreq_D_L4];
cfreq_D=cfreq_D_all;
temp = abs(vcr - cfreq_D); % Temporary "distances" array.
nbcr_Ds = Doutcr(find(temp == min(abs(vcr - cfreq_D)))); % Find "closest" values array wrt. target value.
nbcr_D = nbcr_Ds(1)

cfreq_D_all=[cfreq_D_L5];
cfreq_D=cfreq_D_all;
temp = abs(vcr - cfreq_D); % Temporary "distances" array.
nbcr_Ds = Doutcr(find(temp == min(abs(vcr - cfreq_D)))); % Find "closest" values array wrt. target value.
nbcr_D = nbcr_Ds(1)

cfreq_D_all=[cfreq_D_L6];
cfreq_D=cfreq_D_all;
temp = abs(vcr - cfreq_D); % Temporary "distances" array.
nbcr_Ds = Doutcr(find(temp == min(abs(vcr - cfreq_D)))); % Find "closest" values array wrt. target value.
nbcr_D = nbcr_Ds(1)


%%
% Assuming L1_Dist is your motion time series
% Assuming the sampling frequency of L1_Dist is Fs (in Hz)

[fpsd_uf1, psd_uf1] = Power_Spectral_Density(timeRif,L1_Dist_PF_unfiltered);
[fpsd_f1, psd_f1] = Power_Spectral_Density(timeRif,L1_Dist_PF);
[fpsd_f3, psd_f3] = Power_Spectral_Density(timeRif,L1_Dist_PF3);
% Plot the original and filtered motion time series

f19=figure('Renderer', 'painters', 'Position', [10 10 700 700]);
subplot(3, 2, 1);
plot(timeRif, L1_Dist_PF_unfiltered);
xlabel('Time (s)');
ylabel('Relative motion [m]');
title('Original motion time series');
grid on,
xlim([0 1800])

subplot(3,2,2);
plot(fpsd_uf1,smooth(psd_uf1)), hold on,
xlabel('Frequency [Hz]'), ylabel('Spectral density [m^2/Hz]'), grid on,
xlim([0 0.6])


subplot(3, 2, 3);
plot(timeRif, L1_Dist_PF);
xlabel('Time (s)');
ylabel('Relative motion [m]');
title('High-frequency components above 0.5Hz');
grid on,
xlim([0 1800])

subplot(3,2,4);
plot(fpsd_f1,smooth(psd_f1)), hold on,
xlabel('Frequency [Hz]'), ylabel('Spectral density [m^2/Hz]'), grid on,
xlim([0 0.6])
exportgraphics(f19,'HighPassComp14.pdf')


subplot(3, 2, 5);
plot(timeRif, L1_Dist_PF3);
xlabel('Time (s)');
ylabel('Relative motion [m]');
title('High-frequency components above 0.3Hz');
grid on,
xlim([0 1800])

subplot(3,2,6);
plot(fpsd_f3,smooth(psd_f3)), hold on,
xlabel('Frequency [Hz]'), ylabel('Spectral density [m^2/Hz]'), grid on,
xlim([0 0.6])
exportgraphics(f19,'HighPassComp14.pdf')


