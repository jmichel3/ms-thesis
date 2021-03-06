function LINES = genLines(COUNT, VAR)
% LINES = GENLINES(COUNT, VAR)
% Generate COUNT noisy lines whose noise terms are defined by VAR 
% of normal distribution. SLOPE determined internally. VAR is
% COUNT-dimensional.

if ~isequal(COUNT, length(VAR))
    error('Input VAR must be COUNT-dimensional')
end

% Finish generating parameters that fully specify the COUNT lines
mHi = 5; mLo = -2;
SLOPE = mHi * rand([COUNT,1]);
intHi = 5;
yInt = intHi * rand([COUNT,1])-intHi/2;
beta = [yInt SLOPE]; % regressor vector

% For each line, use its parameters to generate noisy line data:
% y = mx + e
x = linspace(-5,5,50)';

for i = 1:1:COUNT
    LINES.y(:,i) = yInt(i) + x.*SLOPE(i);
    NOISE = (randn(length(x),1))*sqrt(VAR(i));
    LINES.y(:,i) = LINES.y(:,i) + NOISE;
    LINES.x(:,i) = x;
end

LINES.y = LINES.y(:);
LINES.x = LINES.x(:);

LINES.count = COUNT;
LINES.var = VAR;
LINES.beta = beta;


end