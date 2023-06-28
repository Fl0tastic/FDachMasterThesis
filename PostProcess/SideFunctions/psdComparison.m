clc
close all
clear


load ('E:\MatlabFiles\MatFiles_newruns\Results/Outcomes_6A.mat')
psd_B_6G=psd_B;
psd_B_Su_6G=psd_B_Su;
psd_B_Sw_6G=psd_B_Sw;
psd_B_Yw_6G=psd_B_Yw;
psd_BR_X_6G=psd_BR_X;
psd_BR_Z_6G=psd_BR_Z;
psd_B_Y_6G=psd_B_Yw;
psd_H_6G=psd_H;
psd_H_X_6G=psd_H_X;
psd_H_Z_6G=psd_H_Z;
psd_F_Su_6G=psd_F_Su;
psd_F_Sw_6G=psd_F_Sw;
psd_F_He_6G=psd_F_He;

load ('E:\MatlabFiles\MatFiles_newruns\Results/Outcomes_10A.mat')
psd_B_10A=psd_B;
psd_B_Su_10A=psd_B_Su;
psd_B_Sw_10A=psd_B_Sw;
psd_B_Yw_10A=psd_B_Yw;
psd_BR_X_10A=psd_BR_X;
psd_BR_Z_10A=psd_BR_Z;
psd_B_Y_10A=psd_B_Yw;
psd_H_10A=psd_H;
psd_H_X_10A=psd_H_X;
psd_H_Z_10A=psd_H_Z;
psd_F_Su_10A=psd_F_Su;
psd_F_Sw_10A=psd_F_Sw;
psd_F_He_10A=psd_F_He;

load ('E:\MatlabFiles\MatFiles_newruns\Results/Outcomes_14A.mat')
psd_B_14A=psd_B;
psd_B_Su_14A=psd_B_Su;
psd_B_Sw_14A=psd_B_Sw;
psd_B_Yw_14A=psd_B_Yw;
psd_BR_X_14A=psd_BR_X;
psd_BR_Z_14A=psd_BR_Z;
psd_B_Y_14A=psd_B_Yw;
psd_H_14A=psd_H;
psd_H_X_14A=psd_H_X;
psd_H_Z_14A=psd_H_Z;
psd_F_Su_14A=psd_F_Su;
psd_F_Sw_14A=psd_F_Sw;
psd_F_He_14A=psd_F_He;

%blade psds
figure()
subplot(3,1,1)
plot(fpsd_B_Su,psd_B_Su_6G,fpsd_B_Su,psd_B_Su_10A,fpsd_B_Su,psd_B_Su_14A), hold on,
xlabel('Frequency [Hz]'), ylabel('Spectral density of blade surge [m^2/Hz]'), grid on,
xlim([0 0.2])
legend('PSD 6G','PSD 10A','PSD 14A')

subplot(3,1,2)
plot(fpsd_B_Sw,psd_B_Sw_6G,fpsd_B_Sw,psd_B_Sw_10A,fpsd_B_Sw,psd_B_Sw_14A), hold on,
xlabel('Frequency [Hz]'), ylabel('Spectral density of blade sway [m^2/Hz]'), grid on,
xlim([0 0.2])
legend('PSD 6G','PSD 10A','PSD 14A')

subplot(3,1,3)
plot(fpsd_B_Yw,psd_B_Yw_6G,fpsd_B_Yw,psd_B_Yw_10A,fpsd_B_Yw,psd_B_Yw_14A), hold on,
xlabel('Frequency [Hz]'), ylabel('Spectral density of blade yaw [m^2/Hz]'), grid on,
xlim([0 0.2])
legend('PSD 6G','PSD 10A','PSD 14A')

sgtitle('Mean psds of blade motion')

%blade root psds
figure()
subplot(2,1,1)
plot(fpsd_BR_X,psd_BR_X_6G,fpsd_BR_X,psd_BR_X_10A,fpsd_BR_X,psd_BR_X_14A), hold on,
xlabel('Frequency [Hz]'), ylabel('Spectral density of blade root motion in x [m^2/Hz]'), grid on,
xlim([0 0.2])
legend('PSD 6G','PSD 10A','PSD 14A')

