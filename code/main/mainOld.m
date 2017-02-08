clear all, close all, clc

%% Read data

RWCW03 = '/Users/jon_michelson/Projects/ms-thesis/data/RWC-MDB-I-2001-W03/';
RWCW04 = '/Users/jon_michelson/Projects/ms-thesis/data/RWC-MDB-I-2001-W04/';

% x01 = audioread([RWCW03 '091/091CGRNP.wav']);
x02 = audioread([RWCW03 '113/113AGAFF.wav']);
% x03 = audioread([RWCW04 '133/133EGLPP.wav']);

x = [x02(1:round(end/2))];
Fs = 44100;

%% Onset Detection
% Specify file under test and duration of detected notes, locate onsets,
% and normalize results

notes = getNoteEvents(x, 44100, Fs);

%% Estimate inharmonicity coefficients
[feats, midi0] = getBeta(notes,Fs);



%% Audio reading routine

% Find / mark note onsets

% Find candidate f0s for each note
    % FFT
    % normalize magnitude, thresholding
    % look in window of guitar's freq range
    
% Compute all expected inharmonic partials' locations for each f0 note

%% Voting/scoring routine

% define error function

% For each 