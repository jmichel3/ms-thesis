function [FSCORES, MEAN] = getFscores(LABELS, PREDS)
% Compute F1-score of predictions PREDS for each string class in LABELS.
% Return in FSCORES; also return mean(FSCORES) in MEAN.

if length(LABELS) ~= length(PREDS)
    error('LABELS and PREDS lengths must be equal.')
end

[C, order] = confusionmat(LABELS, PREDS);

precision = diag(C)./sum(C,2);
recall = diag(C)./sum(C,1);

FSCORES = (2*precision.*recall)./(precision+recall);
MEAN = mean(FSCORES);

end