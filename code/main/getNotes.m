function NOTES = getNotes(X)
% NOTES = GETNOTES(X)
% Return NOTES, a struct containing the matrix of, and descriptive data
% about, the detected notes in input X, which must be a struct containing the 
% audio waveform (X.audio) and its sample rate (X.Fs). 

if ~isstruct(X)
   error('x must be a struct with x.1 = waveform, x.2 = Fs') 
end

% Init NOTES data fields
NOTES.len = 44100; % in samples (customize)
NOTES.out = [];
NOTES.Fs = X.Fs;
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
f = spectralFlux(X.audio, frame, hop);

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
    if (startIdx < (length(X.audio) - NOTES.len)) % avoid out of bounds access
        NOTES.out(:,i) = X.audio(startIdx : startIdx + NOTES.len - 1);
    end
end


end