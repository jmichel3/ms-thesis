clc, close all, clear all

% Generate noisy lines
count = 2;
var = randn([count,1])+0.5;
lines = genLines(count,var);

% Plot them
plotLines(lines)

% Expectation Maximization
emAlg()