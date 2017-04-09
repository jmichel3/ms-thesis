function plotSpectralClustering(FEATS, C)

[i,j,val] = find(C);

figure; hold;
colorOrd = 'rgbymc';
for k=1:1:size(C,2)
    idx = find(j==k);
    x = FEATS.midi0(idx);
    y = FEATS.beta(idx);
    scatter(x,y,colorOrd(k));
end
grid on;

end