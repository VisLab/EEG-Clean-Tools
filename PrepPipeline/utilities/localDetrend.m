function data = localDetrend(data, samplingRate, windowSize, stepSize)
%  Remove running line fit (using local linear regression)
%
%  Usage: data = removeLocalTrend(data, Fs, windowSize, stepSize)
%
%  Parameters:
%     data         Data as time x channels or a single vector  
%     samplingRate Sampling frequency in Hz
%     windowSize   Window size in seconds
%     stepSize     Window step size in seconds
%
% Output:
%     data:         (locally detrended data)
% fitlines       lines that fit the data
%
% NOTICE: This function is adapted from the open-source Chronux
% toolbox which can be downloaded from http://www.chronux.org/
%
% Modified version of Chronux_2 locdetrend by: Kay Robbins, 2015, UTSA
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

data = change_row_to_column(data);
[N, C] = size(data);
n = round(samplingRate*windowSize); % Points in the window
dn = round(samplingRate*stepSize);  % Points in the step
if dn > n || dn < 1 
    error('removeLocalTrend:badStepSize', ...
          'Step size must be <= window size and contain at least 1 sample'); 
end;
if n == N;
    data = detrend(data);
else
    parfor ch = 1:C
        data(:, ch) = data(:, ch) - runline(data(:, ch), n, dn);
    end;
end

