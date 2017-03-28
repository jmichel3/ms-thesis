function [FSCORES, MEAN] = getFscores(LABELS, PREDS)
% [FSCORES, MEAN] = GETFSCORES(LABELS, PREDS)
% Compute F1-score of predictions PREDS for each string class in LABELS.
% Return in FSCORES; also return mean(FSCORES) in MEAN.

if length(LABELS) ~= length(PREDS)
    error('LABELS and PREDS lengths must be equal.')
end

labelCount = length(unique(LABELS));
[C, order] = confusionmat(LABELS, PREDS);

% Permute columns of C to find the clusterID-to-label mapping that
% maximizes our accuracy (that's the mapping we use for accuracy check).
allPerms = perms(order);
for i=1:1:size(allPerms,1)
    Ctemp = C(:,allPerms(i,:));
    accuracy(i) = trace(Ctemp);
end
[val,idx] = max(accuracy);
C = C(:,allPerms(idx,:));

precision = diag(C)./sum(C,2);
recall = diag(C)./sum(C,1)';

FSCORES = (2*precision.*recall)./(precision+recall);
MEAN = mean(FSCORES);


% labelList = unique(LABELS);
% List = unique(PREDS);
% 
% for j=1:1:labelList
%     % Get precision
%     
%    idxs = find(LABELS == j);
%    recall(j) = 
% end

end