function [] = listen(y)
filename = 'listen.wav';
Fs = 11025; % Sampling rate
audiowrite(filename,y,Fs);
[y,Fs] = audioread(filename);
sound(y,Fs);
end

