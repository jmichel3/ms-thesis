function [C] = kLinReg_updateCenter(X, y, a)
% A = KLINREG_UPDATECENTER(X, C)
% k-means for linear regressions. Center update step.
% X is your N x P data matrix, where P is
% your dimensionality and N is the number of points. a is your vector of
% cluster assignments.

N = size(X,1);
K = length(unique(a)) % Warning: some lines may not have any datapoints assigned to them

% Update center (intercept and slope) to best fit current assignments
for k=1:1:K
    [~,idx] = find(a == k)
    Xtemp = [ones(length(idx),1) X(idx)];
    ytemp = y(idx);
    C(k,:) = Xtemp \ ytemp;
end

end