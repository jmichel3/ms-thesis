function [feats, midi0] = getBeta(notes, Fs)
% GETBETA Inharmonicity coefficient calculation 
%   GETBETA(notes, Fs) obtains the inharmonicity coefficient for the input
%   audio, notes (at sampling rate Fs). If notes is a matrix, GETBETA
%   calculates the inharmonicity coefficient for each column separately,
%   and returns a corresponding vector.

%% Init
numNotes = size(notes,2);
FFTsize = FFTsize_const();

%% Get DFTs
start_t = 300; %begin DFT at 'start_t' ms after onset so we get harmonic portion
len_t = 100; %extract 'len_t' ms of samples beyond that
notes_spec = get_spec(notes, start_t, len_t, Fs);

%% Get f0's
% close all;

% Harmonic Product Spectrum
% HPS = zeros(14981,numNotes);
[HPS,f0] = hps(notes_spec,Fs,FFTsize);

% Get MIDI #s of estimated f0s
midi0 = round(69 + 12*log2(f0./440));



%% Get Beta
% Klist = [10, 20, 40]; % different #s of partials to calculate per iteration

% # of partials, INCLUDING k=1st partial = the fundamental


feats.B = zeros(1,length(f0));

K = 10;
feats = polyFit(notes_spec, f0, K, feats.B, Fs);
disp(['Completed K = ', num2str(K)]);
% 
K = 12;
feats = polyFit(notes_spec, f0, K, feats.B, Fs);
disp(['Completed K = ', num2str(K)]);

% Problems finding peaks accurately with K>10...
%[B, devs] = polyFit(notes_spec, f0, 15, B, Fs)

feats.midi0 = midi0;

end