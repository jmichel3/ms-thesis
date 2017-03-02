function FEATSout = sparsify(FEATS, NUM)
% SPARSIFY(FEATS, NUM)
% simulate sparse guitar performance by randomly removing notes from
% feature set. Intended use: observe effect this has on EM
% NUM - number of notes to which you'd like to trim FEATS
%   

if ceil(NUM) ~= floor(NUM)
   error('NUM must be an integer') 
end

% Indices to delete
delIdx = ceil(randsample(FEATS.noteCount, FEATS.noteCount-NUM))

sparseMidi0 = FEATS.midi0;
sparseBeta = FEATS.beta;

% Deleting them
sparseMidi0(delIdx) = [];
sparseBeta(delIdx) = [];

% Assign output
FEATSout.midi0 = sparseMidi0;
FEATSout.beta =  sparseBeta;
end