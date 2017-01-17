function y = norm1(x)
% norm1 Normalize Data
% 
% y = norm1(x) normalizes the values in column vector x (columns if x is a matrix) to -1
% and 1, and returns the scaled result in y.

if nargin ~= 1
    error('y = norm1(x) only takes one input. x must be matrix with column-wise data'); 
end

if size(x,1) == 1
    error('Input should be column vector');
end

max_vals = max(abs(x),[],1); 

for i = 1:1:size(x, 2)
    y(:,i) = x(:,i)./max_vals(i);
end


end