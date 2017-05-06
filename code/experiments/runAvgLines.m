function getLinReg(FEATS)
% W = GETLINREG(FEATS)
% Perform linear regression for each strings' inharmonicities. FEATS is a
% cell array of feats structures, and GETLINREG() aggregates strings across
% these feats structs to perform the linear regression.
% Returns W, the matrix containing slope and intercept coefficients on the
% regression.

assert(iscell(FEATS),'FEATS must be a cell array whose elements are feature structs')

for i = 1:length(FEATS)
   noteCounts = FEATS{i}.noteCount; 
end
% Create 
X = [];
for i = 1:length(FEATS)
    X(:,i) = [FEATS{i}.midi0'];
    Y(:,i) = FEATS{i}.beta';
end

%% Linear Regression for collection of each string
w = ones(2,6);
W = ones(39,2);
% scatter(X())
for s = 1:6
    disp(s)
    start = ((s-1)*13)+1
    stop = start + 12
    W = X(start:stop,:);
    disp('hi')
    W = [W; X(start+78:stop+78,:)];
    disp('hi there')
    W = [W; X(start+78*2:stop+78*2,:)];
    disp('why hello')
    A = [ones(39,1), W(:,1)];
    disp('got here?')
    w(:,6-s+1) = A \ W(:,2)
%     w(6-s+1,:)
    disp('or here?')
end

%%

end