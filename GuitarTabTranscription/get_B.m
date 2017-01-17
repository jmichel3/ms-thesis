function B = get_B(Notes, Fs)
% GET_B Inharmonicity coefficient calculation 
%   GET_B(Notes, Fs) obtains the inharmonicity coefficient for the input
%   audio Notes (at sampling rate Fs). If Notes is a matrix, GET_B
%   calculates the inharmonicity coefficient for each column separately,
%   and returns a corresponding vector.

%% Init
num_notes = size(Notes,2);
FFTsize = FFTsize_const();

%% Get DFTs
start = 8820; %begin DFT at Notes[start] so we get harmonic portion after attack
len_t = 100; %extract 'len_t' ms of samples after Notes[start]
notes_spec = get_spec(Notes, start, len_t, Fs);

%% Get f0's
% close all;

% Harmonic Product Spectrum
for (i = 1:1:num_notes)
    [HPS,f0(i)] = hps(Notes(:,i),Fs);
end

% Get MIDI #s of estimated f0s
midi0 = round(69 + 12*log2(f0./440));


%% Catalogue partials' deviations, and Iteratively Fit Polynomial for Bs0
Klist = [10, 20, 40]; % different #s of partials to calculate per iteration

% ///////////
% Iteration 1
% ///////////

iter = 1;
center = zeros(Klist(1),num_notes);

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