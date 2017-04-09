function [obj] = kLinReg_computeObj(X, y, W, a)
% A = KLINREG_UPDATECENTER(X, C)
% k-means for linear regressions. Compute objective step.

N = size(X,1);

obj = 0;
for i=1:1:N
    % Get assignment of i'th datapoint
    assignment = a(i);
    
    % Compute error between true y and regressed y
    obj = obj + (y(i) - ( W(assignment,1)+W(assignment,2)*X(i)) )^2;
end


end