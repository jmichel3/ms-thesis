function B_sn = get_Bsn(B_s0)
% Obtain B(s,n) for every string (s) - fret (n) combo in question. 
% Inputs:
%   B_s0, 6-dimensional column vector whose elements are
%   open-string B's for each 6 strings.
% Outputs: 
%   B_sn is a matrix with dimensions s x n.

if size(B_s0,1) ~= 6
    error('B_s0 needs to be column vector of length 6');
end

B_sn = zeros(6,13);
B_sn(:,1) = B_s0;

for i=1:1:6 % loop thru strings
    for j = 1:1:12 % loop thru fret numbers
        B_sn(i,j+1) = B_s0(i)*2^(j/6);
    end
end

end