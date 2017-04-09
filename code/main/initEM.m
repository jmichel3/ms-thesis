function LINES = initEM(FEATS, C)
% Initialize the EM LinReg algo with lines 



% Get nonzero entries of sparse cluster results matrix
[i,j,val] = find(C);
K = length(unique(j));

% For each cluster
for k=1:1:K
    % Perform linear regression on its points
    idxs = find(j==k);
    N = length(idxs);
    A = ones(N,2);
    A(:,2) = FEATS.midi0(idxs);
    b = FEATS.beta(idxs);
    if size(b,2) ~= 1 %enforce column vector
        b = b';
    W(k,:) = A \ b;
end

LINES.W = W;
LINES.x = FEATS.midi0;
LINES.y = FEATS.beta;
LINES.count = K;

end