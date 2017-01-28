function [B, newcenter] = polyFit(notes_spec, f0, K, B, Fs)
% POLYFIT(notes_spec, f0, K, B, Fs)

% Initialize parameters
numNotes = size(notes_spec, 2);
devs = zeros(K, numNotes);
fkMeas = zeros(K, numNotes);
FFTsize = FFTsize_const();
searchCenter = zeros(K,numNotes);

fkIdeal = [];
for k = 1:1:K
    fkIdeal = [fkIdeal; k*f0];
end



% For each note...
for i = 1:1:numNotes
    i
    % and for each partial/harmonic index...
    for k = 1:1:K
        
        % Init search centers from previous estimate of inharmonicity
        searchCenter(k,i) = k * f0(i) * sqrt(1 + B(i) * k^2);
        
        % Search window about center for actual partial locations
        fkMeas(k,i) = findPartials(f0(i), searchCenter(k,i), notes_spec(:,i), Fs)
    
    end
    
end

% Return deviation from ideal harmonics' locations
devs = fkIdeal - fkMeas;


% Polynomial fit using least squares approx.
% A*c = b. A is matrix of devs vs. indices. c is vector of coefficients in
% polynomial c1*x + c2*x^3 = devs. b is vector of devs for given index. 
k = 1:1:K;
A = zeros(K,2);
A(:,1) = k';
A(:,2) = k'.^3;
c = zeros(2,numNotes);
for i = 1:1:numNotes
    c(:,i) = (inv(A'*A))*A'*devs(:,i);
end




% Poly form: y = a + b*x + 0*x^2 + d*x^3


for i = 1:numNotes
    b = c(1,:);
    d = c(2,:);
    poly(:,i) = b(i)*k + d(i)*k.^3;
end

% figure; 
% stem(k,devs(:,n));
% xlabel('Partial number k');
% ylabel('Deviation (Hz)');
% title(['Partials Deviations for note n = ', num2str(n)]);
% hold on; plot(k,poly)

% return B derived from best fit polynomial
B = (2 .* d) ./ (f0 + b);



end
