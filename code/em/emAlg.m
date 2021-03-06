function h = emAlg(LINES)
% EMALG()
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
slope = 2*rand([count,1]);
yInt = 2*rand([count, 1])-5;
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
    slopeOld = slope;
    
    % e-step
    % Calculate expectation of hidden variable (mixture label) for each data point
    zDenom = zeros(N,1);
%     zDenom = [];

    % for each data point
    for i = 1:1:N
       for j = 1:1:count % for each line class
           z(i,j) = normpdf(y(i,j), beta(j,:)*x(i,:)', var(j));
       end
       zDenom(i) = sum(z(i,:));
    end
    zDenom = repmat(zDenom,[1,count]);
    z = z./zDenom;

    % m-step
    % Update our hypotheses to the most likely ones using expectations in prev
    % step
    for j = 1:1:count
        W = diag(z(:,j));
        beta(j,:) = (inv(x'*W*x)*x'*W*y(:,j))./sum(z(:,j)); 
    end
    
    beta
    % Debug plotting
    plotLines(LINES, beta);
    title(['Iteration #', num2str(iter)]);
    pause;
    close;
    
    
    
    iter = iter + 1;
end

h.hHat = slope;
h.beta = beta;
h.W = W;
h.z = z;
h.x = LINES.x;
h.y = LINES.y;
h.iter = iter;
end