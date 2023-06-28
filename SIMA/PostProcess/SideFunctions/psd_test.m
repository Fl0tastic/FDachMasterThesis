function [f,psd]=psd_test(x, fs)
% ARGUMENTS:
%           x: ecg signal
%           fs: sampling frequency
%           gain: signal gain (input 1 if gain is none)
%           d: scalar integer (either 1 or 2) to display graphic windows

% Time duration (s)
time = (0 : numel(x)-1)/fs;

% Detrend the signal
x = detrend(x);

% Extract ecg signal for a duration of 1 minute
if max(time) > 300
    x = x(1: find(time == 300)-1);
end

% Number of samples
N = numel(x);

% Get time and frequncy vectors
t = (0 : N-1)/fs;
f = (0 : N/2-1)*fs/N;
fn = f/fs;

% Compute DFT and retain samples upto Nyquist frequency i.e. Fs/2
X = fft(x, N); 
X = X(1:N/2);

% Power spectral density
psd = (2*abs(X.^2))/(fs*N);

end