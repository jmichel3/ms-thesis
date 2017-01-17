% Jonathan Michelson
% Inharmonicity-Based Method for the Automatic Generation of Guitar Tabs
% IEEE Tx on Audio, Speech, Lang. Processing, Vol. 20, No. 6, Aug. 2012
% Barbancho et. al

clear all, close all, clc

%% Read strings' audio

len = 10*44100;
strpath = './electric/mid/';
strpath2 = './acoustic/samenotesdiffstrings/';
addpath ../matlab_toolboxes/audioFeatureExtraction
addpath ./hline_vline

% open string reads
[str6,Fs] = audioread([strpath '6E.wav'], [1 len]);
[str5,Fs] = audioread([strpath '5A.wav'], [1 len]);
[str4,Fs] = audioread([strpath '4D.wav'], [1 len]);
[str3,Fs] = audioread([strpath '3G.wav'], [1 len]);
[str2,Fs] = audioread([strpath '2B.wav'], [1 len]);
[str1,Fs] = audioread([strpath '1e.wav'], [1 len]);

% Chromatic audio read
[chr1e,Fs] = audioread([strpath 'chromatic1e.wav']);
[chr2B,Fs] = audioread([strpath 'chromatic2B.wav']);
[chr3G,Fs] = audioread([strpath 'chromatic3G.wav']);
[chr4D,Fs] = audioread([strpath 'chromatic4D.wav']);
[chr5A,Fs] = audioread([strpath 'chromatic5A.wav']);
[chr6E,Fs] = audioread([strpath 'chromatic6E.wav']);

% acoustic enharmonic reads
[str4_four, Fs] = audioread([strpath2, '654/', '4D_four5.wav']);
[str5_four, Fs] = audioread([strpath2, '654/', '5A_four5.wav']);
[str6_four, Fs] = audioread([strpath2, '654/', '6E_four5.wav']);



%% Onset Detection
% Specify file under test and duration of detected notes, locate onsets,
% and normalize results

x = str4_four;
x = norm1(x);
len_n = 20000;
notes = get_onsets(x, len_n, Fs);
notes = norm1(notes);

%% Estimate inharmonicity coefficients
B = get_B(notes,Fs);

%% Calculate B(s,n) for each string-fret combination
B_sn = get_Bsn(B_s0);

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