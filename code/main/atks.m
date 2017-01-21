atks = [Eatk,Aatk,Datk,Gatk,Batk,eatk];

% normalize
amp = max(abs(atks),[],1);
for i = 1:1:size(atks,2)
    atks(:,i) = atks(:,i)/amp(i);
end

% zero-mean
mu = mean(atks,2);
mu = repmat(mu,1,6);
atks = atks - mu;


%% do they sound different???
wind = hann(size(atks,2));

for i = 1:1:size(atks,1)
    soundsc(wind'.*atks(i,:),Fs);
    pause(0.2);
end

%% PCA

[V,D] = PCA(atks);
