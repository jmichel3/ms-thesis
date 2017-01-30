function spec = get_spec(x, start_t, len_t, Fs)
% GET_SPEC Power spectrum calculation
%   GET_SPEC(x, start_t, len_t, Fs) computes and returns the power spectrum
%   of len_t milliseconds of audio beginning from x[start]. Fs is the
%   sampling frequency of audio input x. If x is an N x M matrix, GET_SPEC
%   computes power spectrum of each column, returning an FFTsize x M matrix
%   (where FFTsize is defined in GET_SPEC internally). Other details of the
%   employed DFT are also defined internally.

if start_t ~= 0
   disp('warning: argument start_t != 0ms'); 
end

numNotes = size(x, 2);
start = floor(Fs*(start_t/1000))+1;
N = floor(Fs*(len_t/1000)); %convert window length to samples (N)
w = hann(N);
FFTsize = FFTsize_const();

x = x(start:start+N-1,:);
w = repmat(w,[1,numNotes]);
window = x.*w;
spec = (abs(fft(window,FFTsize)));
spec((end/2)+1:end,:) = [];


end