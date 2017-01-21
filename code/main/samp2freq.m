function f = samp2freq(n, Fs, FFTsize)
% SAMP2FREQ Macro to convert from DFT samples to corresponding analog freq
% SAMP2FREQ(n, Fs, FFTsize)
% Inputs:
%   n - sample no.
%   Fs - sampling freq
%   FFTsize
% Outputs: 
%   f - output freq

f = n*Fs/FFTsize;

end