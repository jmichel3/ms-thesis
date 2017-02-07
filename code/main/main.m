clear all; clc; close all
%% Read data

RWCW03 = '/Users/jon_michelson/Projects/ms-thesis/data/RWC-MDB-I-2001-W03/';
RWCW04 = '/Users/jon_michelson/Projects/ms-thesis/data/RWC-MDB-I-2001-W04/';

[x.audio, x.Fs] = audioread([RWCW03 '113/113AGRPP.wav']);

%% Note Detection
notes = getNotes(x);

%% Extract features
feats = getFeatures(notes);

%% Plot data
plot(notes.midi0, feats.beta);