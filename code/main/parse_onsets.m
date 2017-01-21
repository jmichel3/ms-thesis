function notes = parse_onsets(x, Fs)

step = Fs/50;
windowLength = Fs/100;
Flux = SpectralFlux(x, windowLength, step, Fs);
Energy = ShortTimeEnergy(x, windowLength, step);
[pks,locs] = findpeaks(Flux.*Energy, 'MinPeakDistance', 50, 'MinPeakHeight', 0.025);

wind = 33000;
num_notes = length(pks);
% notes = zeros(wind,num_notes);
for i = 1:1:num_notes
    start_ind = locs(i)*step;
    notes(:,i) = x(start_ind:start_ind+wind-1);
%     notespec(:,i) = get_spec(E,start_ind,Fs);
end