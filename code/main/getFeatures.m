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
FEATS.midi0 = [];
FEATS.beta = [];
FEATS.Amp = [];
FEATS.FFTsize = 2^20;
FEATS.Fs = NOTES.Fs;

% Obtain spec
STARTms = 300;
LENms = 100;
FEATS.spec = getSpec(NOTES.out, STARTms, LENms, NOTES.Fs);

% Obtain f0s
[FEATS.hps, FEATS.f0] = hps(FEATS.spec, NOTES.Fs, FEATS.FFTsize);

% Obtain midi0s
FEATS.midi0 = round(69 + 12*log2((FEATS.f0)./440));

% Obtain betas (Inharmonicity Coefficients) and As (relative ampl stats)
FEATS.beta = zeros(1,length(FEATS.f0));

K = 8;
oldfeats = polyFit(FEATS.spec, FEATS.f0, K, FEATS.beta, NOTES.Fs);
FEATS.beta = oldfeats.B;
FEATS.A = oldfeats.A;
disp(['Completed K = ', num2str(K)]);

K=10;
oldfeats = polyFit(FEATS.spec, FEATS.f0, K, FEATS.beta, NOTES.Fs);
FEATS.beta = oldfeats.B;
FEATS.A = oldfeats.A;
disp(['Completed K = ', num2str(K)]);

end