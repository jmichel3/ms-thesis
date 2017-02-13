function checkfk(FEATS, NOTE, varargin)
% CHECKFK(FEATS, NOTE[, K])
% Utility to test accuracy of partial (fk) detection. FEATS is your struct,
% NOTE is your desired note (integer #, column in notes matrix) to check.
% Optional K is the Kth partial whose plot you'd like to jump to.

figure;
if ~isempty(varargin)
    % Plot only partials from k to end
    for k = varargin{1}:1:size(FEATS.fkMeas,1)
        plot(20*log10(FEATS.spec(:,NOTE)));
    %     fkIdeal_samp = freq2samp(k*FEATS.f0(NOTE), FEATS.Fs, FEATS.FFTsize);
    %     fkMeas_samp = freq2samp(FEATS.fkMeas(k), FEATS.Fs, FEATS.FFTsize);
        xlim([FEATS.fkIdealSamp(k,NOTE)-FEATS.f0samp(NOTE)/2 FEATS.fkIdealSamp(k,NOTE)+FEATS.f0samp(NOTE)/2]);
        hold;
        plot([FEATS.fkIdealSamp(k,NOTE) FEATS.fkIdealSamp(k,NOTE)], ylim ,'r--');
        plot([FEATS.fkMeasSamp(k,NOTE) FEATS.fkMeasSamp(k,NOTE)], ylim ,'c--');
        plot([FEATS.searchCenterSamp(k,NOTE) FEATS.searchCenterSamp(k,NOTE)], ylim, 'k:');

        xlabel('samps'), ylabel('Power (dB)'); title([num2str(k),'*F0 (red) vs #', num2str(k), ' partial (cyan), of note ', num2str(NOTE)]);
        grid minor
        pause
        close;
    end
        
else
    % Else plot all partials sequentially
    for k = 1:1:size(FEATS.fkMeas,1)
        plot(20*log10(FEATS.spec(:,NOTE)));
    %     fkIdeal_samp = freq2samp(k*FEATS.f0(NOTE), FEATS.Fs, FEATS.FFTsize);
    %     fkMeas_samp = freq2samp(FEATS.fkMeas(k), FEATS.Fs, FEATS.FFTsize);
        xlim([FEATS.fkIdealSamp(k,NOTE)-FEATS.f0samp(NOTE)/2 FEATS.fkIdealSamp(k,NOTE)+FEATS.f0samp(NOTE)/2]);
        hold;
        plot([FEATS.fkIdealSamp(k,NOTE) FEATS.fkIdealSamp(k,NOTE)], ylim ,'r--');
        plot([FEATS.fkMeasSamp(k,NOTE) FEATS.fkMeasSamp(k,NOTE)], ylim ,'c--');
        plot([FEATS.searchCenterSamp(k,NOTE) FEATS.searchCenterSamp(k,NOTE)], ylim, 'k:');

        xlabel('samps'), ylabel('Power (dB)'); title([num2str(k),'*F0 (red) vs #', num2str(k), ' partial (cyan), of note ', num2str(NOTE)]);
        grid minor
        pause
        close;
    end
end

end