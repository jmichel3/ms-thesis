% addpath('../matlab_toolboxes/MIR/MIRToolbox')
close all; clear all; clc;
    
%PCA testing...
Fs = 44100;

audio = load_data();

audio = fliplr(audio);

%normalize audio
maxvals = max(abs(audio), [], 1);
for i = 1:1:6
   audio(:,i) = audio(:,i)./maxvals(i); 
end

%% Locate onsets' max
s = 6; %which strings?

[p,l] = findpeaks(audio(:,s),'MinPeakHeight',0.4,'MinPeakDistance',20000);


%% Declare attack regions

P = size(p,1);
beg = 3000; %"beggining" point... how far back to capture attack region
atk = zeros(beg,P);

for i = 1:1:P
    atk(:,i) = audio(l(i)-beg:l(i)-1,s);
end

H = hann(beg);
H = repmat(H,1,P);

atk_wind = atk.*H;

%% demo sound

for i = 1:1:P
   soundsc(atk_wind(:,i),Fs)
   plot(atk(:,i))
   pause(1);
end


%% FFT of attack region

N = 4096;
atk_fft = abs(fft(atk_wind,N,1));

atk_fft = atk_fft';
atk_fft(:,N/4:end) = [];
atk_fft = atk_fft';

figure, plot(atk_fft(:,1))

%% PCA

X = atk_fft;
u = mean(X,2);
u = repmat(u,1,P);

%Normalize
X = X-u;

[V,D] = PCA(X);


%% Plot

figure;
for i = 1:1:1
    plot(abs(V(:,N/4-i)));
    hold on;
end

figure; plot(D)
