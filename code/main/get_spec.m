function spec = get_spec(x, start, len_t, Fs)
% GET_SPEC Power spectrum calculation
%   GET_SPEC(x, start, len_t, Fs) computes and returns the power spectrum
%   of len_t milliseconds of audio beginning from x[start]. Fs is the
%   sampling frequency of audio input x. If x is an N x M matrix, GET_SPEC
%   computes power spectrum of each column, returning an FFTsize x M matrix
%   (where FFTsize is defined in GET_SPEC internally). Other details of the
%   employed DFT are also defined internally.

if start ~= 1
   error('argument start != 1'); 
end

numNotes = size(x, 2);
N = floor(Fs*(len_t/1000)); %convert window length to samples (N)
w = hann(N);
FFTsize = FFTsize_const();

x(start+N:end,:) = [];
w = repmat(w,[1,numNotes]);
window = x.*w;
spec = 10*log10(abs(fft(window,FFTsize)));
spec((end/2)+1:end,:) = [];

end