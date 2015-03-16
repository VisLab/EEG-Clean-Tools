%% Example using ESS
ess2Dir = 'N:\ARLAnalysis\\NCTUPrep\\NCTUStandardized';
ess2File = [ess2Dir filesep 'studyLevel2_description.xml'];

%%  Load a level 2 ESS study for analysis
obj2 = level2Study('level2XmlFilePath', ess2File);
obj2.validate();

%% Get the information
[filenames, Uuids, taskLabels, sessionNumbers, subjects] = obj2.getFilename();
uniqueTasks = unique(taskLabels);

%%
filenames = obj2.getFilename();

