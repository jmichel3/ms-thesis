clear all; clc; close all
%% Include paths
p = genpath('/Users/jon_michelson/Projects/ms-thesis/code/main/SpectralClustering/');
addpath(p);

%% Read data

RWCW03 = '/Users/jon_michelson/Projects/ms-thesis/data/RWC-MDB-I-2001-W03/';
RWCW04 = '/Users/jon_michelson/Projects/ms-thesis/data/RWC-MDB-I-2001-W04/';

path = '133/133EGLFF.wav';
% [x.audio, x.Fs] = audioread([RWCW03 '111/111AGAFF.wav']);
[x.audio, x.Fs] = audioread([RWCW04 path]);
% x.audio = x.audio(1:round(end/2));

% Adjust sampling rate
L=1; M=1;
x.audio = resample(x.audio, L, M);
x.Fs = x.Fs*L/M;

%% Note Detection
notes = getNotes(x);

%% Extract features
feats = getFeatures(notes);
feats.file = path;

%% Cluster for EM Initialization
X = [feats.midi0(1:52)', feats.beta(1:52)'];
K = 6;
N = 20;

% Run N iterations for each value of K clusters. Quantify each K by average
% score over the N trials, select best trial to initialize EM. 
A = zeros(size(X,1),N,K);
for k=1:K
    for t=1:1:N
        [A(:,t,k),U] = getClusters(X,k,'spectral');
        evals = evaluateClusters(U,A(:,t,k));
        S(t)   = evals.S.CriterionValues;
        CH(t)  = evals.CH.CriterionValues;
        DB(t)  = evals.DB.CriterionValues;
    end
    
    figure; hold;
%     plot(S);
    plot(CH);
%     plot(DB);
    xlabel('Trial number t'); ylabel('Criterion Value'); title(['K = ', num2str(k)])
    grid;
    legend('S','CH','DB');
end




%% EM for Linear Regression Mixture 

%% Plot data
plot(notes.midi0, feats.beta);