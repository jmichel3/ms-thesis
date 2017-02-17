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
FEATS.FFTsize = 2^16;
FEATS.Fs = NOTES.Fs;

% Obtain spec
FEATS.spec = zeros(FEATS.FFTsize/2, FEATS.noteCount);
STARTms = [0,75,150,225,300]; %ms
for i = 1:1:length(STARTms)
    LENms = 100;
    FEATS.spec = FEATS.spec + getSpec(NOTES.out, STARTms(i), LENms, NOTES.Fs);
end

% Obtain f0s
[FEATS.hps, FEATS.f0] = hps(FEATS.spec, NOTES.Fs, FEATS.FFTsize);
FEATS.f0samp = freq2samp(FEATS.f0, FEATS.Fs, FEATS.FFTsize);

% Obtain midi0s
FEATS.midi0 = round(69 + 12*log2((FEATS.f0)./440));

% Obtain betas (Inharmonicity Coefficients) and As (relative ampl stats)
tic
FEATS.beta = zeros(1,length(FEATS.f0));

Kvals = [5, 10, 15]
for i = 1:1:length(Kvals)
    K = Kvals(i);
    oldfeats = polyFit(FEATS.spec, FEATS.f0, K, FEATS.beta, NOTES.Fs);
    FEATS.beta = oldfeats.B;
    FEATS.A = oldfeats.A;
    FEATS.mA = oldfeats.mA;
    FEATS.fkMeas = oldfeats.fkMeas;
    FEATS.fkMeasSamp = freq2samp(FEATS.fkMeas,FEATS.Fs,FEATS.FFTsize);
    FEATS.fkIdeal = repmat((linspace(1,K,K))',[1,FEATS.noteCount]).*repmat(FEATS.f0,[K,1]);
    FEATS.fkIdealSamp = freq2samp(FEATS.fkIdeal, FEATS.Fs, FEATS.FFTsize);
    FEATS.poly = oldfeats.poly;
    FEATS.devs = oldfeats.devs;
    FEATS.devsNorm = oldfeats.devsNorm;
    FEATS.searchCenter = oldfeats.searchCenter;
    FEATS.searchCenterSamp = freq2samp(FEATS.searchCenter,FEATS.Fs,FEATS.FFTsize)
    disp(['Completed K = ', num2str(K)]);
end
toc

end