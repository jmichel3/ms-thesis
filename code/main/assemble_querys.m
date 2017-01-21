function y = assemble_querys(x,N)
% Inputs:
% x - input signal
% N - size of query signals
% Outputs:
% y - D x M matrix. D is dimensionality (i.e. N), M is number of querys (length(x)-N)

for i = 1:1:length(x)-(N-1)
    y(:,i) = x(i:i+N-1);
end