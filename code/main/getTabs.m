function [SFTX, A_NEW] = getTabs(FEATS,A,TUNING)
% GETTABS(FEATS,A,TUNING)
% Returns string-fret values. This function also refines the string
% predictions its handed by changing notes' string assignments whose fret
% assignments are nonsensical (negative) to their next best string
% assignments repeatedly until sensibility (non-negativity) is obtained.
% This master sensible assignment is returned in A_NEW.
% 
% FEATS is the input struct of your features. 
% A is a (FEATS.noteCount x 6) matrix of string labels. Column j is the
% j'th best string assignment.
% TUNING is a cell array whose elements of text strings of each
% note (without pitch spec, e.g. EADGBE instead of E4,A4,D5, etc...)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get MIDI pitches in TUNING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

assert(length(TUNING) == 6, 'TUNING must be a 6-element cell array');

s6 = TUNING{1};
s5 = TUNING{2};
s4 = TUNING{3};
s3 = TUNING{4};
s2 = TUNING{5};
s1 = TUNING{6};

opts = {'A', 'A#', 'B', 'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#'};

% If standard tuning
if isequal(TUNING,{'E','A','D','G','B','E'})
    % set default midi pitches and ranges
    strMidi(6) = 40;
    strMidi(5) = 45;
    strMidi(4) = 50;
    strMidi(3) = 55;
    strMidi(2) = 60;
    strMidi(1) = 65;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Deduce strings from assignments' pitch ranges
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% for i = 1:length(unique(A(:,1)))
%    idxs = find(A(:,1) == A(i,1));
%    midi = FEATS.midi0(idxs);
%    
% end
% 
% stringAs = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate tablature text
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% String-fret transcription, 2 x N matrix. 
% sfTx(1,k) = string number; sfTx(2,k) = fret number
SFTX = zeros(2,FEATS.noteCount);

for i = 1:FEATS.noteCount
    % Index for column of most likely string
   j = 1;
   
   % Assign string and fret
   SFTX(1,i) = A(i,j);
   SFTX(2,i) = FEATS.midi0(i)-strMidi(A(i,j));
   
   % If nonsensical string assignment (i.e., negative fret assignment),
   % reassign runner-up string
   while SFTX(2,i) < 0
       if j == 6
           warning(['All fret assignments for note ', num2str(i),' are negative; setting = -1'])
           SFTX(2,i) = -1;
       end
       j = j+1;
       SFTX(1,i) = A(i,j);
       SFTX(2,i) = FEATS.midi0(i)-strMidi(A(i,j));
   end
   
   % Return master string assignments
   A_NEW(i) = SFTX(1,i);
end

% Return
SFTX;
end