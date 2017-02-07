function [HPS,f0] = hps(SPEC,Fs,FFTsize)
   
% [HPS, f0] = HPS(SPEC,Fs,FFTsize) - Harmonic Product Spectrum for f0 estimation
% Returns f0, an estimate for the monophonic input's fundamental
% frequency. The input's spectrum, SPEC, is at sampling rate Fs Hz. Also
% returns HPS, the harmonic product spectrum vector. Should work on
% matrices whose columns are spectral vectors.
% source: http://stackoverflow.com/questions/19765486/matlab-code-for-
    % harmonic-product-spectrum

% enforce column vector
% if (size(spec,2) ~= 1)
%     x = x';
% end

% obtain integer-downsampled magnitude spectrums
hps1 = downsample(SPEC,1);
hps2 = downsample(SPEC,2);
hps3 = downsample(SPEC,3);
hps4 = downsample(SPEC,4);

% Bound f0 search range
lofreq = 80;
hifreq = 700;

% convert to sample numbers
losamp = round((lofreq/Fs)*FFTsize);
hisamp = round((hifreq/Fs)*FFTsize);

% obtain harmonic products
HPS = hps1(losamp:hisamp,:) .* hps2(losamp:hisamp,:);
HPS = HPS .* hps3(losamp:hisamp,:) .* hps4(losamp:hisamp,:);

% get f0
[val, f0samp] = max(HPS,[],1);

% Due to inharmonic skewing, HPS' f0 isn't matching with empirical f0.
% Use HPS' f0 to seed peak search, then returned found peak
W = 50;
[val, f0final] = max(SPEC(losamp+f0samp-W:losamp+f0samp+W,:), [], 1);

f0 = ((losamp + (f0samp - W) + f0final - 1) / FFTsize) * Fs;

% DEBUG
% f0 = f0 - 2;

% figure; plot(spec);
% hold; plot([zeros(1,losamp + (f0samp - W) + f0final - 1), 1], '+')

end