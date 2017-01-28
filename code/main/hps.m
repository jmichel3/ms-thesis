function [HPS,f0] = hps(spec,Fs)
   
% [hps, f0] = HPS(x,Fs) - Harmonic Product Spectrum for f0 estimation
% Returns f0, an estimate for the monophonic input's fundamental
% frequency. The input's spectrum, spec, is at sampling rate Fs Hz. Also
% returns hps, the harmonic product spectrum vector.
% source: http://stackoverflow.com/questions/19765486/matlab-code-for-
    % harmonic-product-spectrum

% enforce column vector
if (size(spec,2) ~= 1)
    x = x';
end

FFTsize = FFTsize_const;

% obtain integer-downsampled magnitude spectrums
hps1 = downsample(spec,1);
hps2 = downsample(spec,2);
hps3 = downsample(spec,3);
hps4 = downsample(spec,4);

% Bound f0 search range
lofreq = 50;
hifreq = 1300;

% convert to sample numbers
losamp = round((lofreq/Fs)*FFTsize);
hisamp = round((hifreq/Fs)*FFTsize);

% obtain harmonic products
HPS = hps1(losamp:hisamp) .* hps2(losamp:hisamp);
HPS = HPS .* hps3(losamp:hisamp) .* hps4(losamp:hisamp);

% get f0
[val, f0samp] = max(HPS);

% Due to inharmonic skewing, HPS' f0 isn't matching with empirical f0.
% Use HPS' f0 to seed peak search, then returned found peak
W = 50;
[val, f0final] = max(spec(losamp+f0samp-W:losamp+f0samp+W));

f0 = ((losamp + (f0samp - W) + f0final - 1) / FFTsize) * Fs;

% figure; plot(spec);
% hold; plot([zeros(1,losamp + (f0samp - W) + f0final - 1), 1], '+')

end