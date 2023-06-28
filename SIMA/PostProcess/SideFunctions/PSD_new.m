function [fpsd,psdx]=PSD_new(time,signal)
fs = length(time);
N = length(signal);
xdft = fft(signal);
xdft = xdft(1:N/2+1);
psdx = (1/(fs*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
fpsd = 0:fs/length(signal):fs/2;
end