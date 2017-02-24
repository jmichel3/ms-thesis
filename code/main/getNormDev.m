function NORMDEVS = getNormDev(FEATS, varargin)
% NORMDEVS = GETNORMDEVS(FEATS[, k])
% Return the normalized deviation of the k'th partial for all notes in
% FEATS. k = 15 by default, but optional override.

if ~isempty(varargin)
    k = varargin{1};
else k = 15
end

for i = 1:1:FEATS.noteCount
   [A(i), fkMeas(i)] = findPartials2(FEATS.f0(i), k*FEATS.f0(i), FEATS.spec, FEATS.Fs) 
end

NORMDEVS = (fkMeas-k*FEATS.f0)./FEATS.f0;

end