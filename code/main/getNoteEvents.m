function notes = getNoteEvents(x, Fs)
% GETNOTEEVENTS(X) - Apply Onset Detection Function (ODF)
% Takes in one-dimensional audio vector x and returns a
% matrix collection of extracted notes
%
% Pre-processing: [none]
% Onset criterion: Rectified Spectral Flux (Dixon 2006)
% Post-processing: [none]
% Peak-picking: Zero-mean & unit-variance normalization; median filtering;
% (Dixon 2006)
% 
 
%% Algorithm parameters
frame = round(2048);
hop = round(256);
noteLen = 44100;

%% Pre-process

%% Reduce/detect

% Spectral flux
Flux = spectralFlux(x, frame, hop, Fs);
[pks,locs] = findpeaks(Flux, 'MinPeakDistance', 20, 'MinPeakHeight', 0.25);
% for debugging:
figure; findpeaks(Flux, 'MinPeakDistance', 20, 'MinPeakHeight', 0.25);

%% Post-process

%% Peak-pick

%% Extract and return notes
num_notes = length(pks);

for i = 1:1:num_notes
    start_ind = locs(i)*hop;
    if (start_ind < (length(x) - noteLen)) % avoid out of bounds access
        notes(:,i) = x(start_ind : start_ind + noteLen - 1);
    end
end

end