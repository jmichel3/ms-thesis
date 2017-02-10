function utilplot(feats)

numNotes = length(feats.midi0);

numStrings = floor(numNotes/13);
marker='o*^+sx';

dim1 = feats.midi0;
unit1 = 'midi #';
dim2 = feats.beta;
unit2 = '\beta';
dim3 = feats.devsNorm(9,:);
unit3 = 'normalized dev, k=9'

figure; hold; grid
for i=1:1:numStrings
    start = 1+13*(i-1);
    finish = 13+13*(i-1);
%     Arow = 2;
%     scatter3(feats.midi0(start:finish),feats.B(start:finish),feats.A(Arow,start:finish),marker(i));
%     xlabel('midi #'); ylabel('beta');zlabel(['A_', num2str(Arow)])
    scatter3(dim1(start:finish), dim2(start:finish), dim3(start:finish), marker(i));
    xlabel(unit1); ylabel(unit2);zlabel(unit3);
    title(['Chromatic Scales on Diff Guitar Strings'])
end

hold off;
end