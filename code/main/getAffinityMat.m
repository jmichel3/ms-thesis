function [A] = getAffinityMat(X)
% A = GETAFFINITYMAT(X)
% Compute the N x N affinity matrix of N x P data matrix N

if size(X,1) < size(X,2)
   error('Input X needs to be N x P, where N is numdatapoints, P is dim') 
end

N = size(X,1);
P = size(X,2);

A = zeros(N,N);
for i=1:1:N
    for j=1:1:N
        if i == j
            A(i,j) = 1;
        else
            A(i,j) = norm(X(i,:)-X(j,:))^2;
        end
    end
end

end