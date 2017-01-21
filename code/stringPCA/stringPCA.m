%PCA testing...
Fs = 44100;

audio = load_data();

audio = fliplr(audio);

%normalize audio
maxvals = max(abs(audio), [], 1);
for i = 1:1:6
   audio(:,i) = audio(:,i)./maxvals(i); 
end

%% Calc spectrogram
close all;
wind = 11025; %window
FFTsize = 1024;
S_6E = spectrogram(audio(:,6),wind,floor(wind/2),FFTsize,Fs);
S_6E = abs(S_6E);
imagesc(S_6E)

%zero mean
for i = 1:1:FFTsize/2
    S_6E(i,:) = S_6E(i,:)*mean(S_6E(i,:));
end
% S_6E = S_6E - (S_6E)'*mean(S_6E,2);

% covariance matrix
A = S_6E*S_6E';

[V,D] = eig(A);

v1 = V(:,513);
[pk,idx]=max(abs(v1))
figure; plot(D)
figure; plot(v1)
