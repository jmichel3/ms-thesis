function f0 = findf0mono(x, Fs, i)
% Find f0 for mono string audio
% Inputs:
%   x - audio of open string
%   Fs - sampling freq
%   i - current iteration # of enclosing for loop (for accessing strings(i))
% Outputs: 
%   f0 - estimate of x's f0

len_t = 100; %length of window in time (ms)
N = 3*floor(Fs*(len_t/1000)); %convert window length to samples (N)
wind = hann(N);
FFTsize = 2^18;
strings = ['E' 'A' 'D' 'G' 'B' 'e'];
f0hat = [82 110 147 196 247 330]; %expected, "hat", f0 in Hz
f0hat_samps = floor((f0hat./Fs)*FFTsize); %convert to sample locations
f = 0:Fs/FFTsize:Fs-(1/FFTsize); %freq vector for plotting

%Set range of freq search for max for each string
lo = f0hat_samps(i)-100;
hi = f0hat_samps(i)+100;

string_spec = zeros(FFTsize,6); %init matrix containing strings' spectra

%Window and DFT
string_wind = x(1:N).*wind;
string_spec = abs(fft(string_wind,FFTsize));

%Plot for debugging
figure;
plot(f(1:10000),string_spec(1:10000));
title([strings(i) ' string']);
xlabel('Hz'); 
ylabel('Amp.');

%Search for peak in lo:hi
f0 = zeros(1,6); %init vector of f0 estimates
[max_val,index] = max(string_spec(lo:hi));
f0 = ((index+lo)/FFTsize)*Fs; %convert to Hz

end