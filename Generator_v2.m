clear all;
close all;

%Variables

Ft = 1e3;
Fs = 44.1e3;            
Ts = 1/Fs;
N = 1024;
M=100;      %number of cycles of the sawtooth
A = 1;      %Amplitude triangle wave

t = (0:Ts/100:M*Ts);
f=1:Fs/N:Fs;

%Audio

y = sin(2*pi*Ft*t);

%% ---------------------------------------------------------------
%Sawtooht generator
% Define some parameters that define the triangle wave.
elementsPerHalfPeriod = (M*Ts/100/2)/(Ts/100)+1; % Number of elements in each rising or falling section.
amplitude = 2; % Peak-to-peak amplitude.
verticalOffset = -1; % Also acts as a phase shift.
numberOfPeriods = 200; % How many replicates of the triangle you want.

% Construct one cycle, up and down.
risingSignal = linspace(0, amplitude, elementsPerHalfPeriod);
fallingSignal = linspace(amplitude, 0, elementsPerHalfPeriod);
% Combine rising and falling sections into one single triangle.
oneCycle = [risingSignal, fallingSignal(2:end)] + verticalOffset;
x = 0:Ts/numberOfPeriods:M*Ts/numberOfPeriods;

% Now plot the triangle.
figure;
subplot(2, 1, 1);
plot(x, oneCycle);
xlim ([0 M*Ts/numberOfPeriods]);
grid on;

% Now replicate this cycle several (numberOfPeriods) times.
triangleWaveform = repmat(oneCycle, [1 numberOfPeriods]);
Xt = fft((triangleWaveform),N);
x = 0:Ts/numberOfPeriods:M*Ts+((numberOfPeriods-1)*Ts/numberOfPeriods);
t1 = x;

% Now plot the triangle wave.
subplot(2, 1, 2);
plot(x, triangleWaveform);
xlim ([0 M*Ts+((numberOfPeriods-1)*Ts/numberOfPeriods)]);
grid on;

%% Comparator ---------------------------------------------------

out=zeros(size(y));

if(size(triangleWaveform)<size(y))
    out=zeros(size(triangleWaveform));
end

for i=1:min(length(y), length(triangleWaveform))
    if (y(i)>triangleWaveform(i))
        out(i)=1;
    else
        out(i)=0;
    end
end
abs(fft(out,N)); 

%% ---------------------------------------------------------------
%PWM output

figure;
subplot(2,2,1);
plot(x, triangleWaveform,'g');
hold on
plot(t,y,'r');
hold off
xlim ([0 M*Ts]);
xlabel('time [s]');
title('Triangle Wave Generator');
xlabel('time [s]');
title('Signal versus Time');

%% ---------------------------------------------------------------
% Plot the signal versus freq:

subplot(2,2,2);
plot(f,abs(Xt)); 
xlim ([0 Fs]);
xlabel('frequency [Hz]');
title('FFT Signal versus Frequency');

%% ---------------------------------------------------------------
%Plot PWM output

subplot(2,2,3);
plot(t,out);
xlim ([0 M*Ts]);
xlabel('time [s]');
title('PWM output');

%% ---------------------------------------------------------------
%Plot PWM output freq. domain

subplot(2,2,4);
plot(f,abs(fft(out,N)));
xlim ([0 Fs]);
xlabel('frequency [Hz]');
title('PWM output');



