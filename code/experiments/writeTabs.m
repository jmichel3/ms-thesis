function writeTabs(SFTX, TUNING, FNAME)
% WRITETABS(SFTX, TUNING, FNAME) 
% Writes the string-fret transcriptions described in SFTX
% (typically a 2xN matrix) into a tablature-formatted text file,
% 'tabs-FNAME.txt'.

% Ensure TUNING is column "vector"
if size(TUNING,2) ~= 1
   TUNING = TUNING'; 
end

% Flip for tablature format
TUNING = flipud(TUNING);

assert(ischar(FNAME),'FNAME must be a string (character array)')

% Obviously only accepts monophonic notes right now, so no need to consider
% simultaneous notes' entries in SFTX. They'll all be consecutive.
tabs = {};
frameEmpty = {'-';'-';'-';'-';'-';'-'};
frameTemp = frameEmpty;

% Init tablature with tuning and empty frames
tabs = [tabs, TUNING];
tabs = [tabs, frameEmpty];
tabs = [tabs, frameEmpty];

% For each note in STFX
for i = 1:size(SFTX,2)
    
    % Extract string and fret
    str = SFTX(1,i);
    fret = SFTX(2,i);
    
    % Assert realistic values
    assert((str >= 1) & (str <= 6),['String, i.e. STFX(1,', num2str(i),') == ', num2str(str) '; but must be in interval [1,6]']);
    if (fret < 0)
        s = ['WARNING: fret, i.e. STFX(2,', num2str(i),') == ', num2str(fret),', but must be >= 0'];
        warning(s) 
        fret = -1;
    end
    
    % Add string-fret combo to cell array
    frameTemp{str} = num2str(fret);
    tabs = [tabs, frameTemp];
%     tabs = [tabs, frameEmpty];
%     tabs = [tabs, frameEmpty];
    
    % Reset placeholder frame for tab entries
    frameTemp = frameEmpty;
end

% Write output to tabs
T = cell2table(tabs);
fname = ['tabs-',FNAME(end-11:end),'.txt'];
writetable(T,fname,'FileType','text','WriteVariableNames',0,'delimiter',' ')

end