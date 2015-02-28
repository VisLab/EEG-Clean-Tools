function data = testFilter(data, srate)

numberChannels = size(data, 2);
BHigh = design_fir(100,[0 2*[0.5 1 2]/srate 1],[0 0.25 1 1 1]);
parfor k = 1:numberChannels  % Could be changed to parfor
    data(:,k) = filtfilt_fast(BHigh, 1, data(:, k)); 
end
