function fkMeas = findPartials(f0, searchCenter, spec, Fs)
% fkMeas = FINDPARTIALS(f0, searchCenter, spec, Fs)
%
% Searches the note's magnitude spectrum, spec, for peaks in the frequency
% range searchCenter +/- (f0/2). Return fkMeas, which is the
% k'th partial's empirical measured frequency.

f0
searchCenter

FFTsize = FFTsize_const();

lo = round(freq2samp(searchCenter - 3*f0/4, Fs, FFTsize));
hi = round(freq2samp(searchCenter + 3*f0/4, Fs, FFTsize));

% Corresponding partial probably is closest peak to searchCenter, not
% necessarily max peak in search window
[val,idx] = max(spec(lo:hi));

% Find all peaks above a*val, and return peak closest to searchCenter
a = 0.65;
[pks,locs] = findpeaks(spec(lo:hi),'MinPeakHeight',a*val);
% debug:
findpeaks(spec(lo:hi),'MinPeakHeight',a*val);
[val,idx] = min(abs(locs-freq2samp(searchCenter,Fs,FFTsize)));

partialIdx = locs(idx);

fkMeas = samp2freq(partialIdx+lo-1, Fs, FFTsize);

% figure; plot(spec)
% hold; plot([zeros(1,idx+lo-1) val],'o')
% ideal = [zeros(1,freq2samp(f0,Fs,FFTsize)-1),val];
% plot([ideal, ideal, ideal, ideal, ideal],'+')
% title(['Peak: ',num2str(fkMeas), ' Hz'])
% close;

end