function f = spectralFlux2(x,frame,hop,Fs)
% attempting vectorized fft implementation, not faster for some reason.

% Parameters
x = x / max(abs(x));
L = length(x);
numFrames = floor((L-frame)/hop) + 1;
w = hanning(frame);




% Initialize output f
f = zeros(numFrames,1);

tic
% Enumerate signal frames into matrix
P = frame - hop;
frames = buffer(x,frame,P);
wMat = repmat(w,[1,size(frames,2)]);
frames = frames.*wMat;

% Evaluate spectral magnitudes
FFT = abs(fft(frames,2*frame,1));
FFT(frame+1:end,:) = [];

% Evaluate Flux
FFTnew = FFT(:,2:end);
FFT = FFT(:,1:end-1);
SF = ((FFTnew - FFT) + abs(FFTnew - FFT)) / 2; %half-wave rectification
f = sum(SF,1);
f = [0, f];

toc




end