function feats = polyFit(notes_spec, f0, K, B, Fs)
% POLYFIT(notes_spec, f0, K, B, Fs)

% Initialize parameters
numNotes = size(notes_spec, 2);
devs = zeros(K, numNotes);
fkMeas = zeros(K, numNotes);
FFTsize = FFTsize_const();
searchCenter = zeros(K,numNotes);

fkIdeal = [];
for k = 1:1:K
    fkIdeal = [fkIdeal; k*f0];
end

% For each note...
for i = 1:1:numNotes
    i
    % and for each partial/harmonic index...
    for k = 1:1:K
%         k
        % Init search centers from previous estimate of inharmonicity
%         k
%         B
%         f0(i)
        searchCenter(k,i) = k * f0(i) * sqrt(1 + B(i) * k^2);
        
        % Search window about center for actual partial locations
        [A(k,i), fkMeas(k,i)] = findPartials(f0(i), searchCenter(k,i), notes_spec(:,i), Fs);
        
        %DEBUGGING
%         figure; plot(notes_spec(1:end/8,i)); hold
%         fkMeasSamp = freq2samp(fkMeas(k,i),Fs,FFTsize);
%         fkIdealSamp = freq2samp(fkIdeal(k,i),Fs,FFTsize);
%         f0samp = freq2samp(f0(i),Fs,FFTsize);
%         
%         meas = [fkMeasSamp, fkMeasSamp];
%         ideal = [fkIdealSamp, fkIdealSamp];
%         y = [max(notes_spec(:,i)), 0];
%         plot(meas,y, 'c-.');
%         plot(ideal,y,'r--');
% %         xlim([searchCenter(k,i)-f0samp, searchCenter(k,i)+f0samp]);
% %         k = waitforbuttonpress;
%         hold off; 
%         close;
    
    end
    

%     line([fkMeasSamp fkMeasSamp], [100*ones(K,1) 0*ones(K,1)]);
%     line([fkIdealSamp fkIdealSamp], [100*ones(K,1) 0*ones(K,1)]);
%     k = waitforbuttonpress
end

% Return deviation from ideal harmonics' locations
devs = fkMeas - fkIdeal;

% Return deviations' ratios
devsRatio = (fkMeas./fkIdeal).^2;

% Polynomial fit using(Abesser)

% Polynomial fit using non-negative least squares approximation (barbancho)
k = 1:1:K;
C = zeros(K,2);
C(:,1) = k';
C(:,2) = k'.^3;
% C(:,3) = k'.^3;
d = devs;
for i = 1:1:numNotes
   x(:,i) = lsqnonneg(C, d(:,i)); 
   poly(:,i) = x(1,i)*k + x(2,i)*k.^3;
%    poly(:,i) = x(1,i) + x(2,i)*k + x(3,i)*k.^3;
   B(1,i) = (2.* x(2,i)) ./ (f0(i) + x(1,i));
end
feats.poly = poly;

% % Introduce y-offset?
% k = 1:1:K;
% C = zeros(K,2);
% C(:,1) = ones(K,1);
% C(:,2) = k';
% C(:,3) = k'.^3;
% for i = 1:1:numNotes
%    lsqnonneg() 
% end

feats.devs = devs;
feats.devsNorm = devs./repmat(f0,[K,1]);
feats.B = B;
feats.A = 10.^(A./20); % partials' ampltudes

samp0 = freq2samp(f0,Fs,FFTsize);
% Af0 = []; 
for i=1:1:length(samp0)
    Af0(i) = notes_spec(samp0(i),i);
end
Af0 = repmat(Af0,[K,1]);
feats.A = Af0./A;
% feats.A = mean(A,1);
feats.fkMeas = fkMeas;


K = 1; k = 1:1:K; 
C = []; C(:,1) = ones(K,1); C(:,2) = k;
% x = zeros(2,numNotes);
ord = 1;
x = linspace(1,K,K)';
for i = 1:1:numNotes
    P(i,:) = polyfit(x, feats.A(K,i), ord);
%     x(:,i) = lsqnonneg(C,-feats.A(1:K,i));
end
% feats.mA = x(2,:); % get only slope
P = P';
feats.mA = (P(ord+1,:));

% Polynomial fit using least squares nonlinear with spec'd bounds
% k = 1:1:K;
% C = zeros(K,3);
% C(:,1) = ones(K,1);
% C(:,2) = k';
% C(:,3) = k'.^3;
% d = devs;
% for i = 1:1:numNotes
%    x(:,i) = lsqnonneg(@(), d(:,i));
%    poly(:,i) = x(1,i) + x(2,i)*k + x(3,i)*k.^3;
%    B(1,i) = (2.* x(2,i)) ./ (f0(i) + x(1,i));
% end

end
