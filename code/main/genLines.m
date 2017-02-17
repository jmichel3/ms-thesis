function LINES = genLines(COUNT, VAR, varargin)
% LINES = GENLINES(COUNT, VAR, [DIM])
% Generate COUNT noisy lines whose noise terms are defined by VAR 
% of normal distribution. SLOPE determined internally. VAR is
% COUNT-dimensional.

if ~isequal(COUNT, length(VAR))
    error('Input VAR must be COUNT-dimensional')
end

% Finish generating parameters that fully specify the COUNT lines
mHi = 5; mLo = -2;
SLOPE = mHi * rand([COUNT,1]);
SLOPE2 = mHi * rand([COUNT,1]);
intHi = 5;
yInt = intHi * rand([COUNT,1])-intHi/2;
beta = [yInt SLOPE SLOPE2]; % regressor vector

% For each line, use its parameters to generate noisy line data:
% y = mx + e
x = linspace(-5,5,10)';

for i = 1:1:COUNT
    LINES.y(:,i) = yInt(i) + x.*SLOPE(i);
    NOISE = (randn(length(x),1))*sqrt(VAR(i));
    LINES.y(:,i) = LINES.y(:,i) + NOISE;
    LINES.x(:,i) = x;
    LINES.x(:,i) = x;
end

LINES.y = LINES.y(:);
LINES.x = LINES.x(:);
LINES.x2 = LINES.x2(:);

LINES.count = COUNT;
LINES.var = VAR;
LINES.beta = beta;
LINES.dim = size(beta(:,2:end),2);


end