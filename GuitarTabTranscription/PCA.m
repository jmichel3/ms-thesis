function [P, V,D] = PCA(X)
% PCA of some data matrix X. Measurement types are rows. Trials are
% columns.

%Subtracting mean
X = X - repmat(mean(X,2),1,size(X,2));

if mean(X(1,:)) >= 0.01 || mean(X(1,:)) <= -0.01
    error('Subtract mean!!!')
end

%Covariance matrix
A = (1/(size(X,1)-1))*X*X';

[V,D] = eig(A);

%P is the transform s.t. covariance of PX is diagonal. i.e., eigenvectors
%of XX'.
P = V';
end
