% close all; clear all; clc;

addpath ../ml

% load('atk_unid.mat');
% load('atk6E.mat');
% load('atk4D.mat');

%remember, k-nn code takes dimensions needing transpose

%test signal
N = 128;
wind = hann(N);
query = abs(fft(atk_unid,N))'; %loaded with 2 E's, 1 e., 1 D
wind = (repmat(wind,1,4))';
query = query.*wind;

%N x D matrix. N number of vectors. D is doimensionality.
data = [atk1e'; atk2b'; atk3G'; atk4D'; atk5A'; atk6E';];
data = abs(fft(data,N,2));
wind = hann(N);
wind = repmat(wind',size(data,1),1);
data = data.*wind;

%normalize
maxval = max(abs(query),[],2);
maxval = repmat(maxval,1,128);
query = query.*(1./maxval);

maxval = max(abs(data),[],2);
maxval = repmat(maxval,1,128);
data = data.*(1./maxval);

k = 3;
[neighborIds neighborDistances] = kNearestNeighbors(data, query, k)