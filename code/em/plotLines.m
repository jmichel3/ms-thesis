function plotLines(LINES, varargin)
% PLOTLINES(LINES[, BETA])
% Scatterplots of the lines described in your LINES struct. If BETA
% argument is included, plotLines superimposes those EM-derived slopes and
% their y-intercepts (the regressor vector of coeffs) onto the data.
% size(BETA) should be (LINES.COUNT x 2)

figure;
hold;
for i = 1:1:LINES.count
   scatter(LINES.x, LINES.y(:,i)) 
end
hold;

grid minor;


if ~isempty(varargin)
   hold
   for i = 1:1:LINES.count
       plot(LINES.x, varargin{1}(i,1)*1 + varargin{1}(i,2)*LINES.x)
   end
   hold
end

end