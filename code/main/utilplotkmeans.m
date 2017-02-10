function utilplotkmeans(LABELS, FEATS)

numNotes = length(FEATS.midi0);
marker='o*^+sx';

dim1 = FEATS.midi0;
dim2 = FEATS.beta;
dim3 = FEATS.devsNorm(9,:);

for i = 1:1:size(LABELS,2)
    figure;
    hold;
    for j = 1:1:numNotes
        ax = gca;
        ax.ColorOrderIndex = 1;
        scatter3(dim1(j), dim2(j), dim3(j), marker(LABELS(j,i))); 
    end
    grid minor
    xlabel('samps'); ylabel('\beta'), title('k-means');
    pause;
    close;
end

% numStrings = floor(numNotes/13);

% 
% figure; hold; grid
% for i=1:1:numStrings
%     start = 1+13*(i-1);
%     finish = 13+13*(i-1);
% %     Arow = 2;
% %     scatter3(feats.midi0(start:finish),feats.B(start:finish),feats.A(Arow,start:finish),marker(i));
% %     xlabel('midi #'); ylabel('beta');zlabel(['A_', num2str(Arow)])
%     scatter3(feats.midi0(start:finish),feats.beta(start:finish),feats.A(start:finish),marker(i));
%     xlabel('midi #'); ylabel('\beta');zlabel(['mean(A_r_k)']);
%     title(['Chromatic Scales on Diff Guitar Strings'])
% end

hold off;

end