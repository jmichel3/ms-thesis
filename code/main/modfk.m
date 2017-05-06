function FEATSMOD = modfk(FEATS, NOTE, K, MODVAL)
% MODFK(FEATS, NOTE, K, ADJVAL)
% Utility to modify partial (fk) detection. FEATS is your struct,
% NOTE is your desired note (integer #, column in notes matrix). K is the
% kth partial whose frequency location you'd like to adjust. ADJVAL is the 
% discrete freq sample val to which you'd like it adjusted.
% Returns the adjusted val into a modified feature struct, FEATSMOD. Let's
% also re-compute the estimated beta each time we return.

% Copy FEATS to output
FEATSMOD = FEATS;

% Update fkMeas
FEATSMOD.fkMeasSamp(K,NOTE) = MODVAL;
FEATSMOD.fkMeas(K,NOTE) = samp2freq(MODVAL,FEATS.Fs, FEATS.FFTsize);

% Update devs
FEATSMOD.devs(K,NOTE) = FEATSMOD.fkMeas(K,NOTE) - FEATSMOD.fkIdeal(K,NOTE)

% Re-fit beta
y = FEATSMOD.devs(:,NOTE);
x = (1:FEATS.K)';
X = [x, x.^3];
p = lsqnonneg(X,y);

size(x)
size(X)
size(p)
FEATSMOD.poly(:,NOTE) = X*p;
FEATSMOD.beta(NOTE) = (2 * p(2) / (FEATS.f0(NOTE) + p(1)));
FEATSMOD.beta(NOTE)

end