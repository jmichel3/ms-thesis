% Read data
% path = '/some/thing'
[x.audio, x.Fs] = audioread([path '/test']);

notes = getNotes(x);

% Extract features
feats = getFeatures(notes);

% Plot data
plot(notes.midi0, feats.beta);