function FEATSaug = getDevs(FEATS)
% FEATSaug = GETDEVS(FEATS) 
% Augments the input feature struct FEATS with partials' deviations and 
% other partial-specific features, and returns the augmented struct as 
% FEATSaug.

% Init params we're loading
notes_spec = FEATS.spec;
f0 = FEATS.f0;
K = FEATS.K;
B = FEATS.beta;
BPruned = FEATS.betaPruned;
Fs = FEATS.Fs;
FFTsize = FEATS.FFTsize;
numNotes = size(notes_spec, 2);

% Init features we're calculating
devs = zeros(K, numNotes);
fkMeas = zeros(K, numNotes);



fkIdeal = [];
for k = 1:1:K
    fkIdeal = [fkIdeal; k*f0];
end

% For each note...
for i = 1:1:numNotes
%     i
    % and for each partial/harmonic index...
    for k = 1:1:K

        % Init search centers from previous estimate of inharmonicity
        searchCenter(k,i) = k * f0(i) * sqrt(1 + B(i) * k^2);
        
        % Search window about center for actual partial locations
        if k == 1
            fkMeasPrev = f0(i);
        else
            fkMeasPrev = fkMeas(k-1,i);
        end
        
        if i == 1
            f0Prev = f0(i)
        else
            f0Prev = f0(i-1);
        end
        
        [A(k,i), fkMeas(k,i)] = findPartials(f0(i), searchCenter(k,i), notes_spec(:,i), Fs, fkMeasPrev, f0Prev);
        
    end
    
end


% PRUNED VERSION
% For each note...
for i = 1:1:numNotes
%     i
    % and for each partial/harmonic index...
    for k = 1:1:K

        % Init search centers from previous estimate of inharmonicity
        searchCenterPruned(k,i) = k * f0(i) * sqrt(1 + BPruned(i) * k^2);
        
        % Search window about center for actual partial locations
        if k == 1
            fkMeasPrev = f0(i);
        else
            fkMeasPrev = fkMeas(k-1,i);
        end
        
        if i == 1
            f0Prev = f0(i)
        else
            f0Prev = f0(i-1);
        end
        
        [APruned(k,i), fkMeasPruned(k,i)] = findPartials(f0(i), searchCenterPruned(k,i), notes_spec(:,i), Fs, fkMeasPrev, f0Prev);
        
    end
    
end


% Calc deviation from ideal harmonics' locations
devs = fkMeas - fkIdeal;

% Calc deviations' ratios
devsRatio = (fkMeas./fkIdeal).^2;

% Copy input struct to output struct
FEATSaug = FEATS;

% Augmented with new features
samp0 = freq2samp(f0,Fs,FFTsize);
for i=1:1:length(samp0)
    Af0(i) = notes_spec(samp0(i),i);
end
Af0 = repmat(Af0,[K,1]);
FEATSaug.A = Af0./A;
% FEATSaug.A = mean(A,1);
FEATSaug.fkMeas = fkMeas;
FEATSaug.devs = devs;
FEATSaug.devsRatio = devsRatio;
FEATSaug.A = 10.^(A./20); % partials' ampltudes
FEATSaug.searchCenter = searchCenter;

FEATSaug.fkMeasPruned = fkMeasPruned;
FEATSaug.searchCenterPruned = searchCenterPruned;


end