%% Load the test data
load('chanlocs.mat');
load('vector.mat');

%% v4 interpolation
plotScalpMap(bValues, chanlocs, 'v4', ...
    true, [0.75, 0.75, 0.75], [0 0 0], 'Using v4 interpolation'); 

%% linear interpolation
plotScalpMap(bValues, chanlocs, 'linear', ...
    true, [0.75, 0.75, 0.75], [0 0 0], 'Using linear interpolation'); 
 
%% cubic interpolation
plotScalpMap(bValues, chanlocs, 'cubic', ...
    true, [0.75, 0.75, 0.75], [0 0 0], 'Using cubic interpolation'); 
% 
%% nearest interpolation
plotScalpMap(bValues, chanlocs, 'nearest', ...
    true, [0.75, 0.75, 0.75], [0 0 0], 'Using nearest neighbor interpolation'); 

%% don't show colorbar
data = bValues;
plotScalpMap(bValues, chanlocs, 'v4', ...
    false, [0.75, 0.75, 0.75], [0 0 0], 'V4 interpolation no color bar'); 

%% black head color 
plotScalpMap(bValues, chanlocs, 'v4', ...
    true, [0 0 0], [0 0 0], 'V4 interpolation black head color'); 

%% white element color 
plotScalpMap(bValues, chanlocs, 'v4', ...
    true, [0.75, 0.75, 0.75], [1 1 1], 'V4 interpolation white head color'); 
