


params = struct();
params.lineFrequencies = [60, 120,  180, 212, 240];
params.referenceChannels = 1:64;
params.rereferencedChannels = 1:70;
params.highPassChannels = 1:70;
params.lineNoiseChannels = 1:70;
load('EEGtemp2.set', '-mat');

[EEG, computationTimes] = standardLevel2Pipeline(EEG, params);
fprintf('Computation times (seconds): %g high pass, %g resampling, %g line noise, %g reference \n', ...
        computationTimes.highPass, computationTimes.resampling, ...
        computationTimes.lineNoise, computationTimes.reference);
save('EEGTempNew2.set', 'EEG', '-mat', '-v7.3');

%%
summaryFolder = '.';
summaryReportName = ['vep_summary4.html'];
sessionFolder = '.';
reportSummary = [summaryFolder filesep summaryReportName];
sessionReportName = 'vep_summary4';
publishLevel2Report(EEG, summaryFolder, summaryReportName, ...
                  sessionFolder, sessionReportName);

%%              
summaryFolder = '.';
summaryReportName = ['ntcu_summary4.html'];
sessionFolder = '.';
sessionReportName = 'ntcu_summary4';
publishLevel2Report(EEG, summaryFolder, summaryReportName, ...
                  sessionFolder, sessionReportName);

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

standardLevel2Report;