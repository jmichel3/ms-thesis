function [a] = kLinReg_updateAssign(X, y, C)
% A = KLINREG_UPDATEASSIGN(X, C)
% k-means for linear regressions. Assignment update step.
% X is your N x P data matrix, where P is
% your dimensionality and N is the number of points. C is your K x P+1
% matrix of "centers," which in this 1-D LinReg case is interpreted as
% y-intercept and slope. Y is the output value Y = W*X.

N = size(X,1);
K = size(C,1);

% Calc distance from each point to each center
for i=1:1:N
    for k=1:1:K
        dy(i,k) = (y(i) - (C(k,1)+C(k,2)*X(i)))^2;
    end
end

% Assign point to center that minimizes this distance
for i=1:1:N
    [~,lineIdx] = min(dy(i,:),[],2);
    a(i) = lineIdx;
end

end