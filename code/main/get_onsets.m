function notes = get_onsets(x, len_n, Fs)
% GET_ONSETS Onset detection
%   GET_ONSETS(x, len_n, Fs) finds note onsets in audio input file x (of
%   sampling rate Fs), and returns len_n-samples of audio starting from the
%   discovered onset locations.

%% Tweak these values as desired
step = Fs/50;
windowLength = Fs/100;

% Combine spectral flux and energy to obtain onset estimates
Flux = SpectralFlux(x, windowLength, step, Fs);
Energy = ShortTimeEnergy(x, windowLength, step);
[pks,locs] = findpeaks(Flux.*Energy, 'MinPeakDistance', 20, 'MinPeakHeight', 0.01);
% for debugging:
figure; findpeaks(Flux.*Energy, 'MinPeakDistance', 20, 'MinPeakHeight', 0.01);

num_notes = length(pks);

for i = 1:1:num_notes
    start_ind = locs(i)*step;
    if (start_ind < (length(x) - len_n)) % avoid out of bounds access
        notes(:,i) = x(start_ind : start_ind + len_n - 1);
    end
end


end