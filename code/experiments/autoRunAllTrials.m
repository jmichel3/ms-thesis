clear TX
clear cg1 cg2 cg3 ag1 ag2 ag3 eg1 eg2 eg3 eg4 eg4dadgad eg4wsd eg4wsu

% Defining constants
cg1 = [1:12];
cg2 = [13:24];
cg3 = [25:36];

ag1 = cg1;
ag2 = cg2;
ag3 = cg3;

eg1 = [1:6];
eg2 = [7:12];
eg3 = [13:18];
eg4 = [19];
eg4dadgad = [20];
eg4wsu = [21];
eg4wsd = [22];

expDest = 'exp0';
resultsPath = ['/Users/jon_michelson/projects/ms-thesis/results/',expDest,'/'];

stdLabels = [40:1:52, 45:1:57, 50:1:62, 55:1:67, 59:1:71, 64:1:76];
dadgadLabels = [38:1:50, 45:1:57, 50:1:62, 55:1:67, 57:1:69, 62:1:74];
wsuLabels = [42:1:54, 47:1:59, 52:1:64, 57:1:69, 61:1:73, 66:1:78];
wsdLabels = [38:1:50, 43:1:55, 48:1:60, 53:1:65, 57:1:69, 62:1:74];

% Transcription for general RWC
TX.stringNums = [6*ones(13,1); 5*ones(13,1); 4*ones(13,1); 3*ones(13,1); 2*ones(13,1); 1*ones(13,1)]';
TX.fretNums = [0 1 2 3 4 5 6 7 8 9 10 11 12];
TX.fretNums = repmat(TX.fretNums,[1,6]);

%%

allTrials = {'gtrName','path','featsTrain','featsTest','tuning';
    'cg1',[resultsPath,'091CG'],allData_CG([cg2,cg3]),allData_CG([cg1]),'std';
    'cg2',[resultsPath,'092CG'],allData_CG([cg1,cg3]),allData_CG([cg2]),'std';
    'cg3',[resultsPath,'093CG'],allData_CG([cg1,cg2]),allData_CG([cg3]),'std';
    'ag1',[resultsPath,'111AG'],allData_AG([ag2,ag3]),allData_AG([ag1]),'std';
    'ag2',[resultsPath,'112AG'],allData_AG([ag1,ag3]),allData_AG([ag2]),'std';
    'ag3',[resultsPath,'113AG'],allData_AG([ag1,ag2]),allData_AG([ag3]),'std';
    'eg1',[resultsPath,'131EG'],allData_EG([eg2,eg3]),allData_AG([eg1]),'std';
    'eg2',[resultsPath,'132EG'],allData_EG([eg1,eg3]),allData_AG([eg2]),'std';
    'eg3',[resultsPath,'133EG'],allData_EG([eg1,eg2]),allData_AG([eg3]),'std';
    'eg4',[resultsPath,'134EG'],allData_EG([eg1,eg2]),allData_AG([eg4]),'std';
    'eg4',[resultsPath,'134EG-dadgad'],allData_EG([eg1,eg2]),allData_AG([eg4]),'dadgad';
    'eg4',[resultsPath,'134EG-wsu'],allData_EG([eg1,eg2]),allData_AG([eg4]),'wsu';
    'eg4',[resultsPath,'134EG-wsd'],allData_EG([eg1,eg2]),allData_AG([eg4]),'wsd';
    };
gtrNameCol = 1;
pathCol = 2;
trainCol = 3;
testCol = 4;
tuningCol = 5;
noteLabelsCol = 6;

% Transcription for general RWC
TX = {};
for i = 1:size(allTrials,1)-1
    TX{i}.stringNums = [6*ones(13,1); 5*ones(13,1); 4*ones(13,1); 3*ones(13,1); 2*ones(13,1); 1*ones(13,1)]';
    TX{i}.fretNums = [0 1 2 3 4 5 6 7 8 9 10 11 12];
    TX{i}.fretNums = repmat(TX{i}.fretNums,[1,6]);
end


% For each trial
for i = 2:size(allTrials,1)
    % Get linear regressions of training data
    wLR = getLinRegs(allTrials{i,trainCol});
    
    % Specify labels of lin regs
    wLABELS = [1,2,3,4,5,6];
    
    % Specify remaining inputs to autoRunExperiments()
    testData = allTrials{i,testCol};
    writeDest = allTrials{i,pathCol};
    autoRunExperiments(wLR, wLABELS, testData, writeDest, TX);
    
    % Notify
    disp([allTrials{i,gtrNameCol},' done...'])
end

% Notify
disp(['Successfully wrote experiments to /Users/...results/', expDest]);
