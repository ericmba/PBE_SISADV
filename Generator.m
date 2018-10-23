clear all;
close all;
%% ------------------------------------------------------------------------
%                               Variables
%--------------------------------------------------------------------------

Ft = 1e3;
Fs = 44.1e3;            
Ts = 1/Fs;
N = 1024;
M=100;      %number of cycles of the sawtooth
A = 1;      %Amplitude triangle wave

t = (0:Ts/100:M*Ts);
f=1:Fs/N:Fs;


%% ------------------------------------------------------------------------
%                               Audio
%--------------------------------------------------------------------------

y = sin(2*pi*Ft*t);

%% ------------------------------------------------------------------------
%                               PWM
%--------------------------------------------------------------------------

%Sawtooht generator

%xt = ((mod(t,Ts)/(Ts))*2)-1;   %Generates sawtooth wave normalized of Freq Fs
xt = A*sawtooth((2*pi*Ft*M*t),0.5);
Xt = fft((xt),N);

%Comparator

out=zeros(size(y));

for i=1:length(y)
    if (y(i)>xt(i))
        out(i)=1;
    else
        out(i)=0;
    end
end
abs(fft(out,N));   

%PWM output

figure;
subplot(2,2,1);
plot(t, xt,'g');
hold on
plot(t,y,'r');
hold off
xlim ([0 M*Ts]);
xlabel('time [s]');
title('Triangle Wave Generator');
xlabel('time [s]');
title('Signal versus Time');

% Plot the signal versus freq:

subplot(2,2,2);
plot(f,abs(Xt)); 
xlim ([0 Fs]);
xlabel('frequency [Hz]');
title('FFT Signal versus Frequency');

%Plot PWM output

subplot(2,2,3);
plot(t,out);
xlim ([0 M*Ts]);
xlabel('time [s]');
title('PWM output');

%Plot PWM output freq. domain

subplot(2,2,4);
plot(f,abs(fft(out,N)));
xlim ([0 Fs]);
xlabel('frequency [Hz]');
title('PWM output');