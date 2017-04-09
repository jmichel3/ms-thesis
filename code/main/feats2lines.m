function LINES = feats2lines(FEATS, count)
% LINES = FEATS2LINES(FEATS, COUNT)
% Convert FEATS struct of features to LINES struct of lines for em()
% algorithm. COUNT is the desired number of lines to cluster into.

LINES.x = FEATS.midi0; 
LINES.y = FEATS.beta;
LINES.count = count;
LINES.W = [];

% Enforce column vectors
if size(LINES.x,1) == 1
   LINES.x = LINES.x' 
end
if size(LINES.y,1) == 1
   LINES.y = LINES.y' 
end

end