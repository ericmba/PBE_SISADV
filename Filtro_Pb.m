%% -------------------------------------------------------------------------
%                              Variables
%--------------------------------------------------------------------------
clear all;
close all;
clc;

C=470e-9;
L=22e-6;
R_L=8;
fm=44100;
Fs=10e6;
f=1:1000:Fs;
s=1i*2*pi.*f;

%% ------------------------------------------------------------------------
%                        Analog Low Pass Filter
%--------------------------------------------------------------------------
w0=1/sqrt(L*C);
fc=w0/(2*pi);
H=w0^2./(w0^2+(1/(C*R_L)).*s+s.^2);
H_abs=20*log10(abs(H).^2);

figure;
semilogx(f,H_abs);
xlabel('frequency [Hz]');
ylabel('Amplitude');
axis([1 Fs -200 80]);
%% ------------------------------------------------------------------------
%                       Low Pass Filter
%--------------------------------------------------------------------------
F=f./fm;
s = 2*fm*(1-exp(-1i*2*pi.*F))./(1+exp(-1i*2*pi.*F)); 
w0=1/(sqrt(L*C));

H=w0^2./(w0^2+(1/(C*R_L)).*s+s.^2);
H_abs=20*log10(abs(H).^2);

figure;
plot(F,H_abs);
xlabel('frequency [Hz]');
ylabel('Amplitude');
xlim([0 1]);