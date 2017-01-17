function fk_meas = find_partials(f0, fk_ideal, spec, Fs, center)
% Find measured partials' peaks. 
% Inputs:
%   f0 - measured fundamental
%   fk_ideal - ideal harmonic's frequency
%   spec - actual string spectrum
%   Fs - sampling freq
%   center - frequency offset about which to center search windows
% Outputs: 
%   fk_meas - vector of partials' measured locations


FFTsize = length(spec);

lo = round(freq2samp(fk_ideal-(f0/2) + center, Fs, FFTsize));
hi = round(freq2samp(fk_ideal+(f0/2) + center, Fs, FFTsize));

[val,idx] = max(spec(lo:hi));

fk_meas = samp2freq(idx+lo-1, Fs, FFTsize);

% Optional visualization
plot(lo+idx-1,val,'x')
end