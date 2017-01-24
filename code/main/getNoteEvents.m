function notes = getNoteEvents(x, Fs)
% GETNOTEEVENTS(X) takes in one-dimensional audio vector x and returns a
% matrix collection of extracted notes
%
% Onset criterion:
%
% Window length criterion:
 
%% Algorithm parameters
frame = round(512);
hop = round(256);
noteLen = 256;

%% Find note onsets

% Combine spectral flux and energy to obtain onset estimates
Flux = SpectralFlux(x, frame, hop, Fs);
[pks,locs] = findpeaks(Flux, 'MinPeakDistance', 20, 'MinPeakHeight', 0.2);
% for debugging:
figure; findpeaks(Flux, 'MinPeakDistance', 20, 'MinPeakHeight', 0.2);



%% Extract and return notes
num_notes = length(pks);

for i = 1:1:num_notes
    start_ind = locs(i)*hop;
    if (start_ind < (length(x) - noteLen)) % avoid out of bounds access
        notes(:,i) = x(start_ind : start_ind + noteLen - 1);
    end
end

end