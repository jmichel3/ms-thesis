function checkfk(FEATS,NOTE,numK)
% CHECKFK(feats,note,numK)
% Utility to test accuracy of partial (fk) detection. FEATS is your struct,
% numK is the number of partials to sequentially check/display. NOTE is
% your desired note (integer #, column in notes matrix) to check.

figure;
for k = 1:1:numK
    plot(20*log10(FEATS.spec(:,NOTE)));
%     fkIdeal_samp = freq2samp(k*FEATS.f0(NOTE), FEATS.Fs, FEATS.FFTsize);
%     fkMeas_samp = freq2samp(FEATS.fkMeas(k), FEATS.Fs, FEATS.FFTsize);
    xlim([FEATS.fkIdealSamp(k,NOTE)-1600 FEATS.fkIdealSamp(k,NOTE)+1599]);
    hold;
    plot([FEATS.fkIdealSamp(k,NOTE) FEATS.fkIdealSamp(k,NOTE)], ylim ,'r--');
    plot([FEATS.fkMeasSamp(k,NOTE) FEATS.fkMeasSamp(k,NOTE)], ylim ,'c--');
    
    xlabel('samps'), ylabel('Power (dB)'); title([num2str(k),'*F0 (red) vs #', num2str(k), ' partial (cyan), of note ', num2str(NOTE)]);
    grid minor
    pause
    close;
end

end