subplot(2,1,2)
plot(fpsd_BR_Z,psd_BR_Z_6G,fpsd_BR_Z,psd_BR_Z_10A,fpsd_BR_Z,psd_BR_Z_14A), hold on,
xlabel('Frequency [Hz]'), ylabel('Spectral density of blade root motion in z [m^2/Hz]'), grid on,
xlim([0 0.2])
legend('PSD 6G','PSD 10A','PSD 14A')
sgtitle('Mean psds of blade root motion')

%hub psds
figure()
subplot(2,1,1)
plot(fpsd_H_X,psd_H_X_6G,fpsd_H_X,psd_H_X_10A,fpsd_H_X,psd_H_X_14A), hold on,
xlabel('Frequency [Hz]'), ylabel('Spectral density of hub motion in x [m^2/Hz]'), grid on,
xlim([0 0.2])
legend('PSD 6G','PSD 10A','PSD 14A')

subplot(2,1,2)
plot(fpsd_H_Z,psd_H_Z_6G,fpsd_H_Z,psd_H_Z_10A,fpsd_H_Z,psd_H_Z_14A), hold on,
xlabel('Frequency [Hz]'), ylabel('Spectral density of hub motion in z [m^2/Hz]'), grid on,
xlim([0 0.2])
legend('PSD 6G','PSD 10A','PSD 14A')


%Semi
for i=1
  
    
    fsurge=1/21; %black
    fsway=1/21; %red
    fheave=1/18.2; %green
    froll=1/33; %blue
    fpitch=1/30.7; %cyan
    fyaw=1/114.6; %yellow
    fwave=1/10.3; %magenta
    
    figure()
    subplot(3,1,1)
    plot(fpsd_F_Su,psd_F_Su_6G,fpsd_F_Su,psd_F_Su_10A,fpsd_F_Su,psd_F_Su_14A), hold on,
    xlabel('Frequency [Hz]'), ylabel('Spectral density of floater surge motion [m^2/Hz]'), grid on,
    xlim([0 0.2])
    xline(fsurge,'k--');
    xline(fsway,'r--');
    xline(fheave,'g--');
    xline(froll,'b--');
    xline(fpitch,'c--');
    xline(fyaw,'y--');
    xline(fwave,'m--');
    legend('PSD 6G','PSD 10A','PSD 14A','Nat surge freq','Nat sway freq','Nat heave freq','Nat roll freq','Nat pitch freq','Nat yaw freq','Wave frequency')
    
    subplot(3,1,2)
    plot(fpsd_F_Sw,psd_F_Sw_6G,fpsd_F_Sw,psd_F_Sw_10A,fpsd_F_Sw,psd_F_Sw_14A), hold on,
    xlabel('Frequency [Hz]'), ylabel('Spectral density of floater sway motion [m^2/Hz]'), grid on,
    xlim([0 0.2])
    xline(fsurge,'k--');
    xline(fsway,'r--');
    xline(fheave,'g--');
    xline(froll,'b--');
    xline(fpitch,'c--');
    xline(fyaw,'y--');
    xline(fwave,'m--');
    legend('PSD 6G','PSD 10A','PSD 14A','Nat surge freq','Nat sway freq','Nat heave freq','Nat roll freq','Nat pitch freq','Nat yaw freq','Wave frequency')
    
    subplot(3,1,3)
    plot(fpsd_F_He,psd_F_He_6G,fpsd_F_He,psd_F_He_10A,fpsd_F_He,psd_F_He_14A), hold on,
    xlabel('Frequency [Hz]'), ylabel('Spectral density of floater heave motion [m^2/Hz]'), grid on,
    xlim([0 0.2])
    xline(fsurge,'k--');
    xline(fsway,'r--');
    xline(fheave,'g--');
    xline(froll,'b--');
    xline(fpitch,'c--');
    xline(fyaw,'y--');
    xline(fwave,'m--');
    legend('PSD 6G','PSD 10A','PSD 14A','Nat surge freq','Nat sway freq','Nat heave freq','Nat roll freq','Nat pitch freq','Nat yaw freq','Wave frequency')
    
    sgtitle('Mean psds of floater motion')
end