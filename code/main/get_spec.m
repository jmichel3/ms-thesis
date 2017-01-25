function spec = get_spec(x, start, len_t, Fs)
% GET_SPEC Power spectrum calculation
%   GET_SPEC(x, start, len_t, Fs) computes and returns the power spectrum
%   of len_t milliseconds of audio beginning from x[start]. Fs is the
%   sampling frequency of audio input x. If x is an N x M matrix, GET_SPEC
%   computes power spectrum of each column, returning an FFTsize x M matrix
%   (where FFTsize is defined in GET_SPEC internally). Other details of the
%   employed DFT are also defined internally.

num_notes = size(x, 2);
N = floor(Fs*(len_t/1000)); %convert window length to samples (N)
wind = hann(N);
FFTsize = FFTsize_const();

% Init matrices
spec = zeros(FFTsize, num_notes);
windowed = zeros(N, num_notes);

% Get window and DFT power spectrum
for i = 1:1:num_notes
    x(start)
    x(start+N-1)
    i
   windowed(:,i) = x(start:start+N-1,i).*wind;
end

spec = 20*log10(abs(fft(windowed,FFTsize)));

end