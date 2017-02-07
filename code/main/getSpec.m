function spec = getSpec(X, STARTms, LENms, Fs)
% SPEC = GETSPEC() Power spectrum calculation
%   GETSPEC(X, STARTms, LENms, Fs) computes and returns the power spectrum
%   of LENms milliseconds of audio beginning at t = STARTms ms. Fs is the
%   sampling frequency of audio input X. If X is an N x M matrix, GETSPEC
%   computes power spectrum of each column, returning an FFTsize x M matrix
%   (where FFTsize is defined in GETSPEC internally). Other details of the
%   employed DFT are also defined internally.

if STARTms ~= 0
   disp('warning: get_spec start_t != 0ms'); 
end

numNotes = size(X, 2);
start = floor(Fs*(STARTms/1000))+1;
N = floor(Fs*(LENms/1000)); %convert window length to samples (N)
w = hann(N);
FFTsize = FFTsize_const();

X = X(start:start+N-1,:);
w = repmat(w,[1,numNotes]);
window = X.*w;
spec = (abs(fft(window,FFTsize)));
spec((end/2)+1:end,:) = [];


end