function notes = getNoteEvents(x, noteLen, Fs)
% GETNOTEEVENTS(x, noteLen, Fs) - Apply Onset Detection Function (ODF)
% Takes in one-dimensional audio vector x sampled at Fs Hz and returns a
% matrix collection of extracted notes of length = noteLen samples
%
% Pre-processing: [none]
% Onset criterion: Rectified Spectral Flux (Dixon 2006)
% Post-processing: Zero-mean & unit-amp normalization; median filtering;
% (Bello 2005)
% Peak-picking: [matlab: findpeaks()]
% 
 
%% Algorithm parameters
frame = round(2048);
hop = round(256);

%% Pre-process
% [none]

%% Reduce/detect

% Spectral flux
f = spectralFlux(x, frame, hop, Fs);

%% Post-process
% Bello 2005

% Zero-mean, unit-amplitude normalization
f = f - mean(f);
f = f * (1/max(abs(f)));

% Median-filter thresholding
M = 5;
delta = 0.1;
lambda = 1;
temp = buffer(f,2*M,2*M-1);
threshold = delta + lambda * median(temp);
threshold = threshold';
f = f(1:end-(2*M-1)) - threshold(2*M:end);
f(f<0)=0;

%% Peak-pick

[pks,locs] = findpeaks(f,'MinPeakDistance',100);
% for debugging:
% figure; findpeaks(f);

%% Extract and return notes
numNotes = length(pks);

for i = 1:1:numNotes
    startIdx = locs(i)*hop;
    if (startIdx < (length(x) - noteLen)) % avoid out of bounds access
        notes(:,i) = x(startIdx : startIdx + noteLen - 1);
    end
end

end