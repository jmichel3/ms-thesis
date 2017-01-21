function B_s0 = get_Bs0(open_strings, Fs)
% Obtain B(s,0) from each open string recording
% Inputs:
%   string_audio - matrix of .wav recordings of open strings. From left
%   (col 1) to right (col 6), low E to high E.
% Outputs: 
%   B_s0 - vector of B_s0 constants for corresponding strings

num_strings = size(open_strings,2);
FFTsize = FFTsize_const();

%% Find onset
% since manually uploaded, assuming onset right at start of recording

%% Get DFTs
for i = 1:1:num_strings
    % start 8820 samples in so we get harmonic portion after attack
   string_spec(:,i) = get_spec(open_strings(:,i),8820,Fs); 
end

%% Estimate f0's
close all;

for (i = 1:1:num_strings)
    [HPS,f0(i)] = hps(open_strings(:,i),Fs);
end

% Get MIDI #s of estimated f0s
midi0 = round(69 + 12*log2(f0./440));


%% Catalogue partials' deviations, and Iteratively Fit Polynomial for Bs0
Klist = [10, 20, 30]; % different #s of partials to calculate per iteration

% ///////////
% Iteration 1
% ///////////

n = 1; % ordinal note number. For plot visualization
iter = 1;
K = Klist(iter); % # of partials to calculate

devs = zeros(K,num_strings);
fk_ideal = zeros(K,num_strings);
fk_meas = zeros(K,num_strings);
fk_ideal_samps = zeros(K,num_strings);

