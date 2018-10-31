clear all
close all
clc
%% ------------------------------------------------------------------------
%                                   Variables
%  ------------------------------------------------------------------------

fc=1000;
ftwave=45000;

cycles=15;
N=ceil(50000/fc)*cycles;

Q=30;   %Quality factor(24 is random)
fs=50000*Q; 
t=0:1/fs:N*(1/50000);

G=5;    %Gain of the Amplifier

A_sin=1;    %Amplitude Audio Signal

R_L = 16;               
L = 72*10^(-6);      
C = 563*10^(-9);        

%% ------------------------------------------------------------------------
%                                   Audio Signal
%  ------------------------------------------------------------------------
y=A_sin*sin(2*pi*fc*t);

%% ------------------------------------------------------------------------
%                                   Triangular wave
%  ------------------------------------------------------------------------
tri=triangular(2*pi*ftwave*t);

%Plot audio&Triangular Wave
figure; 
subplot(2,1,1);
plot(t(1:1500),y(1:1500),t(1:1500),tri(1:1500));
axis([0 1e-3 -1 1])
title('Etapa comparadora');
xlabel('Time');
ylabel('Triangular wave vs. y');
legend({'Y','Triangular wave'},'Location','southwest')

%% ------------------------------------------------------------------------
%                                   PWM
%  ------------------------------------------------------------------------
out=zeros(size(y));

for i=1:length(t)
    if (y(i)>tri(i))
        out(i)=1;
    else
        out(i)=-1;
    end
end

plot(subplot(2,1,2),t(1:1500),out(1:1500));
axis ([0 1e-3 -1.5 1.5]);
title('Comparator')
xlabel('Time');
ylabel('Comp');

Nfft=2^nextpow2(100000);

Yfft=fft(y,Nfft)/length(y);
TRIfft=fft(tri,Nfft)/length(tri);
OUTfft=fft(out,Nfft)/length(out);

f=fs/2*linspace(0,1,Nfft/2+1);
 
figure; 
plot(subplot(2,1,1),f(1:100),2*abs(Yfft(1:100)));
axis([fc/2 3*fc/2 0 1.5]);
title('Y Transform');
xlabel('Frequency');
ylabel('|Yfft|');

plot(subplot(2,1,2),f(1:4500),2*abs(TRIfft(1:4500)));
axis([ftwave/2 ftwave*3/2 0 0.8]);
title('Triangular Transform');
xlabel('Frequency');
ylabel('|TRIfft|');

figure; 
plot(f(1:4500),2*abs(OUTfft(1:4500)));
axis([fc 50*fc 0 1]); %Every ftwave hay replicas
title('Comparator Transform');
xlabel('Frequency');
ylabel('|OUTfft|');

%% ------------------------------------------------------------------------
%                           Power Amplifier
%  ------------------------------------------------------------------------
for i = 1:length(out)
    Vout(i)=G*out(i);
end

figure; 
plot(t(1:1500),Vout(1:1500));
axis ([0 10^-3 -G G+1]);
title('Power Amplifier');
xlabel('Time');
ylabel('Vout');

Voutfft=fft(Vout,Nfft)/length(Vout);
figure; 
plot(f(1:4500),2*abs(Voutfft(1:4500)));
title('Power Amplifier Transform');
xlabel('Frequency');
ylabel('|Voutfft|');

%% ------------------------------------------------------------------------
%                      Digital Low Pass Filter (Bilineal Transform)
%  ------------------------------------------------------------------------
w0=1/sqrt(L*C);
Tc=1/fs;
a=w0^2.*[1 2 1];
b=[(4/(Tc^2))+(2/(Tc*R_L*C))+w0^2 2*w0^2-(8/(Tc^2)) (4/(Tc^2))-(2/(Tc*R_L*C))+w0^2];

output=filter(a,b,Vout);

figure;
plot(t,output);
title('output final');
xlabel('t');

ylabel('Output');
axis([0 10/fc -10 10]);

