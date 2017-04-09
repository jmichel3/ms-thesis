clear all; clc; close all
%% Include paths
p = genpath('/Users/jon_michelson/Projects/ms-thesis/code/main/SpectralClustering/');
addpath(p);

%% Read data

RWCW03 = '/Users/jon_michelson/Projects/ms-thesis/data/RWC-MDB-I-2001-W03/';
RWCW04 = '/Users/jon_michelson/Projects/ms-thesis/data/RWC-MDB-I-2001-W04/';

path = '131/131EGLFF.wav';
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

%% Plot data
plot(notes.midi0, feats.beta);