function [A,U] = getClusters(X, K, ALG)
% [A,U] = GETCLUSTERS(X, K, ALG)
% Perform the specified clustering algorithm ALG on data specified by
% design matrix X, which is N x P. Vector of length N is returned, each of
% whose elements is an integer corresponding to which of the K clusters it
% was assigned.
%
% ALG must be one of the following strings: {'kmeans', 'spectral'}
%
% U is your data projected onto the K eigenvectors.
%
% Number of trials, if relevant, is defined internally.

if isequal(ALG,'kmeans')
    numTrials = 1;
    for i = 1:1:numTrials
        A(:,i) = kmeans(X,K);
        disp(['Completed trial ', num2str(i), ' of ', num2str(numTrials)]);
    end
    U = [];

else if isequal(ALG,'spectral')
    % Get affinity matrix
    var = 1;
    W = SimGraph_Full(X',var);
    
    % Perform spectral clustering
    type = 3;
    [C,L,U] = SpectralClustering(W,K,type);
    
    % Format sparse matrix C into vector of integers and return
    [~,A] = max(C,[],2);
    
    % Note: for evaluating spectral clustering later, I expect output
    % should be a single vector that doesn't accomodate multiple trials in
    % columns. I.e. leave this code single-use, and parametrize different
    % trials outside of here.
end

end





end