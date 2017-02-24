function [A,fkMeas] = findPartials2(f0, searchCenter, spec, Fs)
% fkMeas = FINDPARTIALS(f0, searchCenter, spec, Fs)
%
% Searches the note's magnitude spectrum, spec, for peaks in frequency
% range (searchCenter, searchCenter + f0). Variant of original
% findPartials tailored towards 

FFTsize = FFTsize_const();
f0samp = freq2samp(f0,Fs,FFTsize);

% Try working with power spectrum
% spec = 20*log10(spec);

lo = floor(freq2samp(searchCenter, Fs, FFTsize));
hi = floor(freq2samp(searchCenter + 4*f0/4 - 1, Fs, FFTsize));

% Corresponding partial probably is closest peak to searchCenter, not
% necessarily max val in search window
[val,idx] = max(spec(lo:hi));

% Find all peaks above (val - a)dB, and return peak closest to searchCenter
a = .125;
[pks,locs] = findpeaks(spec(lo:hi),'MinPeakHeight',val*a,'SortStr','descend');

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

% Try to offset distance with amplitude penalty
% dist = abs(searchCenterSamp - (locs+lo-1)); %norm by f0 also??
% distNormVal = pks./(dist./2);
% [val, idx] = max(distNormVal);

% partialIdx = locs(idx);

fkMeas = samp2freq(locs(1)+lo-1, Fs, FFTsize);
A = pks(1);

% More debugging 
if round(searchCenterSamp) == 9985
    disp(['[lo: ',num2str(lo),'; searchCenterSamp = ', num2str(searchCenterSamp),'; hi = ', num2str(hi)]);
   disp('pks = '); pks 
   disp('relative locs = '); locs
   disp('locs+lo-1'); locs+lo-1
   disp('abs(round(searchCenterSamp) - (locs+lo-1))'); abs(round(searchCenterSamp) - (locs+lo-1))
   disp('dist = '); dist
   disp('distNormVal = '); distNormVal
end

% DEBUG
% figure; plot(spec)
% hold; scatter(partialIdx+lo-1,pks(idx),'o')
% % hold; plot([zeros(1,partialIdx+lo-1) pks(idx)],'o')
% xlim([lo hi]); grid;
% xlabel('samp'); ylabel('power'); title(['f0 = ', num2str(f0), 'Hz, spectrum and located partial']);
% k = waitforbuttonpress;
% close;

end