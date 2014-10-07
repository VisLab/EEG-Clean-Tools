% Version 0.15
% This version is still in progress and is the latest as of 9-29-14.
% It still needs:
%    1)  Automatic line noise peak finding --- approximate peaks now
%        have to be set.
%    2)  Elimination of places where signal is not recorded 
%        (e.g., bad on most or all channels.)
%    3)  Haven't decided how to pad the tapers for removing line noise
%        so there is always a small segment at end that is not cleaned.
%    4)  Haven't finalized how the results are reported.
%    5)  The thresholds are based on the assumption that only recorded
%        data is considered. In the next version the segments in which
%        a significant number of channels are bad will be excluded from
%        the threshold.
%
% Written by Kay Robbins October 3, 2014
%
% To run, call the standardLevel2Pipeline script. The
% runTestStandardLevel2VEP shows and an example of how to setup.
%
% Note: you must make sure that the EEGLAB is in the path and that 
% all the subdirectories of the stdLevel2 directory are in the path.
%
% The end of the standLevel2Pipeline has a commented line showing how to call the visualization.
% The script produces an array of times it took to compute each step.
%
%