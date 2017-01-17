function [B, newcenter] = iter_polyfit(Klist, f0, iter, notes_spec, center, Fs)
% ITER_POLYFIT Iterative polynomial fit according to Barbancho paper 
%   [B, newcenter] = ITER_POLYFIT(Klist, f0, iter, notes_spec) performs the
%   iter'th iteration of the inharmonicity coefficient calculus for each of
%   the M notes (with f0 estimates vector) in the N x M notes_spec
%   power spectrum matrix. Klist is the vector containing the successive
%   numbers of partials, K, to locate for the current iteration.
%   ITER_POLYFIT returns the current iteration's estimate of the
%   inharmonicity coefficient, B, and the vector of frequency offsets about
%   which to center the next iteration's harmonic deviation search.

% Init
K = Klist(iter); % # of partials to calculate
num_notes = size(notes_spec, 2);
devs = zeros(K, num_notes);
fk_ideal = zeros(K, num_notes);
fk_meas = zeros(K, num_notes);
fk_ideal_samps = zeros(K, num_notes);
FFTsize = FFTsize_const();

% For each note...
for i = 1:1:num_notes
% 
    figure; plot(notes_spec(1:FFTsize/2,i)); hold on; grid on;
    xlabel(['samples n, N = ', num2str(FFTsize)]);
    ylabel('Power (dB)');
    
    % ...get ideal harmonics' and measured partials' locations, then
    % calculate deviations
    for k = 1:1:K

        fk_ideal(k,i) = f0(i)*(k+1); 
        
        fk_meas(k,i) = find_partials(f0(i), fk_ideal(k,i), notes_spec(:,i), Fs, center(k,i));
        
        devs(k,i) = calc_devs(fk_ideal(k,i), fk_meas(k,i));
        
    end
    
    
    hold off;
    
    % convert fk_ideal vals to samples
%     fk_ideal_samps(:,i) = round(freq2samp(fk_ideal(:,i), Fs, FFTsize));
%     v = vline(fk_ideal_samps(:,i)');
end

k = 1:1:K;

% Polynomial fit using least squares approx.
% A*c = b. A is matrix of devs vs. indices. c is vector of coefficients in
% polynomial c1*x + c2*x^3 = devs. b is vector of devs for given index. 

A = zeros(K,2);
A(:,1) = k';
A(:,2) = k'.^3;
c = zeros(2,num_notes);
for i = 1:1:num_notes
    c(:,i) = (inv(A'*A))*A'*devs(:,i);
end




% Poly form: y = a + b*x + 0*x^2 + d*x^3


n = 3;
b = c(1,:);
d = c(2,:);
poly = b(n)*k + d(n)*k.^3;

figure; 
stem(k,devs(:,n));
xlabel('Partial number k');
ylabel('Deviation (Hz)');
title(['Partials Deviations for note n = ', num2str(n)]);
hold on; plot(k,poly)

% return B derived from best fit polynomial
B = (2 .* d) ./ (f0 + b);


% If next iteration exists, calculate new center of search windows. 
if iter < length(Klist)
    for note = 1:1:num_notes
        for k = 1:1:Klist(iter+1)
            newcenter(k,note) = b(note)*k + d(note)*k.^3; 
        end
    end
else newcenter = 0; 
end

end
