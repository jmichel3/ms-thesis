function [HPS,f0] = hps(x,Fs)
   
% Harmonic Product Spectrum for f0 estimation
% Inputs:
%     x - discrete audio signal. Expects x to be isolated note onset.
%     Fs - sampling rate
% Outputs:
%     HPS - the harmonic product spectrum
%     f0 - algorithm's estimate of fundamental frequency
% source: http://stackoverflow.com/questions/19765486/matlab-code-for-
    % harmonic-product-spectrum

% enforce column vector
if (size(x,2) ~= 1)
    x = x';
end

% frame size and fft size, respectively
Nsize = length(x);
Fsize = FFTsize_const();

% frame our input signal
frame = x(1:Nsize);

% window our frame (hanning)
windowed = frame .* hann(length(frame));

% compute fft, throw out symmetry, get magnitude spectrum
FFT = fft(windowed, Fsize);
FFT = FFT(1 : size(FFT,1) / 2);
FFT = abs(FFT);

% obtain integer-downsampled magnitude spectrums
hps1 = downsample(FFT,1);
hps2 = downsample(FFT,2);
hps3 = downsample(FFT,3);
hps4 = downsample(FFT,4);

% Bound f0 search range
lofreq = 50;
hifreq = 1300;

% convert to sample numbers
losamp = round((lofreq/Fs)*Fsize);
hisamp = round((hifreq/Fs)*Fsize);

% obtain harmonic products
HPS = hps1(losamp:hisamp) .* hps2(losamp:hisamp);
HPS = HPS .* hps3(losamp:hisamp) .* hps4(losamp:hisamp);

% get f0
[val, f0samp] = max(HPS);

f0 = ((losamp + f0samp - 1) / Fsize) * Fs;

end