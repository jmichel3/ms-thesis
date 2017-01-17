function devs = calc_devs(fk_ideal, fk_meas)
% Calculate partials' deviations
% Inputs:
%   fk_ideal - ideal harmonic locations
%   fk_meas - measured partials' locations
% Outputs: 
%   devs - vector of partial's deviations

devs = fk_meas - fk_ideal;

end