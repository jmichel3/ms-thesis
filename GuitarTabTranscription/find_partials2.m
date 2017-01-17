function [pks, locs, freqs] = find_partials2(Spec, K, Fs)
% FIND_PARTIALS2 Testing alternate method for partial locations/deviations
%   FIND_PARTIALS2(fft) finds peaks in Spec, the input signal's power
%   spectrum with the help of FindPeaks and tuned parameters. Plot
%   locations vs. index, get deviation curve / inharmonicity without f0
%   estimate


% First find f0... 
FFTsize = FFTsize_const();
lo = round(freq2samp(80, Fs, FFTsize));
hi = round(freq2samp(1300, Fs, FFTsize));
[f0pk, f0loc] = findpeaks(Spec(lo : hi), 'Npeaks', 1, 'SortStr', 'descend');
f0loc = lo + f0loc - 1;
% findpeaks(Spec(lo : hi), 'Npeaks', 1, 'SortStr', 'descend')
f0 = samp2freq(f0loc, Fs, FFTsize);
disp(['f0 bin # = ', num2str(f0loc), ', of N = 2^', num2str(log2(FFTsize))]);
disp(['f0 = ', num2str(f0), 'Hz']);

% ...then use its value to seed distance parameter for spectrum-wide peak
% search
MPD = round(f0loc/2);
[pks, locs] = findpeaks(Spec(1 : FFTsize/2), 'MinPeakProminence', 15, 'MinPeakDistance', MPD, 'Npeaks', K);
figure; findpeaks(Spec(1 : FFTsize/2), 'MinPeakProminence', 15, 'MinPeakDistance', MPD, 'Npeaks', K);

% Also return frequency locations
freqs = samp2freq(locs, Fs, FFTsize);

end