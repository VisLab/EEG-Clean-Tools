%% Visualize the EEG 
% The reporting function expects that EEG will be in the base workspace
% with an EEG.etc.noisyParameters structure containing the report. It
% also expects variables in the base workspace
% 
% - summaryReportName name of the summary report
% - summaryFolder folder where summary report goes
% 
% which contains the file name of a summary report. 
% The reporting function appends a summary to this report. 

%% Open the summary report file
summaryReportLocation = [summaryFolder filesep summaryReportName];
summaryFile = fopen(summaryReportLocation, 'a+', 'n', 'UTF-8');
relativeReportLocation = [sessionFolder filesep sessionReportName];

%% Output the report header
noisyParameters = EEG.etc.noisyParameters;
summaryHeader = [noisyParameters.name '[' ...
    num2str(size(EEG.data, 1)) ' channels, ' num2str(size(EEG.data, 2)) ' frames]'];
summaryHeader = [summaryHeader ' <a href="' relativeReportLocation ...
    '">Report details</a>'];
writeSummaryHeader(summaryFile,  summaryHeader);
writeSummaryItem(summaryFile, '', 'first');
%% Write overview status
writeSummaryItem(summaryFile, ...
      {['Error status: ' noisyParameters.errors.status]});
  
%% Setup visualization parameters
numbersPerRow = 15;
indent = '  ';
%% Report high pass filtering step
summary = reportHighPass(1, noisyParameters, numbersPerRow, indent);
writeSummaryItem(summaryFile, summary);
%% Report line noise removal step
summary = reportLineNoise(1, noisyParameters, numbersPerRow, indent);
writeSummaryItem(summaryFile, summary);
%% Spectrum after line noise removal
if isfield(noisyParameters, 'lineNoise')
    channels = noisyParameters.lineNoise.lineNoiseChannels;
    tString = noisyParameters.name;
    showSpectrum(EEG, channels, tString);
end
%% Report rereferencing step parameters
summary = reportReferenced(1, noisyParameters, numbersPerRow, indent);
writeSummaryItem(summaryFile, summary);

%% Visualize if the referenced existed
if isfield(noisyParameters, 'reference')
    showReferenced(summaryFile, noisyParameters.reference, ...
        noisyParameters.name, EEG.srate);
end

%% Close the summary file
writeSummaryItem(summaryFile, '', 'last');
fclose(summaryFile);