function LINES = genLines(COUNT, VAR)
% LINES = GENLINES(COUNT, VAR)
% Generate COUNT noisy lines whose noise terms are defined by VAR 
% of normal distribution. SLOPE determined internally. VAR is
% COUNT-dimensional.

if ~isequal(COUNT, length(VAR))
    error('Input VAR must be COUNT-dimensional')
end

% Finish generating parameters that fully specify the COUNT lines
mHi = 2; mLo = -2;
SLOPE = mHi * rand([COUNT,1]);
yInt = 20 * rand([COUNT,1])-10;

% For each line, use its parameters to generate noisy line data:
% y = mx + e
x = linspace(-5,5,50)';

for i = 1:1:COUNT
    LINES.y(:,i) = yInt(i) + x.*SLOPE(i);
    NOISE = (randn(length(x),1))*sqrt(VAR(i));
    LINES.y(:,i) = LINES.y(:,i) + NOISE;
end

LINES.count = COUNT;
% LINES.mean = MEAN;
LINES.var = VAR;
LINES.slope = SLOPE;
LINES.x = x;


end