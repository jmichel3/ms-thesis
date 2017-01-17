function soundcols(x,Fs)
% Consecutively plays the columns of audio data matrix x from left to
% right. Useful for playing matrices that hold ordered equal-length audio.
%   x - input matrix of audio. audio data are column vectors.
%   Fs - sampling rate at which to play back cols(x)

if nargin ~= 2
    error('soundcols() needs two inputs: x and Fs. See help.');
end

for i = 1:1:size(x,2)
   soundsc(x(:,i),Fs)
   pause(size(x,1)/Fs);
end

end