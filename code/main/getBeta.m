function beta = getBeta(notes, Fs)
% GETBETA Inharmonicity coefficient calculation 
%   GETBETA(notes, Fs) obtains the inharmonicity coefficient for the input
%   audio, notes (at sampling rate Fs). If notes is a matrix, GETBETA
%   calculates the inharmonicity coefficient for each column separately,
%   and returns a corresponding vector.

%% Init
numNotes = size(notes,2);
FFTsize = FFTsize_const();

%% Get DFTs
start_t = 200; %begin DFT at 'start_t' ms after onset so we get harmonic portion
len_t = 100; %extract 'len_t' ms of samples beyond that
notes_spec = get_spec(notes, start_t, len_t, Fs);

%% Get f0's
% close all;

% Harmonic Product Spectrum
for (i = 1:1:numNotes)
    [HPS,f0(i)] = hps(notes_spec(:,i),Fs);
end

% Get MIDI #s of estimated f0s
midi0 = round(69 + 12*log2(f0./440));


%% Get Beta
% Klist = [10, 20, 40]; % different #s of partials to calculate per iteration

% # of partials, INCLUDING k=1st partial = the fundamental
K = 5;



B = zeros(1,length(f0));

B = polyFit(notes_spec, f0, K, B, Fs)

B = polyFit(notes_spec, f0, 10, B, Fs)

B = polyFit(notes_spec, f0, 15, B, Fs)





% ///////////
% Iteration 1
% ///////////

iter = 1;
center = zeros(Klist(1),numNotes);

[B, newcenter] = iter_polyfit(Klist, f0, iter, notes_spec, center, Fs);
    
center = newcenter;


% ///////////
% Iteration 2
% ///////////

% close all;

iter = iter + 1;
[B, newcenter] = iter_polyfit(Klist, f0, iter, notes_spec, center, Fs);
center = newcenter;

% ///////////
% Iteration 3
% ///////////
% 
% close all;

iter = iter + 1;
[B, newcenter] = iter_polyfit(Klist, f0, iter, notes_spec, center, Fs);
center = newcenter;

% Plot B vs midi note #


%% Extract B_s0
% 
% midB_s0 = zeros(1, num_notes);
% 
% for i = 1:1:num_notes
%     a = c(1,i);
%     b = c(2,i);
%     d = c(3,i);
%     poly = b*k + d*k.^3;
%     B_s0(i) = (2*d)/(f0(i)+b);
% end
% 
% B = B_s0';

% plot
% figure; plot(midi0, B_s0, 'o');
% xlabel('MIDI note #');
% ylabel('Inharmonicity coefficient \beta');
% title('Inharmonicity vs. MIDI note #');


end