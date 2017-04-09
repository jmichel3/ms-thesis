function [A,fkMeas] = findPartials(f0, searchCenter, spec, Fs, fkMeasPrev, f0Prev)
% fkMeas = FINDPARTIALS(f0, searchCenter, spec, Fs)
%
% Searches the note's magnitude spectrum, spec, for peaks in the frequency
% range searchCenter +/- (f0/2). Return fkMeas, which is the
% k'th partial's empirical measured frequency.

FFTsize = FFTsize_const();
f0samp = freq2samp(f0,Fs,FFTsize);
f0PrevSamp = freq2samp(f0Prev,Fs,FFTsize);

% Try working with power spectrum
% spec = 20*log10(spec);

lo = floor(freq2samp(searchCenter - 3*f0/4, Fs, FFTsize));
hi = floor(freq2samp(searchCenter + 3*f0/4 - 1, Fs, FFTsize));
fkMeasPrev = floor(freq2samp(fkMeasPrev, Fs, FFTsize));

% Corresponding partial probably is closest peak to searchCenter, not
% necessarily max val in search window
[val,idx] = max(spec(lo:hi));

% Find all peaks above (val - a)dB, and return peak closest to searchCenter
a = .0625;
[pks,locs] = findpeaks(spec(lo:hi),'MinPeakHeight',val*a);

% Return useful debug info if can't find peak
if isempty(pks)
    figure; plot(spec(lo:hi)); xlabel('n (lo:hi)'); ylabel('Amp'); title('spec(lo:hi)')
    disp(['f0 = ', num2str(f0), 'Hz']);
    disp(['searchCenter = ', num2str(freq2samp(searchCenter,Fs,FFTsize))]);
    disp(['lo = ', num2str(lo), ', hi = ', num2str(hi)]);
    disp(['val = ', num2str(val)]);
    disp(['a = ', num2str(a)]);
    disp(['val*a = ', num2str(val*a)]);
end

% debug:
%findpeaks(spec(lo:hi),'MinPeakHeight',a*val);
searchCenterSamp = freq2samp(searchCenter,Fs,FFTsize);
% [val,idx] = min(abs((locs+lo-1) - searchCenterSamp));

% Expunge peaks whose normalized deviation are less than that of previous fkMeas
% (bc inharmonicity should be monotonically increasing in spec)
% prevNormDev = (fkMeasPrev-f0samp)/f0samp
% curNormDev = (locs+lo-1 - f0PrevSamp)/f0PrevSamp
% badIdxs = find(curNormDev < prevNormDev)
% locs(badIdxs) = [];
% pks(badIdxs) = [];

% Try to offset distance with amplitude penalty
dist = abs(searchCenterSamp - (locs+lo-1)); %norm by f0 also??
% distNormVal = pks./(dist./2);
distNormVal = pks; % Bypassing any distance normalization, for debug

% Try weight that penalizes lower freqs and rewards higher freqs
% motivation: inharmonicity monotonically increases
w = linspace(0, 2, hi-lo).^3;
% pkWeight = w(locs);
pkWeight = 1; % Bypassing peak weight, for debug
distNormVal = distNormVal.*pkWeight';


[val, idx] = max(distNormVal);
partialIdx = locs(idx);

fkMeas = samp2freq(partialIdx+lo-1, Fs, FFTsize);
A = pks(idx);

% if isempty(fkMeas)
%     % Default to searchcenter if no condition-satisfying peaks found
%     fkMeas = searchCenter
%     A = spec(freq2samp(fkMeas,Fs,FFTsize)) %dummy
% end

% More debugging 
% if round(searchCenterSamp) == 9985
%     disp(['[lo: ',num2str(lo),'; searchCenterSamp = ', num2str(searchCenterSamp),'; hi = ', num2str(hi)]);
%    disp('pks = '); pks 
%    disp('relative locs = '); locs
%    disp('locs+lo-1'); locs+lo-1
%    disp('abs(round(searchCenterSamp) - (locs+lo-1))'); abs(round(searchCenterSamp) - (locs+lo-1))
%    disp('dist = '); dist
%    disp('distNormVal = '); distNormVal
% end

% DEBUG
% figure; plot(spec)
% hold; scatter(partialIdx+lo-1,pks(idx),'o')
% % hold; plot([zeros(1,partialIdx+lo-1) pks(idx)],'o')
% xlim([lo hi]); grid;
% xlabel('samp'); ylabel('power'); title(['f0 = ', num2str(f0), 'Hz, spectrum and located partial']);
% k = waitforbuttonpress;
% close;

end