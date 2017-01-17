function [V,D] = PCA(X)
% PCA of some data matrix X. Measurement types are rows. Trials are
% columns.

if mean(X(1,:)) >= 0.01 || mean(X(1,:)) <= -0.01
    error('Subtract mean!!!')
end

%Covariance matrix
A = X*X';

[V,D] = eig(A);

end
