function checkf0(feats)
% Utility to test accuracy of pitch estimation

figure;
for i = 1:1:feats.noteCount
    plot(feats.spec(:,i));
    xlim([feats.f0samp(i)-1600 feats.f0samp(i)+1599]);
    hold;
    plot([feats.f0samp(i) feats.f0samp(i)], ylim ,'r--');
    
    xlabel('samps'), ylabel('Amp (lin)'); title(['Detected f0, note ', num2str(i)])
    grid minor
    pause
    close;
end

end