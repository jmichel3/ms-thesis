function PRUNED = pruneOutliers(FEAT, METHOD, varargin)
% PRUNED = PRUNEOUTLIERS(FEAT, METHOD, [ NUMDEVS]) 
% Finds outliers, if any, in FEAT and prunes them from the feature
% set. Pruned feature PRUNED is returned. PRUNEOUTLIERS() operates only on
% vectors since matrix columns may contain variable numbers of
% outliers and dimensions may not be preserved.
%
% METHOD options
% 'mode': median absolute deviations
% 'mean': mean absolute deviations
%
% NUMDEVS options
% Integer specifying multiples of absolute deviations that qualify an outlier.
% Defaults to 3 if unspecified.

if size(FEAT,2) ~= 1
   error('pruneOutliers must take in a column vector'); 
end

if ~isempty(varargin)
    MULT = varargin{1};
else MULT = 3;
end

if isequal(METHOD,'median')
    MEASURE = median(FEAT)
else if isequal(METHOD, 'mean')
    MEASURE = mean(FEAT)
    else error('Invalid pruneOutliers METHOD');
    end
end

M = length(FEAT);
PRUNED = FEAT;

% Calculate threshold above which a difference with outlier will be positive
THRESHOLD = abs(MULT * MEASURE)
RECTFEAT = abs(FEAT); % Rectified features
PRUNED(RECTFEAT > THRESHOLD) = 0;

%%%%%%%%%%%%%
% Different return options:
%%%%%%%%%%%%%

% Substitute outliers in FEAT with MEASURE values as to not affect
% post-prune statistics nor dimension
% PRUNED(RECTFEAT > THRESHOLD) = MEASURE;

% OR

% Discard outliers, if you'd like to re-estimate some parameters of FEAT
% without their influence
PRUNED(RECTFEAT > THRESHOLD) = [];

end
