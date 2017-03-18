function FEATSaug = polyFit(FEATS)
% FEATSaug = POLYFIT(FEATS)
% Augments the features struct FEATS with inharmonicity estimates obtained
% by polynomial-fitting FEATS' partials' deviations.

notes_spec = FEATS.spec;
f0 = FEATS.f0;
K = FEATS.K;
B = FEATS.beta;
Fs = FEATS.Fs;

% Initialize parameters
numNotes = size(notes_spec, 2);
devs = FEATS.devs;
fkMeas = FEATS.fkMeas;
FFTsize = FFTsize_const();
% searchCenter = zeros(K,numNotes);



% Polynomial fit using(Abesser)

% Polynomial fit using non-negative least squares approximation (barbancho)
k = 1:1:K;
C = zeros(K,2);
C(:,1) = k';
C(:,2) = k'.^3;
% C(:,3) = k'.^3;
d = devs;
for i = 1:1:numNotes
   x(:,i) = lsqnonneg(C, d(:,i)); 
   poly(:,i) = x(1,i)*k + x(2,i)*k.^3;
%    poly(:,i) = x(1,i) + x(2,i)*k + x(3,i)*k.^3;
   B(1,i) = (2.* x(2,i)) ./ (f0(i) + x(1,i));
   
   % Prune outliers in measured peak devs, and refine polynomial fit
    devsPruned(:,i) = pruneOutliers(d(:,i)-poly(:,i),'mean', 2);
    devsPruned(:,i) = devsPruned(:,i) + poly(:,i);
    x(:,i) = lsqnonneg(C, devsPruned(:,i));
    polyPruned(:,i) = x(1,i)*k + x(2,i)*k.^3;
    BPruned(1,i) = (2.* x(2,i)) ./ (f0(i) + x(1,i));
    
    
end

% Copy input struct to output struct
FEATSaug = FEATS;

% Augment with features just calculated
FEATSaug.poly = poly;
FEATSaug.polyPruned = polyPruned;
FEATSaug.BPruned = BPruned;
FEATSaug.devsPruned = devsPruned;
FEATSaug.devs = devs;
FEATSaug.devsNorm = devs./repmat(f0,[K,1]);
FEATSaug.B = B;




end
