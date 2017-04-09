function [ARMODEL,PXX] = getARmodel(NOTE, ORD)
% Augment the input feature matrix 

FRAMESIZE = 4410;
% -----------------------------------
% Find time index at which variance is max
for n=FRAMESIZE:length(NOTE)
    varFunc(n) = var(NOTE(n-FRAMESIZE+1:n));
end
[~,idx] = max(varFunc);
% idx = idx+320;

% ----------------------------------
% Alternatively just start N samples in (argmax var takes too long)
idx = 2205;

% ARMODEL = armcov(NOTE(idx:idx+FRAMESIZE),ORD);
ARMODEL = [];
PXX = pmcov(NOTE(idx:idx+FRAMESIZE),ORD,2^16);

end