function H = em(LINES)
% H = EM(LINES)
% Take in initial values of parameters. Return maximized expectation of
% those parameters given the data.

% Read vals
count = LINES.count;
var = LINES.var;
y = LINES.y;
x = LINES.x;
N = size(x,1);
x = [ones(N,1) x];

% What we're guessing. Begin with random init estimate
mHi = 1e-5;
intHi = -4e-4;
% slope = mHi * rand([count,1]);
slope = mHi * ones(count,1) + (mHi * rand([count,1]) - mHi/2)
% yInt = intHi * rand([count, 1]) - intHi/2;
yInt = intHi * ones(count,1);
beta = [yInt slope];

% Our hidden variables: z, label of mixture from which it came
z = zeros(N,count);

% Initial state of estimates
plotLines(LINES, beta);
title('Initial state')
pause;
close;

% Iterate until convergence
slopeOld = zeros(count,1);
iter = 1;
% while(abs((mean(slope)-mean(slopeOld))/mean(slopeOld)) > 0.01)
while(1)
    betaOld = beta;
    
    % e-step
    % Calculate expectation of hidden variable (mixture label) for each data point
    zDenom = zeros(N,1);
%     zDenom = [];

    % for each data point
    for i = 1:1:N
       for j = 1:1:count % for each line class
           z(i,j) = normpdf(y(i), beta(j,:)*x(i,:)', var(j))
       end
       zDenom(i) = sum(z(i,:));
    end
    zDenom = repmat(zDenom,[1,count]);
    z = z./zDenom

    % m-step
    % Update our hypotheses to the most likely ones using expectations in prev
    % step
    for j = 1:1:count
        W = diag(z(:,j))
%         beta(j,:) = ((x'*W*x)\x'*W*y(:,j))./sum(z(:,j));
        beta(j,:) = ((x'*W*x)\x'*W*y); 
%         beta(j,:) = lsqnonneg(x',y);
    end
    
    beta
    % Debug plotting
    plotLines(LINES, beta);
    title(['Iteration #', num2str(iter)]);
    pause;
    close;
    
    
    
    iter = iter + 1;
end

H.hHat = slope;
H.beta = beta;
H.W = W;
H.z = z;
H.x = LINES.x;
H.y = LINES.y;
H.iter = iter;
end