function n = freq2samp(f, Fs, FFTsize)
% Macro to convert from analog freq to DFT sample no.
% Inputs:
%   f - freq
%   Fs - sampling freq
%   FFTsize
% Outputs: 
%   n - sample no.

n = f*FFTsize/Fs;

end