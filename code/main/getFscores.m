function [FSCORES, MEAN, C] = getFscores(LABELS, PREDS)
% [FSCORES, MEAN, PERM, RELABELS] = GETFSCORES(LABELS, PREDS)
% Compute F1-score of predictions PREDS for each string class in LABELS.
% Return in FSCORES; also return mean(FSCORES) in MEAN. Also return PERM,
% the permutation selected that produced the highest Fscore -- this will be
% a vector of integers, denoting for each index the column to which it
% should be relocated for maximal Fscore. REPREDS, if returned, is simply
% PREDS reordered according to the permutation specified in PERM.

if length(LABELS) ~= length(PREDS)
    error('LABELS and PREDS lengths must be equal.')
end

labelCount = length(unique(LABELS));
[C, order] = confusionmat(LABELS, PREDS)

% Permute columns of C to find the clusterID-to-label mapping that
% maximizes our accuracy (that's the mapping we use for accuracy check).
% allPerms = perms(order);
% for i=1:1:size(allPerms,1)
%     Ctemp = C(:,allPerms(i,:));
%     accuracy(i) = trace(Ctemp);
% end
% [val,idx] = max(accuracy);
% C = C(:,allPerms(idx,:));
% PERM = allPerms(idx,:);
% PERM = [];

precision = diag(C)./sum(C,2);
recall = diag(C)./sum(C,1)';

FSCORES = (2*precision.*recall)./(precision+recall);
MEAN = mean(FSCORES);


if any(isnan(FSCORES))
    FSCORES(isnan(FSCORES)) = 0;
    disp('Suspected recall == precision == 0 in one index...')
    disp(['recall = ']); disp(recall)
    disp(['precision = ']); disp(precision)
end


% REPREDS = zeros(size(PREDS));
% for i = 1:length(PERM)
%    [rows] = find(PREDS == i);
%    REPREDS(rows) = PERM(i);
% end
% REPREDS = [];

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