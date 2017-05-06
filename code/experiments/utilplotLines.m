function utilplotLines(W, varargin)
% UTILPLOTLINES(W[, FEATSTRAIN])
% Plot lines described by the 6x2 weight matrix W.
% Optionally superimpose inharmonicity data from FEATSTRAIN cell array of
% feats structs from which W was learned.

% Ensure 6x2
if size(W,2) ~= 2
   W = W'; 
end
assert(size(W,1) == 6, 'W must be a 6x2 matrix')

% Convenience vars
xlimlo = 39; xlimhi = 76;
ylimlo = 0; ylimhi = 7e-4;

% Dummy data
x0 = ones(10,1);
x1 = linspace(30,80,10)';

% Plot
figure; hold; grid minor
for i = 1:size(W,1)
    plot(x1, W(i,1)*x0 + W(i,2)*x1)
end


% Optional FEATS inharmonicity superposition
if ~isempty(varargin)
    FEATSTRAIN = varargin{1} 
    
    % Get average inharmonicites
    sumBeta = zeros(length(FEATSTRAIN{1}.beta),1);
    for i = 1:length(FEATSTRAIN)
        sumBeta = sumBeta + FEATSTRAIN{i}.beta'
    end
    avgBeta = sumBeta/length(FEATSTRAIN);
    for i = 1:FEATSTRAIN{1}.noteCount/13
        scatter(FEATSTRAIN{1}.midi0(1+(i-1)*13 : 13+(i-1)*13), avgBeta(1+(i-1)*13 : 13+(i-1)*13))
    end
end

% Plot details
xlim([xlimlo xlimhi])
ylim([ylimlo ylimhi])
xlabel('MIDI note #')
ylabel('Inharmonicity \beta')
title('Learned Linear Regressions')
legend('1','2','3','4','5','6')
end