% Spectral Subtraction Test

% This program is a simple example of how to use Spectral Subtraction of
% power spectral density (or PSD)in order to remove a signal from the 
% frequency domain

F1 = 20;     %Frequency for the desired signal
T = 1/F1;      %period
t = -5:T:5;   %time

% x1 is the desired signal
x1 = 30*sinc(2*pi*t);

% x2 is the interferance
x2 = 30*sinc(2*pi*t).*cos(t*35);

% y is the sum of all the signals
y = x1+x2;

% Added white gausian noise
% y = awgn(sum,.2);

% PSD Representations Using pwelch
% psdY is the PSD equation of the interfered with signals x1 and x2 and 
% psdX2 is the PSD equation of the interfering signal
% psdX1 is the PSD equation of the original signal
psdY = pwelch(y,[],[],[],F1,'twosided');
psdX2 = pwelch(x2,[],[],[],F1,'twosided');
psdXorg = pwelch(x1,[],[],[],F1,'twosided');

% Here the subraction of the unwanted signal, X2, takes
% place 
% The reslting psdZ is the PSD of the subtraceted represetnation of x1
psdZ = psdY-psdX2;

% In this section of code the code looks for negative musical noise. If the
% power is less than zero after the subtraction then the spectral
% subtraction has introduced musical noise to the signal this must be
% removed to increase the readability of the signal so any negative data
% is zeroed
for s = 1:length(psdZ)
    if psdZ(s)<0
        psdZ(s)=0;
    end
end

% Time Domain Pepresentations of PSD Signals
% x1rec is the time domain representation of the recieved subtracted
% signal
% x1org is the original signal modeled in the same way as the recieved
% signal
x1rec = ifft(sqrt(psdZ));
x1org = ifft(sqrt(psdXorg));

% This graph shows the frequency domain represtentations of the original 
% signal in red, the interfered with signal in green and the subtracted 
% signal in blue
figure(1),
plot(abs(fft(x1rec)),'b');
hold on
plot(abs(fft(x1org)),'r');
plot(abs(sqrt(psdY)),'g');
title('Frequency Plot');
hold off

% In this piece of code the musical noise of the signal is reduced
% The signal is defined within the ranges alpha and beta
alpha = 1;
beta = 1;

psd_womn = psdZ-alpha*psdX2;    %PSD of the signal without musical noise

for s = 1:length(psd_womn)
    if psd_womn(s)>beta*psdX2(s);
        psd_womn(s)=psdX2(s);
    end
end

x1rn = ifft(sqrt(psd_womn));    %time domain signal with reduced noise

figure(2),
%plot(abs(fft(x1rec)),'b');
hold on
plot(abs(fft(x1org)),'r');
plot(abs(fft(x1rn)),'g');
hold off
