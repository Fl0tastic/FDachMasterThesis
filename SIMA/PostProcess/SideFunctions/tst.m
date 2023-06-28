clc 
clear all
fs= 4000;                % Hz sample rate
    Ts= 1/fs;
    f0= 500;                 % Hz sine frequency
    A= sqrt(2);              % V sine amplitude for P= 1 W into 1 ohm.
    N= 1024;                 % number of time samples
    n= 0:N-1;                % time index
    x= A*sin(2*pi*f0*n*Ts) + .1*randn(1,N);    % 1 W sinewave + noise
    nfft= N;
    window= rectwin(nfft);
    [pxx,f]= pwelch(x,window,0,nfft,fs);    % W/Hz power spectral density
    PdB_Hz= 10*log10(pxx); 
    
    plot(f,pxx)