function [aa] = daqdocfft(data,Fs,blocksize)
xfft = abs(fft(data));
% Avoid taking the log of 0.
index = find(xfft == 0);
xfft(index) = 1e-17;
% Finding the magnitude in dB.
mag = 20*log10(xfft); mag = mag(1:floor(blocksize/2));
f = (0:length(mag)-1)*Fs/blocksize;
f = f(:);
[ymax,maxindex]= max(mag);
plot(f,mag)
aa=f(maxindex);
aa=floor(aa);
grid on 
ylabel('Magnitude (dB)')
xlabel('Frequency (Hz)')