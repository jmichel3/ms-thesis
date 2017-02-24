function LINES = genLines(COUNT, VAR, varargin)
% LINES = GENLINES(COUNT, VAR, [P])
% Generate COUNT noisy lines whose noise terms are defined by VAR 
% of normal distribution. SLOPE determined internally. VAR is
% COUNT-dimensional. Optionally specify the dimensionality of each
% observation: dim(x) = P+1 (i.e., P is # of axes)

if ~isequal(COUNT, length(VAR))
    error('Input VAR must be COUNT-dimensional')
end

% Extract ndimensionality
if ~isempty(varargin)
   P = varargin{1};
else P = 1;
end

% Finish generating parameters that fully specify the COUNT lines
mHi = 5; mLo = -2;
intHi = 5; intLo = -5;
W = zeros(COUNT, P+1); % regressor vector
W(:,1) = intHi * rand([COUNT,1])-intHi/2;
for p = 1:1:P;
   W(:,p+1) = mHi*rand([COUNT,1]);
end

% For each line, use its parameters to generate noisy line data:
% y = mx + e
numObs = 100;
X = ones(numObs,P);
x = linspace(0,5,numObs)';
for p = 1:1:P
   X(:,p+1) = x; 
end

for i = 1:1:COUNT
%     LINES.y(:,i) = yInt(i) + x.*SLOPE(i);
    LINES.y(:,i) = X * W(i,:)';
    NOISE = (randn(numObs,1))*sqrt(VAR(i));
    LINES.y(:,i) = LINES.y(:,i) + NOISE;
    LINES.x(:,i) = x;
%     LINES.x(:,i) = x;
end

LINES.y = LINES.y(:);
LINES.x = LINES.x(:);
% LINES.x2 = LINES.x2(:);

LINES.count = COUNT;
LINES.var = VAR;
LINES.W = W;
% LINES.dim = size(W(:,2:end),2);


end