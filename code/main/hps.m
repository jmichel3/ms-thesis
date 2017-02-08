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
len = length(hps4);
HPS = hps1(1:len,:) .* hps2(1:len,:);
HPS = HPS .* hps3(1:len,:) .* hps4(1:len,:);

% get f0
[val, f0samp] = max(HPS(losamp:hisamp,:),[],1);
f0samp = (losamp-1) + (f0samp-1);

% Due to inharmonic skewing, HPS' f0 isn't matching with empirical f0.
% Use HPS' f0 to seed peak search, then returned found peak
W = 50;
for i = 1:size(SPEC,2)
    [val2(i), f0max(i)] = max(SPEC(f0samp(i)-W:f0samp(i)+W,i), [], 1);
    
end

f0final = (f0samp-W-1) + (f0max-1);
f0final_samp = f0final;
f0final_hz = samp2freq(f0final_samp,Fs,FFTsize);

% DEBUG
% f0 = f0 - 2;0max

n = 2;
figure; plot(SPEC(:,n));
hold; scatter(f0final_samp(n), val2(n), '+');
grid minor

f0 = f0final_hz;
end