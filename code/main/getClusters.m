function LABELS = getClusters(FEATS, ALG)
% LABELS = GETCLUSTERS(FEATS, ALG)
% Define number of clusters, K, and number of trials internally.

dim1 = FEATS.midi0;
dim2 = FEATS.beta;
dim3 = FEATS.devsNorm(9,:);

if isequal(ALG,'kmeans')
    data = [dim1' dim2' dim3'];
    K = 6;
    numTrials = 10;
    for i = 1:1:numTrials
        LABELS(:,i) = kmeans(data,6);
        disp(['Completed trial ', num2str(i), ' of ', num2str(numTrials)]);
    end

else if isequal(ALG, 'spectral')
    K = 6;
    data = [dim1' dim2' dim3'];
%     data = data * data';
    numData = size(data,1);
    
    %Form affinity matrix
    A = [zeros(numData,numData)];
    sigmasq = 2;
    for i = 1:numData
        for j = 1:numData
            if i == j
                A(i,j) = 0;
            else
                A(i,j) = exp(-norm(data(i,:)-data(j,:))/(2*sigmasq));
            end
%             A(i,j) = ()
            
        end
    end
    
    % Define D, construct L
    numRows = size(A,1);
    D = [zeros(numRows,numRows)];
    for i = 1:numRows
        D(i,i) = sum(A(i,:));
    end
    L = (D^-1/2)*(A)*(D^-1/2);
    
    % Get eigenvectors of L, place in cols of X
    [eVecs,eVals] = eig(L);
    X = [zeros(size(eVecs,1),K)];
    for i = 1:K
       X(:,i) = eVecs(:,i);
    end

    % Normalize
    Y = [zeros(size(X))];
    for i = 1:size(X,1)
       for j = 1:size(X,2)
          Y(i,j) = X(i,j)/norm(X(i,:));
       end
    end
    
    % kmeans in new Eigen-space
    numTrials = 10;
    for i = 1:1:numTrials
        LABELS(:,i) = kmeans(Y,6);
        disp(['Completed trial ', num2str(i), ' of ', num2str(numTrials)]);
    end
    
    end % alg = 'spectral'
end

end