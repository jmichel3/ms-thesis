function [data] = load_data()
fileList = dir('./audio/*.wav');
N = size(fileList,1);
data = [];
Fs = 44100;
for i = 1:N
    % Read in each string audio
    string = audioread(['./audio/' fileList(i,1).name], [1 13*Fs]);
    
    % 
    data(:,i) = string(:);
end
end