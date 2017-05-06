function W = getLinRegs(FEATS)
% W = GETLINREGS(FEATS)
% Perform linear regression for each strings' inharmonicities. FEATS is a
% cell array of feats structures, and GETLINREG() aggregates strings across
% these feats structs to perform the linear regression.
% Returns W, the matrix containing slope and intercept coefficients on the
% regression.
%
% NOTE: GETLINREGS() assumes FEATS structs were obtained from full 78-note
% RWC recordings.

% Error checking
assert(iscell(FEATS),'FEATS must be a cell array whose elements are feature structs')
for i = 1:length(FEATS)
   noteCounts(i) = FEATS{i}.noteCount;
end
assert(~logical(range(noteCounts == 0)),'Number of detected notes across FEATS structs must be equal');

% Create N X F design matrices (N = noteCount, F = length(FEATS))
X = [];
for i = 1:length(FEATS)
    X(:,i) = [FEATS{i}.midi0'];
    Y(:,i) = FEATS{i}.beta';
end

% Reshape so column i contains all notes with label i
for s = 1:6
    start = ((s-1)*13)+1;
    stop = start+12;
    Xtemp = X(start:stop,:);
    Ytemp = Y(start:stop,:);
    A(:,s) = Xtemp(:);
    B(:,s) = Ytemp(:);
end

% Linear regression for collection of each string
for s = 1:6
    W(:,6-s+1) = [ones(size(A,1),1), A(:,s)] \ B(:,s);
end

%%

end