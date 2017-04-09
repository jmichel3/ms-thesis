function FEATS = getFeatures(NOTES)
% FEATS = GETFEATURES(NOTES)
% 
% 

if ~isstruct(NOTES)
   error('Input NOTES must be a struct') 
end

% Init FEATS data fields
FEATS.notes = NOTES.out;
FEATS.noteCount = NOTES.count;
FEATS.spec = [];
FEATS.hps = [];
FEATS.f0 = [];
FEATS.f0samp = [];
FEATS.fkMeas = [];
FEATS.fkIdeal = [];
FEATS.fkMeasSamp = [];
FEATS.fkIdealSamp = [];
FEATS.devs = [];
FEATS.midi0 = [];
FEATS.beta = [];
FEATS.Amp = [];
FEATS.mA = [];
FEATS.FFTsize = 2^18;
FEATS.Fs = NOTES.Fs;

% Get spectra
FEATS.spec = zeros(FEATS.FFTsize/2, FEATS.noteCount);
STARTms = [0,100,200]; %ms
for i = 1:1:length(STARTms)
    LENms = 100;
    FEATS.spec = FEATS.spec + getSpec(NOTES.out, STARTms(i), LENms, NOTES.Fs);
end

% Get f0s
[FEATS.hps, FEATS.f0] = hps(FEATS.spec, NOTES.Fs, FEATS.FFTsize);
FEATS.f0samp = freq2samp(FEATS.f0, FEATS.Fs, FEATS.FFTsize);

% Get midi0s
FEATS.midi0 = round(69 + 12*log2((FEATS.f0)./440));


% Get 15th partial normalized deviation
% FEATS.normDevs = getNormDev(FEATS);


% Get betas (Inharmonicity Coefficients) and As (relative ampl stats)
tic
FEATS.beta = zeros(1,length(FEATS.f0));
FEATS.betaPruned = zeros(1,length(FEATS.f0));
Kvals = [5, 10, 15];

% FEATS.searchCenter = zeros(Kvals(1),FEATS.noteCount);

% For each number of partials to search...
for i = 1:1:length(Kvals)
    K = Kvals(i);
    FEATS.K = K;
    
    % Get partials' deviations
    feats = getDevs(FEATS);
    
    % Get inharmonicity via polynomial fit
    oldfeats = polyFit(feats);
    
    % Assign calculated and remaining features to output
    FEATS.beta = oldfeats.B;
    FEATS.betaPruned = oldfeats.BPruned;
    FEATS.A = oldfeats.A;
    FEATS.mA = oldfeats.mA;
    FEATS.fkMeas = oldfeats.fkMeas;
    FEATS.fkMeasPruned = oldfeats.fkMeasPruned;
    FEATS.fkMeasSamp = freq2samp(FEATS.fkMeas,FEATS.Fs,FEATS.FFTsize);
    FEATS.fkIdeal = repmat((linspace(1,K,K))',[1,FEATS.noteCount]).*repmat(FEATS.f0,[K,1]);
    FEATS.fkIdealSamp = freq2samp(FEATS.fkIdeal, FEATS.Fs, FEATS.FFTsize);
    FEATS.poly = oldfeats.poly;
    FEATS.polyPruned = oldfeats.polyPruned;
    FEATS.devs = oldfeats.devs;
    FEATS.devsPruned = oldfeats.devsPruned;
    FEATS.devsNorm = oldfeats.devsNorm; %old
    FEATS.searchCenter = oldfeats.searchCenter;
    FEATS.searchCenterPruned = oldfeats.searchCenterPruned;
    FEATS.searchCenterSamp = freq2samp(FEATS.searchCenter,FEATS.Fs,FEATS.FFTsize)
    disp(['Completed K = ', num2str(K)]);
end

% Extract kth partials' normalized deviations, calcualted from AR/LPC
% for n=1:1:FEATS.noteCount
%     ORD = 100;
%     ARfeats = testAR(FEATS, n, ORD);
%     FEATS.ARdevsNorm(n) = ARfeats.devsNorm;
%     disp(['finished ', num2str(n)])
% end

toc

end