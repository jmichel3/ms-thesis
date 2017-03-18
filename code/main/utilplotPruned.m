function utilplotPruned(feats)

numNotes = length(feats.midi0);

numStrings = floor(numNotes/13);
marker='o*^+sx';

dim1 = feats.midi0;
unit1 = 'midi #';
dim2 = feats.betaPruned;
unit2 = '\beta';
k = 15;
if isfield(feats, 'devsNorm')
    dim3 = feats.devsNorm(k,:);
    unit3 = ['normalized dev, k =', num2str(k)]
end

figure; hold; grid
for i=1:1:numStrings
    
%     Arow = 2;
%     scatter3(feats.midi0(start:finish),feats.B(start:finish),feats.A(Arow,start:finish),marker(i));
%     xlabel('midi #'); ylabel('beta');zlabel(['A_', num2str(Arow)])
    if isfield(feats,'devsNorm')
        start = 1+13*(i-1);
        finish = 13+13*(i-1);
        scatter3(dim1(start:finish), dim2(start:finish), dim3(start:finish), marker(i));
        xlabel(unit1); ylabel(unit2);zlabel(unit3);
    else
        scatter(dim1, dim2,'o');
        xlabel(unit1); ylabel(unit2);
    end
    
    title(['PRUNED: Chromatic Scales on Diff Guitar Strings'])
end

hold off;
end