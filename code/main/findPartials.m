function [A,fkMeas] = findPartials(f0, searchCenter, spec, Fs)
% fkMeas = FINDPARTIALS(f0, searchCenter, spec, Fs)
%
% Searches the note's magnitude spectrum, spec, for peaks in the frequency
% range searchCenter +/- (f0/2). Return fkMeas, which is the
% k'th partial's empirical measured frequency.

FFTsize = FFTsize_const();

% Try working with power spectrum
% spec = 20*log10(spec);

lo = floor(freq2samp(searchCenter - 3*f0/5, Fs, FFTsize));
hi = floor(freq2samp(searchCenter + 3*f0/5, Fs, FFTsize));

% Corresponding partial probably is closest peak to searchCenter, not
% necessarily max peak in search window
[val,idx] = max(spec(lo:hi));

% Find all peaks above (val - a)dB, and return peak closest to searchCenter
a = 0.65;
[pks,locs] = findpeaks(spec(lo:hi),'MinPeakHeight',val*a);
if isempty(pks)
    figure; plot(spec(lo:hi)); xlabel('n (lo:hi)'); ylabel('Amp'); title('spec(lo:hi)')
    disp('val*a = '); val*a
end
% debug:
%findpeaks(spec(lo:hi),'MinPeakHeight',a*val);
[val,idx] = min(abs(locs-freq2samp(searchCenter,Fs,FFTsize)));

partialIdx = locs(idx);

fkMeas = samp2freq(partialIdx+lo-1, Fs, FFTsize);
A = pks(idx);

% DEBUG
% figure; plot(spec)
% hold; scatter(partialIdx+lo-1,pks(idx),'o')
% % hold; plot([zeros(1,partialIdx+lo-1) pks(idx)],'o')
% xlim([lo hi]); grid;
% xlabel('samp'); ylabel('power'); title(['f0 = ', num2str(f0), 'Hz, spectrum and located partial']);
% k = waitforbuttonpress;
% close;

end