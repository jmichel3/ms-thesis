function NOTES = getNotes(x, Fs)
% NOTES = GETNOTES(X, FS)
% Return NOTES, a struct containing the matrix of the detected notes in 
% input sample vector x. Fs is the sampling rate.

assert(isfloat(x),'Input x must be audio sample vector of floats');

% Init NOTES data fields
NOTES.len = Fs; % in samples (customize)
NOTES.out = [];
NOTES.Fs = Fs;
NOTES.count = [];

% === Onset Detection ===
% Pre-processing: [none]
% Onset criterion: Rectified Spectral Flux (Dixon 2006)
% Post-processing: Zero-mean & unit-amp normalization; median filtering;
% (Bello 2005)
% Peak-picking: [matlab: findpeaks()]
 
frame = round(2048);
hop = round(256);

% Spectral flux
f = spectralFlux(x, frame, hop);

% Zero-mean, unit-amplitude normalization
f = f - mean(f);
f = f * (1/max(abs(f)));

% Median-filter thresholding
M = 5;
delta = 0.10;
lambda = 1;
temp = buffer(f,2*M,2*M-1);
threshold = delta + lambda * median(temp);
threshold = threshold';
f = f(1:end-(2*M-1)) - threshold(2*M:end);
f(f<0)=0;

% Peak-pick
[pks,locs] = findpeaks(f,'MinPeakDistance',100);
NOTES.count = length(pks);
for i = 1:1:NOTES.count
    startIdx = locs(i)*hop;
    if (startIdx < (length(x) - NOTES.len)) % avoid out of bounds access
        NOTES.out(:,i) = x(startIdx : startIdx + NOTES.len - 1);
    end
end


end