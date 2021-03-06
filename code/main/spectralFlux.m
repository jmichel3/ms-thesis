function f = spectralFlux(x,frame,hop)
% SPECTRALFLUX Rectified spectral flux (Dixon 2006, Bello 2005).
%
% Adapted from:
% Theodoros Giannakopoulos
% Department of Informatics and Telecommunications
% University of Athens, Greece
% 
% SPECTRALFLUX(x,frame,hop)
% x: input signal
% frame: frame size (samples)
% hop: hop size (samples)

% Parameters
x = x / max(abs(x));
L = length(x);
numFrames = floor((L-frame)/hop) + 1;
w = hann(frame);

% Initialize frame pointer, output f
f = zeros(numFrames,1);
curPos = 1;

% Loop through frames
tic
for (i=1:numFrames)
    window = w.*(x(curPos:curPos+frame-1));    
    FFT = (abs(fft(window,2*frame)));
    FFT = FFT(1:frame);
%     FFT = FFT / max(FFT);
    if (i>1)
        hwr = ((FFT-FFTprev) + abs(FFT-FFTprev))/2; % half-wave-rectification, Dixon 2006
        f(i) = sum(hwr);
    else
        f(i) = 0;
    end
    curPos = curPos + hop;
    FFTprev = FFT;
end
toc

end
