function [versionString, changeLog] = getPrepVersion()

versionString = 'PrepPipeline0.54.0'; 

changeLog = {'Added Blasst as a line noise removal option';  ...
             'Moved legend of spectrum to right, put in checks'; ...
             'Corrected bug in smoothing in cleanline'};