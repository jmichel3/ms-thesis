function ARfeats = testAR(FEATS, NOTENUM, ORD)

% ORD = 200;
[a,pxx] = getARmodel(FEATS.notes(:,NOTENUM),ORD);

% N = 2^10;
% [h,w] = freqz(1,a,N);
% freqz(1,a,N)
% figure; plot(10*log10(pxx));
% k = waitforbuttonpress;
% close

%
% Pre-process abs(frequency response) for peak-picking
%

% % Zero-mean, unit-amplitude normalization
% h = 10*log10(abs(h));

% h = h - mean(h);
% h = h * (1/max(abs(h)));
% plot(h); k = waitforbuttonpress; close
% 
% % Median-filter thresholding
% M = 50;
% delta = 0.0;
% lambda = 0.0;
% temp = buffer(h,2*M,2*M-1);
% threshold = delta + lambda * median(temp);
% threshold = threshold';
% h = h(1:end-(2*M-1)) - threshold(2*M:end);
% plot(h); k = waitforbuttonpress; close
% h(h<0)=0;

%
% Find peaks in AR freq response corresponding to harmonics
%
[~, pkLocs] = findpeaks(pxx);
% findpeaks(10*log10(pxx));
% k = waitforbuttonpress;

pkLocs_f = FEATS.Fs*pkLocs/(length(pxx));
%---------------------------------------------
% Get peak associated with detected f0 in FEATS
% f0samp = freq2samp(FEATS.f0(NOTENUM),FEATS.Fs,N);
% dist = abs(pkLocs_f - FEATS.f0(NOTENUM));
% [~, idxMin] = min(dist);
for k=1:1:10
    dist = abs(pkLocs_f - FEATS.fkIdeal(k,NOTENUM));
    [~, idxMin] = min(dist);
    ARfeats.devsAR(k) = dist(idxMin);
    ARfeats.fkMeasAR(k) = pkLocs_f(idxMin);
end


%---------------------------------------------
% Get normalized deviation of kth partial
k = 15;
dist = abs(pkLocs_f - FEATS.fkIdeal(k,NOTENUM));
[~, idxMin] = min(dist);
ARfeats.devsNorm = dist(idxMin);
ARfeats.devsNorm = ARfeats.devsNorm/FEATS.fkIdeal(k,NOTENUM);
ARfeats.fkMeasAR = pkLocs_f(idxMin);


% Compare conventional deviations vs AR deviations
% stem(FEATS.devs(:,NOTENUM));
% hold;
% stem(devsAR,'r');
% k = waitforbuttonpress
% 
% close;


end