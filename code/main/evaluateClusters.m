function EVAL = evaluateClusters(X,CLUSTSOLNS)
% EVAL = EVALUATECLUSTERS(X, CLUSTSOLNS)
% Uses several evaluation options of Matlab's evalclusters() routine to
% return goodness measures for set of clustering solutions in CLUSTSOLNS.
%
% X is your N x P design matrix of N datapoints each with dimensionality P.
%
% "CLUSTSOLNS has N rows and contain integers. Column J contains the cluster 
% indices for each of the N points in the Jth clustering solution. CLUST 
% cannot be a set of clustering solutions when CRITERION is 'gap'."
%
% Returns evaluations in EVAL, a struct whose fields correspond to
% different measures.

% Evaluate clusters
EVAL.S = evalclusters(X, CLUSTSOLNS, 'Silhouette');
EVAL.DB = evalclusters(X, CLUSTSOLNS, 'DaviesBouldin');
EVAL.CH = evalclusters(X, CLUSTSOLNS, 'CalinskiHarabasz');

end