function FEATS = getData()
% FEATS = GETDATA()
% Read guitar wav files. Return FEATS, a cell array whose elements are 
% feature structs with fields inharmonicity, notes, noteCount, etc.

%%%%%%%%%%%%
% READ DATA
%%%%%%%%%%%%

% Paths
dataPath = ['/Users/jon_michelson/Projects/ms-thesis/data/'];
RWC03 = ['RWC-MDB-I-2001-W03/'];
RWC04 = ['RWC-MDB-I-2001-W04/'];

% Create file list
fileList = {};
% fileList = [fileList; [dataPath RWC03 '111/111AGAFF.wav']];
fileList = [fileList; [dataPath RWC04 '131/131EGLFF.wav']];
% fileList = [fileList; [dataPath RWC04 '131/131EGLFM.wav']];
% fileList = [fileList; [dataPath RWC04 '131/131EGLFP.wav']];
% fileList = [fileList; [dataPath RWC04 '132/132EGLFF.wav']];
% fileList = [fileList; [dataPath RWC04 '132/132EGLFM.wav']];
% fileList = [fileList; [dataPath RWC04 '133/133EGLFF.wav']];
% fileList = [fileList; [dataPath 'personal/standard.wav']];
% fileList = [fileList; [dataPath 'personal/dadgad.wav']];
% fileList = [fileList; [dataPath 'personal/whole-up.wav']];
% fileList = [fileList; [dataPath 'personal/whole-down.wav']];

% Optional resampling
resampleFlag = 0;
if resampleFlag
    L=1; M=2;
    disp(['RESAMPLING BY ', num2str(L), '/', num2str(M), ' ON'])
end

% Read audio into DATA, a struct whose fields are Fs and x{i}, a cell array
% whose i'th element is the i'th data instance's sample vector
for i = 1:size(fileList,1)
    DATA.readme{i} = fileList{i}(end-24:end);
    [DATA.x{i} DATA.Fs] = audioread(fileList{i});
    
    % Perform resampling if specified
    if resampleFlag
        DATA.x{i} = resample(DATA.x{i}, L, M);
        DATA.Fs = DATA.Fs*L/M;
    end
end


%%%%%%%%%%%%%%%%%
% DETECT NOTES
%%%%%%%%%%%%%%%%%

% Return detected notes into cell array of structs, whose fields are: len,
% out, Fs, and count. out is a (len x count) matrix.
for i = 1:size(fileList,1)
    NOTES{i} = getNotes(DATA.x{i},DATA.Fs);
end


%%%%%%%%%%%%%%%%%%
% EXTRACT FEATURES
%%%%%%%%%%%%%%%%%%

% Return extracted features for each file in cell 
for i = 1:size(fileList,1)
    FEATS{i} = getFeatures(NOTES{i});
    FEATS{i}.readme = fileList{i}(end-24:end);
end

end