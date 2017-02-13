clear all; clc; close all
%% Read data

RWCW03 = '/Users/jon_michelson/Projects/ms-thesis/data/RWC-MDB-I-2001-W03/';
RWCW04 = '/Users/jon_michelson/Projects/ms-thesis/data/RWC-MDB-I-2001-W04/';

% [x.audio, x.Fs] = audioread([RWCW03 '111/111AGAFF.wav']);
[x.audio, x.Fs] = audioread([RWCW04 '133/133EGLFF.wav']);
% x.audio = x.audio(1:round(end/2));

x.audio = resample(x.audio, 1, 2);
x.Fs = 22050;

%% Note Detection
notes = getNotes(x);

%% Extract features
feats = getFeatures(notes);

%% Plot data
plot(notes.midi0, feats.beta);