function assignments = kLinReg(FEATS, K)

% Init LinReg means
xIntLo = 35;
xIntHi = 63;
% mLo = .05e-4;
% mHi = .3e-4;
mLo = .3e-4;
mHi = .05e-4;
% yIntLo = -mLo*xIntLo;
% yIntHi = -mHi*xIntHi;
% yIntHi = -mLo*xIntLo;
yIntHi = -1e-4;
yIntLo = -1e-3;

% Plot convenience vars
xlimlo = 39; xlimhi = 76;
ylimlo = 0; ylimhi = 7e-4;

% Bound lines' weight vector estimates
for i=1:1:K
    intercepts = linspace(yIntLo,yIntHi,K);
    slopes = linspace(mLo,mHi,K);
    w(i,1) = intercepts(i);
    w(i,2) = slopes(i);
end

% Obtain dummy lines for visualization
N = 100;
dum = [linspace(0,100,N)];
for i=1:1:K
    y(:,i) = w(i,1) + w(i,2).*dum;
end
plot(y);
xlim([xlimlo xlimhi]); ylim([ylimlo ylimhi]); grid;
k = waitforbuttonpress;

% Perform initial assignments
assignments = kLinReg_updateAssign(FEATS.midi0', FEATS.beta', w);

% Compute initial error
objOld = kLinReg_computeObj(FEATS.midi0', FEATS.beta', w, assignments);

% Update centers
w = kLinReg_updateCenter(FEATS.midi0', FEATS.beta', assignments);

% Compute objective
obj = kLinReg_computeObj(FEATS.midi0', FEATS.beta', w, assignments)

% if obj change, update assignments and update centers
iter = 1;
figure; hold;
while (objOld ~= obj && iter < 100)
    objOld = obj;
    iter = iter+1
    
    % Update assignments
    assignments = kLinReg_updateAssign(FEATS.midi0', FEATS.beta', w);
    
    % Update centers
    w = kLinReg_updateCenter(FEATS.midi0', FEATS.beta', assignments);
    
    % Compute objective
    obj = kLinReg_computeObj(FEATS.midi0', FEATS.beta', w, assignments);

end

% Obtain dummy lines for visualization
N = 100;
dum = [linspace(0,100,N)];
for i=1:1:K
    y(:,i) = w(i,1) + w(i,2).*dum;
end
plot(y);
xlim([xlimlo xlimhi]); ylim([ylimlo ylimhi]); grid;
k = waitforbuttonpress;

end