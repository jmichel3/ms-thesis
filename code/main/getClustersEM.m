function [a,ll] = getClustersEM(FEATS,H)
% [A,LL] = GETCLUSTERSEM(H)
% Cluster/classify the datapoints based on highest posterior likelihood of
% latent mixture. Return highest clusters and log likelihood

% Find highest posterior
[~, a] = max(H.z,[],2);

% Calc likelihood
for i=1:1:FEATS.noteCount
    y = FEATS.beta(i);
    x = FEATS.midi0(i);
    w0 = H.beta(a(i), 1);
    w1 = H.beta(a(i), 2);
    mu = w0 + w1*x
    sigma = H.sigma(a(i));
    l(i) = normpdf(y, mu, sigma);
end

% Return log-likelihood
ll = sum(log10(l));

end