for i = 1:1:num_strings

    figure; plot(string_spec(1:FFTsize/2,i)); hold on; grid on;
    xlabel(['samples n, N = ', num2str(FFTsize)]);
    ylabel('Power (dB)');
    
    for k = 1:1:K
        % Get ideal harmonic locations
        fk_ideal(k,i) = f0(i)*(k+1); 
        
        % Get measured inharmonic partials' locations
        fk_meas(k,i) = find_partials(f0(i), fk_ideal(k,i), string_spec(:,i), Fs, 0);
        
        % Calc partials' deviations from ideal harmonics for each string
        devs(k,i) = calc_devs(fk_ideal(k,i), fk_meas(k,i));
        
    end
    
    
    hold off;
    
    % convert fk_ideal vals to samples
    fk_ideal_samps(:,i) = round(freq2samp(fk_ideal(:,i), Fs, FFTsize));
    v = vline(fk_ideal_samps(:,i)');
end

k = 1:1:K;

% Polynomial fit using least squares approx.
% A*c = b. A is matrix of devs vs. indices. c is vector of coefficients in
% polynomial c1 + c2*x + c3*x^3 = devs. b is vector of devs for given index. 
A = zeros(K,3);
A(:,1) = ones(K,1);
A(:,2) = k';
A(:,3) = k'.^3;
c = zeros(3,num_strings);
for i = 1:1:num_strings
    c(:,i) = (inv(A'*A))*A'*devs(:,i);
end

figure; 
stem(k,devs(:,n));
xlabel('Partial number k');
ylabel('Deviation (Hz)');
% Poly form: y = a + b*x + 0*x^2 + d*x^3
a = c(1,n);
b = c(2,n);
d = c(3,n);
poly = b*k + d*k.^3;
hold on; plot(k,poly)


% Calculate new center of search windows for next iteration
for k = 1:1:Klist(iter+1)
   center(k,1) = b*k + d*k.^3; 
end



% ///////////
% Iteration 2
% ///////////

close all;

iter = iter + 1;
K = Klist(iter); % # of partials to calculate

devs = zeros(K,num_strings);
fk_ideal = zeros(K,num_strings);
fk_meas = zeros(K,num_strings);
fk_ideal_samps = zeros(K,num_strings);

for i = 1:1:num_strings

    figure; plot(string_spec(1:FFTsize/2,i)); hold on; grid on;
    xlabel(['samples n, N = ', num2str(FFTsize)]);
    ylabel('Power (dB)');
    
    for k = 1:1:K
        % Get ideal harmonic locations
        fk_ideal(k,i) = f0(i)*(k+1); 
        
        % Get measured inharmonic partials' locations
        fk_meas(k,i) = find_partials(f0(i), fk_ideal(k,i), string_spec(:,i), Fs, center(k));
        
        % Calc partials' deviations from ideal harmonics for each string
        devs(k,i) = calc_devs(fk_ideal(k,i), fk_meas(k,i));
        
    end
    
    
    hold off;
    
    % convert fk_ideal vals to samples
    fk_ideal_samps(:,i) = round(freq2samp(fk_ideal(:,i), Fs, FFTsize));
    v = vline(fk_ideal_samps(:,i)');
end

k = 1:1:K;

% Polynomial fit using least squares approx.
% A*c = b. A is matrix of devs vs. indices. c is vector of coefficients in
% polynomial c1 + c2*x + c3*x^3 = devs. b is vector of devs for given index. 
A = zeros(K,3);
A(:,1) = ones(K,1);
A(:,2) = k';
A(:,3) = k'.^3;
c = zeros(3,num_strings);
for i = 1:1:num_strings
    c(:,i) = (inv(A'*A))*A'*devs(:,i);
end

figure;
stem(k,devs(:,n));
xlabel('Partial number k');
ylabel('Deviation (Hz)');
% Poly form: y = a + b*x + 0*x^2 + d*x^3
a = c(1,n);
b = c(2,n);
d = c(3,n);
poly = b*k + d*k.^3;
hold on; plot(k,poly)


% Calculate new center of search windows for next iteration
for k = 1:1:Klist(iter+1)
   center(k,1) = b*k + d*k.^3; 
end





% ///////////
% Iteration 3
% ///////////

close all;

iter = iter + 1;
K = Klist(iter); % # of partials to calculate


devs = zeros(K,num_strings);
fk_ideal = zeros(K,num_strings);
fk_meas = zeros(K,num_strings);
fk_ideal_samps = zeros(K,num_strings);

for i = 1:1:num_strings

    figure; plot(string_spec(1:FFTsize/2,i)); hold on; grid on;
    xlabel(['samples n, N = ', num2str(FFTsize)]);
    ylabel('Power (dB)');
    
    for k = 1:1:K
        % Get ideal harmonic locations
        fk_ideal(k,i) = f0(i)*(k+1); 
        
        % Get measured inharmonic partials' locations
        fk_meas(k,i) = find_partials(f0(i), fk_ideal(k,i), string_spec(:,i), Fs, center(k));
        
        % Calc partials' deviations from ideal harmonics for each string
        devs(k,i) = calc_devs(fk_ideal(k,i), fk_meas(k,i));
        
    end
    
    
    hold off;
    
    % convert fk_ideal vals to samples
    fk_ideal_samps(:,i) = round(freq2samp(fk_ideal(:,i), Fs, FFTsize));
    v = vline(fk_ideal_samps(:,i)');
end

k = 1:1:K;

% Polynomial fit using least squares approx.
% A*c = b. A is matrix of devs vs. indices. c is vector of coefficients in
% polynomial c1 + c2*x + c3*x^3 = devs. b is vector of devs for given index. 
A = zeros(K,3);
A(:,1) = ones(K,1);
A(:,2) = k';
A(:,3) = k'.^3;
c = zeros(3,num_strings);
for i = 1:1:num_strings
    c(:,i) = (inv(A'*A))*A'*devs(:,i);
end

figure;
stem(k,devs(:,n));
xlabel('Partial number k');
ylabel('Deviation (Hz)');
title(['Partial Deviations for note n=', num2str(n), ', f0= ', num2str(f0(n)), ' Hz']);
% Poly form: y = a + b*x + 0*x^2 + d*x^3
a = c(1,n);
b = c(2,n);
d = c(3,n);
% poly = a + b*k + d*k.^3;
poly = b*k + d*k.^3; %trying to force y-intercept to 0
hold on; plot(k,poly)



% Plot ideal harmonics' frequencies vs. those of measured partials
% n = 6;
% figure; plot(fk_ideal(:,n),'o');
% hold on; plot(fk_meas(:,n),'x');
% legend('Ideal', 'Measured');
% xlabel('Partial number k');
% ylabel('Frequency (Hz)');
% grid on;

%% Extract B_s0

B_s0 = zeros(1, num_strings);

for i = 1:1:num_strings
    a = c(1,i);
    b = c(2,i);
    d = c(3,i);
    poly = b*k + d*k.^3;
    B_s0(i) = (2*d)/(f0(i)+b);
end

B_s0 = B_s0';

% plot
% figure; plot(midi0, B_s0, 'o');
% xlabel('MIDI note #');
% ylabel('Inharmonicity coefficient \beta');
% title('Inharmonicity vs. MIDI note #');


end