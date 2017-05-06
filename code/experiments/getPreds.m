function A = getPreds(W, FEATS)
% A = GETPREDS(W, FEATS)
% Output predictions based on the linear regression coefficients in W,
% the 2x6 (or 6x2, I forget) matrix specifying each strings' best-fit
% intercept and slope. 
% FEATS is one feature struct. 
% Predictions A is an int matrix (FEATS.noteCount x 6), where each 
% element n is the string label corresponding to the linear regression 
% number that best explains note n. The j'th column is the j'th-place
% labeling, i.e. the next best/confident label. This is used when the
% (j-1)th label is nonsensical (negative frets given tuning, or something).

% Ensure W is column-oriented
if all(size(W) ~= [6,2])
    W = W';
end

% Error checks
assert(isstruct(FEATS),'In this function, FEATS must be one struct')
assert(all(size(W) == [6,2]),'W must be a 6x2 matrix')

% For each note it contains
for n = 1:FEATS.noteCount
    % Assign label of j'th closest LinReg to column j
    yHats = W * [1; FEATS.midi0(n)];
    yTrue = FEATS.beta(n);
    dist = (yTrue-yHats).^2;
    sortDist = sort(dist);
    for j = 1:length(dist)
        A(n,j) = find(dist == sortDist(j));
    end
end

assert(all(size(A) == [FEATS.noteCount,6]),'A must be vector of ints, with length FEATS.noteCount')
end