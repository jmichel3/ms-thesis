function checkf0(feats, varargin)
% CHECKF0(feats[, desiredNote])
% Utility to test accuracy of pitch estimation

figure;
if ~isempty(varargin)
    % Plot specified note number
    desiredNote = varargin{1};
    plot(feats.spec(:,desiredNote));
    xlim([feats.f0samp(desiredNote)-1600 feats.f0samp(desiredNote)+1599]);
    hold;
    plot([feats.f0samp(desiredNote) feats.f0samp(desiredNote)], ylim ,'r--');

    xlabel('samps'), ylabel('Amp (lin)'); title(['Detected f0, note ', num2str(desiredNote)])
    grid minor
    pause
    close;
else
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

end