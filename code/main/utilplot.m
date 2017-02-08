function utilplot(feats)

numNotes = length(feats.midi0);

numStrings = floor(numNotes/13);
marker='o*^+sx';

figure; hold; grid
for i=1:1:numStrings
    start = 1+13*(i-1);
    finish = 13+13*(i-1);
%     Arow = 2;
%     scatter3(feats.midi0(start:finish),feats.B(start:finish),feats.A(Arow,start:finish),marker(i));
%     xlabel('midi #'); ylabel('beta');zlabel(['A_', num2str(Arow)])
    scatter3(feats.midi0(start:finish),feats.beta(start:finish),feats.A(start:finish),marker(i));
    xlabel('midi #'); ylabel('\beta');zlabel(['mean(A_r_k)']);
    title(['Chromatic Scales on Diff Guitar Strings'])
end

hold off;
end