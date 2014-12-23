%% test NCTU


params = struct();
params.lineFrequencies = [60, 120,  180];
params.referenceChannels = 1:32;
params.rereferencedChannels = 1:32;
params.highPassChannels = 1:32;
params.lineNoiseChannels = 1:32;
%%
[EEG, computationTimes] = standardLevel2Pipeline(EEG, params);
fprintf('Computation times (seconds): %g high pass, %g resampling, %g line noise, %g reference \n', ...
        computationTimes.highPass, computationTimes.resampling, ...
        computationTimes.lineNoise, computationTimes.reference);
save('EEGNCTU_71ref.set', 'EEG', '-v7.3');

%%
% summaryFolder = '.';
% summaryReportName = ['vep_summary4.html'];
% sessionFolder = '.';
% reportSummary = [summaryFolder filesep summaryReportName];
% sessionReportName = 'vep_summary4';
% publishLevel2Report(EEG, summaryFolder, summaryReportName, ...
%                   sessionFolder, sessionReportName);
% 
% %%
% summaryFolder = '.';
% summaryReportName = ['nctu.html'];
% sessionFolder = '.';
% reportSummary = [summaryFolder filesep summaryReportName];
%   tempReportLocation = [summaryFolder filesep sessionFolder ...
%                                     filesep 'standardLevel2Report.pdf'];
%         actualReportLocation = [summaryFolder filesep sessionFolder ...
%                                     filesep sessionReportName];
%         summaryReportLocation = [summaryFolder filesep summaryReportName];
%         
%         summaryFile = fopen(summaryReportLocation, 'a+', 'n', 'UTF-8');
%         relativeReportLocation = [sessionFolder filesep sessionReportName];
%         consoleFID = 1;
%         assignin('base', 'summaryFile', summaryFile);
%         assignin('base', 'consoleID', consoleFID);
%         assignin('base', 'relativeReportLocation', relativeReportLocation);
% sessionReportName = 'nctu';
% standardLevel2Report;
%%
load('NCTU_1.set', '-mat');

%%
noisyOutOriginal = findNoisyChannels(EEG, params);

%%
[EEG, reference] = robustReference(EEG, params);
%%
[EEG, computationTimes] = standardLevel2Pipeline(EEG, params);
%%
summaryFolder = '.';
summaryReportName = ['nctu.html'];
sessionFolder = '.';
sessionReportName = 'nctu';
reportSummary = [summaryFolder filesep summaryReportName];
  tempReportLocation = [summaryFolder filesep sessionFolder ...
                                    filesep 'standardLevel2Report.pdf'];
        actualReportLocation = [summaryFolder filesep sessionFolder ...
                                    filesep sessionReportName];
        summaryReportLocation = [summaryFolder filesep summaryReportName];
        
        summaryFile = fopen(summaryReportLocation, 'a+', 'n', 'UTF-8');
        relativeReportLocation = [sessionFolder filesep sessionReportName];
        consoleFID = 1;
        assignin('base', 'summaryFile', summaryFile);
        assignin('base', 'consoleID', consoleFID);
        assignin('base', 'relativeReportLocation', relativeReportLocation);
sessionReportName = 'nctu';
standardLevel2Report;

%%
params = struct();
params.lineFrequencies = [60, 120,  180];
params.referenceChannels = 1:32;
params.rereferencedChannels = 1:32;
params.highPassChannels = 1:32;
params.lineNoiseChannels = 1:32;
%%
[EEG2, computationTimes] = standardLevel2Pipeline(EEG, params);
fprintf('Computation times (seconds): %g high pass, %g resampling, %g line noise, %g reference \n', ...
        computationTimes.highPass, computationTimes.resampling, ...
        computationTimes.lineNoise, computationTimes.reference);
save('EEGNCTU4standard.set', 'EEG', '-v7.3');

%%
 [EEG, reference] = ordinaryReference(EEG, params);