notes = [1,10,20,30,40,50,60,70];
ords = [100,250,500];

% %---------------------------------
% % For testing deviations
% for n=1:1:length(notes)
%     disp(['Starting note ', num2str(n), ' of ', num2str(length(notes))])
%     figure('Name',feats.file,'NumberTitle','off')
%     for o=1:1:length(ords)
%         ARfeats = testAR(feats,notes(n),ords(o));
%         
%         subplot(length(ords),1,o); stem(ARfeats.devsAR);
%         title(['Note ', num2str(notes(n)), ', Ord = ', num2str(ords(o))]);
%         xlabel('Partial #'); ylabel('Deviation (Hz)');
%     end
% end

%---------------------------------
% For testing kth normalized deviation
for o=1:1:length(ords)
    figure('Name',feats.file,'NumberTitle','off')
    disp(['Starting ord ', num2str(o), ' of ', num2str(length(ords))])
    for n=1:1:feats.noteCount
        ARfeats = testAR(feats, n, ords(o));
        feats.ARdevsNorm(n) = ARfeats.devsNorm;
        disp(['finished note ', num2str(n)])
    end
    stem(feats.midi0, feats.ARdevsNorm)
    title(['Normalized kth Devs for Ord = ', num2str(ords(o))]);
    xlabel('midi #'); ylabel('Normalized Dev')
end
