function GX = gaussian(X,MEAN,VAR)
% GAUSSIAN(X, MEAN, VAR)
% Return g(x), a Gaussian p.d.f with parameters MEAN and VAR
% evaluated at X.

GX = (1/sqrt(2*pi*VAR))*exp(-(X-MEAN)^2/(2*VAR));

% % debug
% t = linspace(-5,5,50);
% mean = 0;
% var = 1;
% gt = (1/sqrt(2*pi*var))*exp(-(t-mean).^2./(2*var));
% figure;
% plot(t,gt);

end