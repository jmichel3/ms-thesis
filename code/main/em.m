function H = em(LINES)
% H = EM(LINES)
% Take in initial values of parameters. Return maximized expectation of
% those parameters given the data.
%
% *** Only works on 1-dimensional observations right now ***
%

% Read vals
count = LINES.count;
% var = LINES.var;
y = LINES.y;
x = LINES.x;
N = size(x,1);
x = [ones(N,1) x];
% P = LINES.dim;
P = 1;

% Convenience vars
xlimlo = 39; xlimhi = 76;
ylimlo = 0; ylimhi = 7e-4;

% What we're guessing. Begin with random init estimate
% mHi = 5;
% intHi = 5;
% slope = ones([countet,1])+[0;2;4];
% % slope = mHi * ones(count,1) + .000004*[0;1]
% yInt = intHi * rand([count, 1]) - intHi/2;
% % yInt = 0 * ones(count,1);
% beta = [yInt slope];
% pMix = (1/count)*ones(count,1)
% var = 0.5*ones(count,1)

% OR... begin with reasonable string estimates based on data
xInt = [35; 42; 45; 57; 47; 63]
slope = [.3e-4; .2e-4; .1e-4; .15e-4; .05e-4; .08e-4];
yInt = -slope.*xInt;
beta = [yInt slope];
pMix = (1/count)*ones(count,1)
var = 1e-05*ones(count,1)

% Our hidden variables: z, label of mixture from which it came
z = zeros(N,count);

% Initial state of estimates
plotLines(LINES, beta);
title('Initial state')
xlim([xlimlo xlimhi]); ylim([ylimlo, ylimhi]);
pause;
close;

% Iterate until convergence
betaOld = zeros(count,P+1);
iter = 1;
pickJ = ceil(rand(1));
while(norm(beta(pickJ,:) - betaOld(pickJ,:))/norm(betaOld(pickJ,:)) > 0.05)
% while(1)
    pMixOld = pMix;
    betaOld = beta;
    varOld = var;
    
    % e-step
    % Calculate expectation of hidden variable (mixture label) for each data point
    zDenom = zeros(N,1);
%     zDenom = [];

    % for each data point
    for i = 1:1:N
       for j = 1:1:count % for each line class
           z(i,j) = pMix(j)*normpdf(y(i), beta(j,:)*x(i,:)', var(j));
       end
       zDenom(i) = sum(z(i,:));
    end
    zDenom = repmat(zDenom,[1,count]);
    z = z./zDenom

    % m-step
    % Update our hypotheses to the most likely ones using expectations in prev
    % step
    for j = 1:1:count
        pMix(j) = sum(z(:,j))/N;
        W = diag(z(:,j));
%         beta(j,:) = ((x'*W*x)\x'*W*y(:,j))./sum(z(:,j));
        beta(j,:) = ((x'*W*x)\x'*W*y) 
%         beta(j,:) = lsqnonneg(W*x,y)

%         var(j) = (z(:,j)'*(y - x*beta(j,:)').^2)/sum(z(:,j))
        
        % Restrict components to share common variance
%         var(j) = (z(:,j)'*(y - x*beta(j,:)').^2)/sum(z(:,j))
        var(j)
        
    end
    
    norm(beta(pickJ,:) - betaOld(pickJ,:))/norm(betaOld(pickJ,:));
    
    % Debug plotting
    plotLines(LINES, beta);
    title(['Iteration #', num2str(iter)]);
    xlim([xlimlo xlimhi]); ylim([ylimlo, ylimhi]);
    pause;
    close;
    
    
%     pickJ = ceil(count*rand(1))
    iter = iter + 1;
end

plotLines(LINES, beta);
title(['CONVERGED at iter=', num2str(iter)]);
xlim([xlimlo xlimhi]); ylim([ylimlo, ylimhi]);
pause;
close;
    
H.beta = beta;
H.W = W;
H.z = z;
H.x = LINES.x;
H.y = LINES.y;
H.iter = iter;
end