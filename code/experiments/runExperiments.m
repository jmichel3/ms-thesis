% Experiment Script
main = genpath('../main/');
addpath(main);

% Read features
% trainData = getTrainData();
% testData = getTestData();
% feats = {}
% feats{1} = featsmod
featsTrain = trainData([1,7,19])
featsTest = trainData(13)

% Learn strings' linear regressions
wLR = getLinRegs(featsTrain);
%%
% Get linear regression predictions
for i = 1:length(featsTest)
    predsLR{i} = getPreds(wLR,featsTest{i});
end

% Compute error/performance
labels = [6*ones(13,1); 5*ones(13,1); 4*ones(13,1); 3*ones(13,1); 2*ones(13,1); 1*ones(13,1)];
for i = 1:length(featsTest)
    [fLR{i}] = getFscores(labels,predsLR{i}(:,1))
end

% % Perform EM for each featsTest
% for i = 1:length(featsTest)
%     lines = feats2lines(featsTest{i},6)
%     lines.W = wLR;
%     h = em(lines);
%     wEM{i} = h.beta;
% end
% 
% % Get linear regression + EM predictions
% for i = 1:length(featsTest)
%     predsEM{i} = getPreds(wEM{i},featsTest{i})
% end
% 
% % Compute error/performance
% for i = 1:length(featsTest)
%     [fEM{i},fmuEM{i}] = getFscores(labels,predsEM{i});
% end


% % Convert to tablature
tuning = {'E','A','D','G','B','E'};
sfTx = {};
aNew = {};
for i = 1:length(featsTest)
    [sfTx{i}, aNew{i}] = getTabs(featsTest{i}, predsLR{i}, tuning);
    writeTabs(sfTx{i}, tuning, featsTest{i}.readme);
    [fLRmstr{i},meanf{i},C{i}] = getFscores(labels,aNew{i})   
    
    % Write/save confusion matrices
    dlmwrite(['cfmat-',featsTest{i}.readme(end-11:end),'.txt'],C{i},'delimiter', '\t')
    
    % Write/save f-scores
    dlmwrite(['f-',featsTest{i}.readme(end-11:end),'.txt'],fLRmstr{i})
end
